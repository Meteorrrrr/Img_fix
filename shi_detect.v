`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 19:43:46
// Design Name: 
// Module Name: shi_detect
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


module shi_detect(
    input clk,
    input en,
    input shi_en,
    input [7:0] row_cnt_in,
    input [8:0] col_cnt_in,
    input [7:0] g_11,
    input [7:0] g_10,
    input [7:0] g_9,
    input [7:0] g_8,
    input [7:0] g_7,
    input [7:0] g_6,
    input [7:0] g_5,
    input [7:0] g_4,
    input [7:0] g_3,
    input [7:0] g_2,
    input [7:0] g_1,
    input [7:0] g_0,
    output [14:0] score,
    output [7:0] store_11,
    output [7:0] store_10,
    output [7:0] store_9,
    output [7:0] store_8,
    output [7:0] store_7,
    output [7:0] store_6,
    output [7:0] store_5,
    output [7:0] store_4,
    output [7:0] store_3,
    output [7:0] store_2,
    output [7:0] store_1,
    output [7:0] store_0,
    output reg [7:0] row_cnt, //这两个是那个patch中心点的真实坐标值，也和patch一起存着先
    output reg [8:0] col_cnt
    );


parameter ROW = 240;
parameter COL = 376;
assign is_SHI = 1'b0;

reg [7:0] kernel [23:0];
always @(posedge clk or negedge en) begin
    if (!en) 
    begin: kernel_rst
        integer i;
        for(i=0;i<24;i=i+1) begin
            kernel[i] <= 1'b0;
        end
    end
    else 
        begin: kernel_inst
        integer i;
        kernel[23] <= g_9;
        kernel[20] <= g_8;
        kernel[17] <= g_7;
        kernel[14] <= g_6;
        kernel[11] <= g_5;
        kernel[8]  <= g_4;
        kernel[5]  <= g_3;
        kernel[2]  <= g_2;
        for(i=0;i<2;i=i+1) begin
            kernel[23-i-1] <= kernel[23-i];
            kernel[20-i-1] <= kernel[20-i];
            kernel[17-i-1] <= kernel[17-i];
            kernel[14-i-1] <= kernel[14-i];
            kernel[11-i-1] <= kernel[11-i]; 
            kernel[8-i-1]  <= kernel[8-i];
            kernel[5-i-1]  <= kernel[5-i];
            kernel[2-i-1]  <= kernel[2-i];
        end
    end
end

reg first_out;
always @(posedge clk or negedge en) begin
    if (!en) begin
        row_cnt <= 8'd7;
        col_cnt <= 9'd6;
        first_out <= 1'b0;
    end
    else begin
        if (first_out) begin
            col_cnt <= col_cnt + 1'b1;
            if (col_cnt == COL - 1) begin
                col_cnt <= 1'b0;
            end
            else begin
                col_cnt <= col_cnt + 1'b1;
            end
            if (row_cnt == ROW - 1 && col_cnt == COL - 1) begin // 在(752, 0)停止
                row_cnt <= 1'b0;    
                first_out <= 1'b0;
            end
            else begin
                if (col_cnt == COL - 1) begin
                    row_cnt <= row_cnt + 1'b1;
                end
                else begin
                    row_cnt <= row_cnt;
                end
            end
        end
        else if (row_cnt_in == 8'd2 && col_cnt_in == 9'd15) begin
            col_cnt <= 9'd7;
            first_out <= 1'b1;
        end
    end
end

wait_shi_long w_inst11(
    .CLK(clk),
    .D(g_11),
    .Q(store_11)
    );

wait_shi_long w_inst10(
    .CLK(clk),
    .D(g_10),
    .Q(store_10)
    );

wait_shi w_inst9(
    .CLK(clk),
    .D(kernel[21]),
    .Q(store_9)
    );

wait_shi w_inst8(
    .CLK(clk),
    .D(kernel[18]),
    .Q(store_8)
    );

wait_shi w_inst7(
    .CLK(clk),
    .D(kernel[15]),
    .Q(store_7)
    );

wait_shi w_inst6(
    .CLK(clk),
    .D(kernel[12]),
    .Q(store_6)
    );

wait_shi w_inst5(
    .CLK(clk),
    .D(kernel[9]),
    .Q(store_5)
    );

wait_shi w_inst4(
    .CLK(clk),
    .D(kernel[6]),
    .Q(store_4)
    );

wait_shi w_inst3(
    .CLK(clk),
    .D(kernel[3]),
    .Q(store_3)
    );

wait_shi w_inst2(
    .CLK(clk),
    .D(kernel[0]),
    .Q(store_2)
    );

wait_shi_long w_inst1(
    .CLK(clk),
    .D(g_1),
    .Q(store_1)
    );

wait_shi_long w_inst0(
    .CLK(clk),
    .D(g_0),
    .Q(store_0)
    );


// 本来进来的patch是12位的，减法之后可能会小于零，但是由于输入的都是要0.5倍的，因此直接右移两位，空出[11]作为符号位即可，
// 输出也需要符号位，因此有12位，随后是乘法，理论最多是16384 12位乘以12位，仍然有可能有负数，取输出的[22:4]共1+14+4位，输出由于需要累加，最后应该会到1+20+4=25位，高位作为符号位
// 
wire [8:0] grad_y_0_result;
wire [8:0] grad_y_1_result;
wire [8:0] grad_y_2_result;
wire [8:0] grad_y_3_result;
wire [8:0] grad_y_4_result;
wire [8:0] grad_y_5_result;
wire [8:0] grad_x_0_result;
wire [8:0] grad_x_1_result;
wire [8:0] grad_x_2_result;
wire [8:0] grad_x_3_result;
wire [8:0] grad_x_4_result;
wire [8:0] grad_x_5_result;
wire [15:0] J_yy_0_result;
wire [15:0] J_yy_1_result;
wire [15:0] J_yy_2_result;
wire [15:0] J_yy_3_result;
wire [15:0] J_yy_4_result;
wire [15:0] J_yy_5_result;
wire [15:0] J_xx_0_result;
wire [15:0] J_xx_1_result;
wire [15:0] J_xx_2_result;
wire [15:0] J_xx_3_result;
wire [15:0] J_xx_4_result;
wire [15:0] J_xx_5_result;
// wire [18:0] J_xy_0_result;
// wire [18:0] J_xy_1_result;
// wire [18:0] J_xy_2_result;
// wire [18:0] J_xy_3_result;
// wire [18:0] J_xy_4_result;
// wire [18:0] J_xy_5_result;
wire [16:0] add19_yy_0_result;
wire [16:0] add19_yy_1_result;
wire [16:0] add19_yy_2_result;
wire [17:0] add20_yy_0_result;
wire [18:0] add21_yy_0_result;

wire [16:0] add19_xx_0_result;
wire [16:0] add19_xx_1_result;
wire [16:0] add19_xx_2_result;
wire [17:0] add20_xx_0_result;
wire [18:0] add21_xx_0_result;

// wire [19:0] add19_xy_0_result;
// wire [19:0] add19_xy_1_result;
// wire [19:0] add19_xy_2_result;
// wire [20:0] add20_xy_0_result;
// wire [21:0] add21_xy_0_result;

wire [19:0] add22_yy_0_result;
wire [19:0] add22_yy_1_result;
wire [19:0] add22_yy_2_result;
wire [20:0] add23_yy_0_result;
wire [21:0] add24_yy_0_result; //H(1,1)

wire [19:0] add22_xx_0_result;
wire [19:0] add22_xx_1_result;
wire [19:0] add22_xx_2_result;
wire [20:0] add23_xx_0_result;
wire [21:0] add24_xx_0_result; //H(0,0)

wire [22:0] score_un;

// wire [22:0] add22_xy_0_result;
// wire [22:0] add22_xy_1_result;
// wire [22:0] add22_xy_2_result;
// wire [23:0] add23_xy_0_result;
// wire [24:0] add24_xy_0_result; //H(0,1)
// (1+20+4) * （无符号0+15全小数）
// 除以36之后，结果用1+13.+6共20位表示，不会超过8192
reg [18:0] stage_0_yy;
reg [18:0] stage_1_yy;
reg [18:0] stage_2_yy;
reg [18:0] stage_3_yy;
reg [18:0] stage_4_yy;
reg [18:0] stage_5_yy;
reg [18:0] stage_0_xx;
reg [18:0] stage_1_xx;
reg [18:0] stage_2_xx;
reg [18:0] stage_3_xx;
reg [18:0] stage_4_xx;
reg [18:0] stage_5_xx;
// reg [21:0] stage_0_xy;
// reg [21:0] stage_1_xy;
// reg [21:0] stage_2_xy;
// reg [21:0] stage_3_xy;
// reg [21:0] stage_4_xy;
// reg [21:0] stage_5_xy;

always @(posedge clk or negedge en) begin
    if (!en) begin
        stage_0_yy <= 1'b0;
        stage_1_yy <= 1'b0;
        stage_2_yy <= 1'b0;
        stage_3_yy <= 1'b0;
        stage_4_yy <= 1'b0;
        stage_5_yy <= 1'b0;
        stage_0_xx <= 1'b0;
        stage_1_xx <= 1'b0;
        stage_2_xx <= 1'b0;
        stage_3_xx <= 1'b0;
        stage_4_xx <= 1'b0;
        stage_5_xx <= 1'b0;
        // stage_0_xy <= 1'b0;
        // stage_1_xy <= 1'b0;
        // stage_2_xy <= 1'b0;
        // stage_3_xy <= 1'b0;
        // stage_4_xy <= 1'b0;
        // stage_5_xy <= 1'b0;
    end
    else begin
        stage_0_yy <= add21_yy_0_result;
        stage_1_yy <= stage_0_yy;
        stage_2_yy <= stage_1_yy;
        stage_3_yy <= stage_2_yy;
        stage_4_yy <= stage_3_yy;
        stage_5_yy <= stage_4_yy;

        stage_0_xx <= add21_xx_0_result;
        stage_1_xx <= stage_0_xx;
        stage_2_xx <= stage_1_xx;
        stage_3_xx <= stage_2_xx;
        stage_4_xx <= stage_3_xx;
        stage_5_xx <= stage_4_xx;

        // stage_0_xy <= add21_xy_0_result;
        // stage_1_xy <= stage_0_xy;
        // stage_2_xy <= stage_1_xy;
        // stage_3_xy <= stage_2_xy;
        // stage_4_xy <= stage_3_xy;
        // stage_5_xy <= stage_4_xy;
    end
end
grad_sub grad_y_0 (
    .A({1'b0, kernel[21]}),
    .B({1'b0, kernel[15]}),
    .S(grad_y_0_result)
    );
    
grad_sub grad_y_1 (
    .A({1'b0, kernel[18]}),
    .B({1'b0, kernel[12]}),
    .S(grad_y_1_result)
    );
    
grad_sub grad_y_2 (
    .A({1'b0, kernel[15]}),
    .B({1'b0, kernel[9]}),
    .S(grad_y_2_result)
    );
    
grad_sub grad_y_3 (
    .A({1'b0, kernel[12]}),
    .B({1'b0, kernel[6]}),
    .S(grad_y_3_result)
    );
    
grad_sub grad_y_4 (
    .A({1'b0, kernel[9]}),
    .B({1'b0, kernel[3]}),
    .S(grad_y_4_result)
    );
    
grad_sub grad_y_5 (
    .A({1'b0, kernel[6]}),
    .B({1'b0, kernel[0]}),
    .S(grad_y_5_result)
    );
    
grad_sub grad_x_0 (
    .A({1'b0, kernel[20]}),
    .B({1'b0, kernel[18]}),
    .S(grad_x_0_result)
    );
    
grad_sub grad_x_1 (
    .A({1'b0, kernel[17]}),
    .B({1'b0, kernel[15]}),
    .S(grad_x_1_result)
    );
    
grad_sub grad_x_2 (
    .A({1'b0, kernel[14]}),
    .B({1'b0, kernel[12]}),
    .S(grad_x_2_result)
    );
    
grad_sub grad_x_3 (
    .A({1'b0, kernel[11]}),
    .B({1'b0, kernel[9]}),
    .S(grad_x_3_result)
    );
    
grad_sub grad_x_4 (
    .A({1'b0, kernel[8]}),
    .B({1'b0, kernel[6]}),
    .S(grad_x_4_result)
    );
    
grad_sub grad_x_5 (
    .A({1'b0, kernel[5]}),
    .B({1'b0, kernel[3]}),
    .S(grad_x_5_result)
    );

J_mul grad_yy_0 (
    .A(grad_y_0_result),
    .B(grad_y_0_result),
    .P(J_yy_0_result)
    );
    
J_mul grad_yy_1 (
    .A(grad_y_1_result),
    .B(grad_y_1_result),
    .P(J_yy_1_result)
    );
    
J_mul grad_yy_2 (
    .A(grad_y_2_result),
    .B(grad_y_2_result),
    .P(J_yy_2_result)
    );
    
J_mul grad_yy_3 (
    .A(grad_y_3_result),
    .B(grad_y_3_result),
    .P(J_yy_3_result)
    );
    
J_mul grad_yy_4 (
    .A(grad_y_4_result),
    .B(grad_y_4_result),
    .P(J_yy_4_result)
    );
    
J_mul grad_yy_5 (
    .A(grad_y_5_result),
    .B(grad_y_5_result),
    .P(J_yy_5_result)
    );
    
J_mul grad_xx_0 (
    .A(grad_x_0_result),
    .B(grad_x_0_result),
    .P(J_xx_0_result)
    );
    
J_mul grad_xx_1 (
    .A(grad_x_1_result),
    .B(grad_x_1_result),
    .P(J_xx_1_result)
    );
    
J_mul grad_xx_2 (
    .A(grad_x_2_result),
    .B(grad_x_2_result),
    .P(J_xx_2_result)
    );
    
J_mul grad_xx_3 (
    .A(grad_x_3_result),
    .B(grad_x_3_result),
    .P(J_xx_3_result)
    );
    
J_mul grad_xx_4 (
    .A(grad_x_4_result),
    .B(grad_x_4_result),
    .P(J_xx_4_result)
    );
    
J_mul grad_xx_5 (
    .A(grad_x_5_result),
    .B(grad_x_5_result),
    .P(J_xx_5_result)
    );
    
// J_mul grad_xy_0 (
//     .A(grad_x_0_result),
//     .B(grad_y_0_result),
//     .S(J_xy_0_result)
//     );
    
// J_mul grad_xy_1 (
//     .A(grad_x_1_result),
//     .B(grad_y_1_result),
//     .S(J_xy_1_result)
//     );
    
// J_mul grad_xy_2 (
//     .A(grad_x_2_result),
//     .B(grad_y_2_result),
//     .S(J_xy_2_result)
//     );
    
// J_mul grad_xy_3 (
//     .A(grad_x_3_result),
//     .B(grad_y_3_result),
//     .S(J_xy_3_result)
//     );
    
// J_mul grad_xy_4 (
//     .A(grad_x_4_result),
//     .B(grad_y_4_result),
//     .S(J_xy_4_result)
//     );
    
// J_mul grad_xy_5 (
//     .A(grad_x_5_result),
//     .B(grad_y_5_result),
//     .S(J_xy_5_result)
//     );
    
group_add19 group_add19_yy_0 (
    .A(J_yy_0_result),
    .B(J_yy_1_result),
    .S(add19_yy_0_result)
    );

group_add19 group_add19_yy_1 (
    .A(J_yy_2_result),
    .B(J_yy_3_result),
    .S(add19_yy_1_result)
    );

group_add19 group_add19_yy_2 (
    .A(J_yy_4_result),
    .B(J_yy_5_result),
    .S(add19_yy_2_result)
    );

group_add20 group_add20_yy_0 (
    .A(add19_yy_0_result),
    .B(add19_yy_1_result),
    .S(add20_yy_0_result)
    );

group_add21 group_add21_yy_0 (
    .A(add20_yy_0_result),
    .B(add19_yy_2_result),
    .S(add21_yy_0_result)
    );

group_add19 group_add19_xx_0 (
    .A(J_xx_0_result),
    .B(J_xx_1_result),
    .S(add19_xx_0_result)
    );

group_add19 group_add19_xx_1 (
    .A(J_xx_2_result),
    .B(J_xx_3_result),
    .S(add19_xx_1_result)
    );

group_add19 group_add19_xx_2 (
    .A(J_xx_4_result),
    .B(J_xx_5_result),
    .S(add19_xx_2_result)
    );

group_add20 group_add20_xx_0 (
    .A(add19_xx_0_result),
    .B(add19_xx_1_result),
    .S(add20_xx_0_result)
    );

group_add21 group_add21_xx_0 (
    .A(add20_xx_0_result),
    .B(add19_xx_2_result),
    .S(add21_xx_0_result)
    );

// group_add19 group_add19_xy_0 (
//     .A(J_xy_0_result),
//     .B(J_xy_1_result),
//     .S(add19_xy_0_result)
//     );

// group_add19 group_add19_xy_1 (
//     .A(J_xy_2_result),
//     .B(J_xy_3_result),
//     .S(add19_xy_1_result)
//     );

// group_add19 group_add19_xy_2 (
//     .A(J_xy_4_result),
//     .B(J_xy_5_result),
//     .S(add19_xy_2_result)
//     );

// group_add20 group_add20_xy_0 (
//     .A(add19_xy_0_result),
//     .B(add19_xy_1_result),
//     .S(add20_xy_0_result)
//     );

// group_add21 group_add21_xy_0 (
//     .A(add20_xy_0_result),
//     .B(add19_xy_2_result),
//     .S(add21_xy_0_result)
//     );

group_add22 group_add22_yy_0 (
    .A(stage_0_yy),
    .B(stage_1_yy),
    .S(add22_yy_0_result)
    );

group_add22 group_add22_yy_1 (
    .A(stage_2_yy),
    .B(stage_3_yy),
    .S(add22_yy_1_result)
    );

group_add22 group_add22_yy_2 (
    .A(stage_4_yy),
    .B(stage_5_yy),
    .S(add22_yy_2_result)
    );

group_add23 group_add23_yy_0 (
    .A(add22_yy_0_result),
    .B(add22_yy_1_result),
    .S(add23_yy_0_result)
    );

group_add24 group_add24_yy_0 (
    .A(add23_yy_0_result),
    .B(add22_yy_2_result),
    .S(add24_yy_0_result)
    );

group_add22 group_add22_xx_0 (
    .A(stage_0_xx),
    .B(stage_1_xx),
    .S(add22_xx_0_result)
    );

group_add22 group_add22_xx_1 (
    .A(stage_2_xx),
    .B(stage_3_xx),
    .S(add22_xx_1_result)
    );

group_add22 group_add22_xx_2 (
    .A(stage_4_xx),
    .B(stage_5_xx),
    .S(add22_xx_2_result)
    );

group_add23 group_add23_xx_0 (
    .A(add22_xx_0_result),
    .B(add22_xx_1_result),
    .S(add23_xx_0_result)
    );

group_add24 group_add24_xx_0 (
    .A(add23_xx_0_result),
    .B(add22_xx_2_result),
    .S(add24_xx_0_result)
    );



// group_add22 group_add22_xy_0 (
//     .A(stage_0_xy),
//     .B(stage_1_xy),
//     .S(add22_xy_0_result)
//     );

// group_add22 group_add22_xy_1 (
//     .A(stage_2_xy),
//     .B(stage_3_xy),
//     .S(add22_xy_1_result)
//     );

// group_add22 group_add22_xy_2 (
//     .A(stage_4_xy),
//     .B(stage_5_xy),
//     .S(add22_xy_2_result)
//     );

// group_add23 group_add23_xy_0 (
//     .A(add22_xy_0_result),
//     .B(add22_xy_1_result),
//     .S(add23_xy_0_result)
//     );

// group_add24 group_add24_xy_0 (
//     .A(add23_xy_0_result),
//     .B(add22_xy_1_result),
//     .S(add24_xy_0_result)
//     );

group_add25 score_un_inst (
    .A(add24_yy_0_result),
    .B(add24_xx_0_result),
    .S(score_un)
    );

div_patchsize score_inst (
    .A(score_un),
    .P(score)
    );
endmodule
