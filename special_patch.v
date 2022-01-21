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


module special_patch (
    input clk,
    input en,
    input [7:0] row_cnt,
    input [8:0] col_cnt,
    input [14:0] new_score,
    input is_FAST,
    input active,
    input [14:0] worst_score,
    input [6:0] worst_id,
    input [239:0] ban_rows,
    input [375:0] ban_cols,
    output reg [6:0] renew_id
    );

reg [7:0] center_y;
reg [8:0] center_x;

// 避开边界情况
wire not_border = row_cnt >= 8'd7 && row_cnt <= 8'd233 && col_cnt >= 9'd7 && col_cnt <= 9'd369;
reg active_reg; // 代表这个电路是否被启用了，被第一次active即为启用，通过上一个电路的wr_en信号传递即可
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


always @(*) begin
    if((active_reg || active) && not_border) begin
        if (is_FAST && new_score > worst_score) begin
            renew_id = worst_id;
        end
        else begin
            renew_id = 7'd100;
        end
    end
    else begin
        renew_id = 7'd100;
    end
end


endmodule
