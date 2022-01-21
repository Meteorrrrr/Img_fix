`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/05 01:12:59
// Design Name: 
// Module Name: new_patch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//12345
module new_patch # (parameter ID_para=0)(
    input clk,
    input en,
    input [7:0] row_cnt,
    input [8:0] col_cnt,
    input [14:0] new_score,
    input is_FAST,
    input active,
    input [239:0] ban_rows,
    input [375:0] ban_cols,
    input [6:0] renew_id,
    output next_active,
    output wr_en,
    output [14:0] output_score,
    output [6:0] ID
    );
assign ID = ID_para;
reg [14:0] last_score;
reg [7:0] center_y;
reg [8:0] center_x;

// 现在先判断一下进来的点是否是FAST(optional)且是否在region内
// 如果是在判断同一行的东西，使用16x16的region，如果是在判断不同行的邻域点，则使用8x8的region，这里加入了FAST判断，直接把不是FAST的角点排除在邻域之外了
wire is_region_16 = (row_cnt >= center_y - 8'd7 && row_cnt <= center_y + 8'd8 && col_cnt >= center_x - 9'd7 && col_cnt <= center_x + 9'd8) && is_FAST; // 16x16 region
wire is_region_8 = (row_cnt >= center_y - 8'd3 && row_cnt <= center_y + 8'd4 && col_cnt >= center_x - 9'd3 && col_cnt <= center_x + 9'd4) && is_FAST; // 8x8 region
// 避开边界情况
wire not_border = row_cnt >= 8'd7 && row_cnt <= 8'd233 && col_cnt >= 9'd7 && col_cnt <= 9'd369;
reg active_reg; // 代表这个电路是否被启用了，被第一次active即为启用，通过上一个电路的wr_en信号传递即可
//对于第一个块module，直接把active赋值成1
wire ban;
assign ban = ban_rows[row_cnt] == 1'b1 && ban_cols[col_cnt] == 1'b1 ? 1'b1 : 1'b0;
always @(posedge clk or negedge en) begin
    if (!en) begin
        active_reg <= 1'b0;
    end
    else begin
        if (active) begin
            active_reg <= 1'b1;
        end
        else begin
            active_reg <= active_reg;
        end
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        center_y <= 1'b0;
        center_x <= 1'b0;     
        last_score <= 1'b0;   
    end
    else if((active_reg || active) && not_border) begin
        if (renew_id == ID) begin
            last_score <= new_score;
            center_y <= row_cnt;
            center_x <= col_cnt;
        end
        else if(center_x == 1'b0 && center_y == 1'b0 && new_score > 1'b0) begin // 首次启用的时候，由于(y, x)为初值(0,0)所以要给他们直接赋值，并且也给Score赋值
            if (is_FAST && !ban) begin
                last_score <= new_score;
                center_y <= row_cnt;
                center_x <= col_cnt;
            end
            else begin // 如果不是FAST，则需要等待到第一个FAST认证点进来
                last_score <= last_score;
                center_y <= center_y;
                center_x <= center_x;
            end
        end
        else begin // 不是
            if(((row_cnt == center_y && is_region_16) || (row_cnt != center_y && is_region_8)) && new_score > last_score) begin
                last_score <= new_score;
                center_y <= row_cnt;
                center_x <= col_cnt;
            end
            else begin
                last_score <= last_score;
                center_y <= center_y;
                center_x <= center_x;
            end
        end
    end
end

//满足region的条件并且分数达到要求
assign wr_en = ((active_reg || active) && not_border && ((row_cnt == center_y && is_region_16) || (row_cnt != center_y && is_region_8) || (center_x == 1'b0 && center_y == 1'b0 && is_FAST && !ban)) && new_score > last_score) || renew_id == ID;
assign output_score = wr_en ? new_score : last_score;

//当到来的点比当前中心点横坐标传递给下一个patch电路，告知需要其激活用于下一个块
reg wr_en_reg;
always @(posedge clk or negedge en) begin
    if (!en) begin
        wr_en_reg <= 1'b0;
    end
    else begin
        if (wr_en) begin
            wr_en_reg <= 1'b1;
        end
        else begin
            wr_en_reg <= wr_en_reg;
        end
    end
end

assign next_active = wr_en_reg && ((row_cnt == center_y && col_cnt > center_x && col_cnt - center_x > 9'd8) || (center_y > 1'b0 && row_cnt > center_y));
endmodule
