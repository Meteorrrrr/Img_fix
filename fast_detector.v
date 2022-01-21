`timescale 1ns / 1ps
module fast_detector(
    input clk,
    input en,
    input [7:0] row_cnt,
    input [8:0] col_cnt,
    input [7:0] f_6,
    input [7:0] f_5,
    input [7:0] f_4,
    input [7:0] f_3,
    input [7:0] f_2,
    input [7:0] f_1,
    input [7:0] f_0,
    output is_FAST
    );

parameter WIDTH = 8;
parameter ROW = 240;
parameter COL = 376;
parameter TH = 25;

reg [7:0] fast_row_cnt;
reg [8:0] fast_col_cnt;
reg start_cnt;
always @(posedge clk or negedge en) begin
    if (!en) begin
        fast_row_cnt <= 8'd7;
        fast_col_cnt <= 9'd6;
        start_cnt <= 1'b0;
    end
    else begin
        if (start_cnt) begin
            fast_col_cnt <= fast_col_cnt + 1'b1;
            if (fast_col_cnt == COL - 1) begin
                fast_col_cnt <= 1'b0;
            end
            else begin
                fast_col_cnt <= fast_col_cnt + 1'b1;
            end
            if (fast_row_cnt == ROW - 1 && fast_col_cnt == COL - 1) begin // 在(752, 0)停止
                fast_row_cnt <= 1'b0;    
                start_cnt <= 1'b0;
            end
            else begin
                if (fast_col_cnt == COL - 1) begin
                    fast_row_cnt <= fast_row_cnt + 1'b1;
                end
                else begin
                    fast_row_cnt <= fast_row_cnt;
                end
            end
        end
        else if (row_cnt == 8'd1 && col_cnt == 9'd33) begin
            fast_col_cnt <= 9'd7;
            start_cnt <= 1'b1;
        end
    end
end

reg [WIDTH-1:0] kernel [48:0];
always @(posedge clk or negedge en) begin
    if (!en) 
    begin: kernel_rst
        integer i;
        for(i=0;i<48;i=i+1) begin
            kernel[i] <= 1'b0;
        end
    end
    else 
        begin: kernel_inst
        integer i;
        kernel[48] <= f_6;
        kernel[41] <= f_5;
        kernel[34] <= f_4;
        kernel[27] <= f_3;
        kernel[20] <= f_2;
        kernel[13] <= f_1;
        kernel[6]  <= f_0;
        for(i=0;i<6;i=i+1) begin
            kernel[48-i-1] <= kernel[48-i];
            kernel[41-i-1] <= kernel[41-i];
            kernel[34-i-1] <= kernel[34-i];
            kernel[27-i-1] <= kernel[27-i];
            kernel[20-i-1] <= kernel[20-i];
            kernel[13-i-1] <= kernel[13-i];
            kernel[6-i-1]  <= kernel[6-i];
        end
    end
end




reg is_fast_before_8;
reg is_fast_before_9;
reg is_fast_before_10;
reg is_fast_before_11;
reg is_fast_before_12;
reg is_fast_before_13;
reg is_fast_before_14;
reg is_fast_before_15;
reg is_fast_before_16;
reg is_fast_before_17;
reg is_fast_before_18;
reg is_fast_before_19;
reg is_fast_before_20;
reg is_fast_before_21;
reg is_fast_before_22;
reg is_fast_before_23;
// pipeline 0 start
wire [7:0] pixel [15:0];
wire [7:0] center;
assign center = kernel[24];
assign pixel[0]  =  kernel[3];
assign pixel[1]  =  kernel[4];
assign pixel[2]  =  kernel[12];
assign pixel[3]  =  kernel[20];
assign pixel[4]  = kernel[27];
assign pixel[5]  = kernel[34];
assign pixel[6]  = kernel[40];
assign pixel[7]  = kernel[46];
assign pixel[8]  = kernel[45];
assign pixel[9]  = kernel[44];
assign pixel[10] = kernel[36];
assign pixel[11] = kernel[28];
assign pixel[12] = kernel[21];
assign pixel[13] = kernel[14];
assign pixel[14] = kernel[8];
assign pixel[15] = kernel[2];
wire [7:0] center_bright;
wire [7:0] center_dark;
assign center_bright = (8'd255 - TH) >= center ? (center + TH) : 8'd255;
assign center_dark = center >= TH ? (center - TH) : 8'd0;
reg [4:0] judge_cnt_0;

always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_0 <= 1'b0;
    end
    else begin
        if (pixel[0] > center_bright || pixel[0] < center_dark) begin
            judge_cnt_0 <= 1'b1;
        end
        else begin
            judge_cnt_0 <= 1'b0;
        end
    end
end
// pipeline 0 end

//pipeline_1 start
reg [7:0] pixel_1[15:0];
reg [7:0] center_1;
reg [4:0] judge_cnt_1;
wire [7:0] center_bright_1;
wire [7:0] center_dark_1;
assign center_bright_1 = (8'd255 - TH) >= center_1 ? (center_1 + TH) : 8'd255;
assign center_dark_1 = center_1 >= TH ? (center_1 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_1
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_1[i] <= 1'b0;
        end
    end
    else begin: pi_1
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_1[i] <= pixel[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_1 <= 1'b0;
    end
    else begin
        if ((judge_cnt_0 == 1'b0 && (pixel_1[1] > center_bright_1 || pixel_1[1] < center_dark_1)) || (pixel_1[0] < center_dark_1 && pixel_1[1] < center_dark_1) || (pixel_1[0] > center_bright_1 && pixel_1[1] > center_bright_1)) begin
            judge_cnt_1 <= judge_cnt_0 + 1'b1;
        end
        else begin
            judge_cnt_1 <= 1'b0;
        end
    end
end
//pipeline_1 end
//pipeline_2 start
reg [7:0] pixel_2[15:0];
reg [7:0] center_2;
reg [4:0] judge_cnt_2;
wire [7:0] center_bright_2;
wire [7:0] center_dark_2;
assign center_bright_2 = (8'd255 - TH) >= center_2 ? (center_2 + TH) : 8'd255;
assign center_dark_2 = center_2 >= TH ? (center_2 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_2
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_2[i] <= 1'b0;
        end
    end
    else begin: pi_2
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_2[i] <= pixel_1[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_2 <= 1'b0;
    end
    else begin
        if ((judge_cnt_1 == 1'b0 && (pixel_2[2] > center_bright_2 || pixel_2[2] < center_dark_2)) || (pixel_2[1] < center_dark_2 && pixel_2[2] < center_dark_2) || (pixel_2[1] > center_bright_2 && pixel_2[2] > center_bright_2)) begin
            judge_cnt_2 <= judge_cnt_1 + 1'b1;
        end
        else begin
            judge_cnt_2 <= 1'b0;
        end
    end
end
//pipeline_2 end
//pipeline_3 start
reg [7:0] pixel_3[15:0];
reg [7:0] center_3;
reg [4:0] judge_cnt_3;
wire [7:0] center_bright_3;
wire [7:0] center_dark_3;
assign center_bright_3 = (8'd255 - TH) >= center_3 ? (center_3 + TH) : 8'd255;
assign center_dark_3 = center_3 >= TH ? (center_3 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_3
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_3[i] <= 1'b0;
        end
    end
    else begin: pi_3
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_3[i] <= pixel_2[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_3 <= 1'b0;
    end
    else begin
        if ((judge_cnt_2 == 1'b0 && (pixel_3[3] > center_bright_3 || pixel_3[3] < center_dark_3)) || (pixel_3[2] < center_dark_3 && pixel_3[3] < center_dark_3) || (pixel_3[2] > center_bright_3 && pixel_3[3] > center_bright_3)) begin
            judge_cnt_3 <= judge_cnt_2 + 1'b1;
        end
        else begin
            judge_cnt_3 <= 1'b0;
        end
    end
end
//pipeline_3 end
//pipeline_4 start
reg [7:0] pixel_4[15:0];
reg [7:0] center_4;
reg [4:0] judge_cnt_4;
wire [7:0] center_bright_4;
wire [7:0] center_dark_4;
assign center_bright_4 = (8'd255 - TH) >= center_4 ? (center_4 + TH) : 8'd255;
assign center_dark_4 = center_4 >= TH ? (center_4 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_4
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_4[i] <= 1'b0;
        end
    end
    else begin: pi_4
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_4[i] <= pixel_3[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_4 <= 1'b0;
    end
    else begin
        if ((judge_cnt_3 == 1'b0 && (pixel_4[4] > center_bright_4 || pixel_4[4] < center_dark_4)) || (pixel_4[3] < center_dark_4 && pixel_4[4] < center_dark_4) || (pixel_4[3] > center_bright_4 && pixel_4[4] > center_bright_4)) begin
            judge_cnt_4 <= judge_cnt_3 + 1'b1;
        end
        else begin
            judge_cnt_4 <= 1'b0;
        end
    end
end
//pipeline_4 end
//pipeline_5 start
reg [7:0] pixel_5[15:0];
reg [7:0] center_5;
reg [4:0] judge_cnt_5;
wire [7:0] center_bright_5;
wire [7:0] center_dark_5;
assign center_bright_5 = (8'd255 - TH) >= center_5 ? (center_5 + TH) : 8'd255;
assign center_dark_5 = center_5 >= TH ? (center_5 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_5
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_5[i] <= 1'b0;
        end
    end
    else begin: pi_5
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_5[i] <= pixel_4[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_5 <= 1'b0;
    end
    else begin
        if ((judge_cnt_4 == 1'b0 && (pixel_5[5] > center_bright_5 || pixel_5[5] < center_dark_5)) || (pixel_5[4] < center_dark_5 && pixel_5[5] < center_dark_5) || (pixel_5[4] > center_bright_5 && pixel_5[5] > center_bright_5)) begin
            judge_cnt_5 <= judge_cnt_4 + 1'b1;
        end
        else begin
            judge_cnt_5 <= 1'b0;
        end
    end
end
//pipeline_5 end
//pipeline_6 start
reg [7:0] pixel_6[15:0];
reg [7:0] center_6;
reg [4:0] judge_cnt_6;
wire [7:0] center_bright_6;
wire [7:0] center_dark_6;
assign center_bright_6 = (8'd255 - TH) >= center_6 ? (center_6 + TH) : 8'd255;
assign center_dark_6 = center_6 >= TH ? (center_6 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_6
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_6[i] <= 1'b0;
        end
    end
    else begin: pi_6
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_6[i] <= pixel_5[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_6 <= 1'b0;
    end
    else begin
        if ((judge_cnt_5 == 1'b0 && (pixel_6[6] > center_bright_6 || pixel_6[6] < center_dark_6)) || (pixel_6[5] < center_dark_6 && pixel_6[6] < center_dark_6) || (pixel_6[5] > center_bright_6 && pixel_6[6] > center_bright_6)) begin
            judge_cnt_6 <= judge_cnt_5 + 1'b1;
        end
        else begin
            judge_cnt_6 <= 1'b0;
        end
    end
end
//pipeline_6 end
//pipeline_7 start
reg [7:0] pixel_7[15:0];
reg [7:0] center_7;
reg [4:0] judge_cnt_7;
wire [7:0] center_bright_7;
wire [7:0] center_dark_7;
assign center_bright_7 = (8'd255 - TH) >= center_7 ? (center_7 + TH) : 8'd255;
assign center_dark_7 = center_7 >= TH ? (center_7 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_7
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_7[i] <= 1'b0;
        end
    end
    else begin: pi_7
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_7[i] <= pixel_6[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_7 <= 1'b0;
    end
    else begin
        if ((judge_cnt_6 == 1'b0 && (pixel_7[7] > center_bright_7 || pixel_7[7] < center_dark_7)) || (pixel_7[6] < center_dark_7 && pixel_7[7] < center_dark_7) || (pixel_7[6] > center_bright_7 && pixel_7[7] > center_bright_7)) begin
            judge_cnt_7 <= judge_cnt_6 + 1'b1;
        end
        else begin
            judge_cnt_7 <= 1'b0;
        end
    end
end
//pipeline_7 end
//pipeline_8 start
reg [7:0] pixel_8[15:0];
reg [7:0] center_8;
reg [4:0] judge_cnt_8;
wire [7:0] center_bright_8;
wire [7:0] center_dark_8;
assign center_bright_8 = (8'd255 - TH) >= center_8 ? (center_8 + TH) : 8'd255;
assign center_dark_8 = center_8 >= TH ? (center_8 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_8
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_8[i] <= 1'b0;
        end
    end
    else begin: pi_8
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_8[i] <= pixel_7[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_8 <= 1'b0;
        is_fast_before_8 <= 1'b0;
    end
    else begin
        if ((judge_cnt_7 == 1'b0 && (pixel_8[8] > center_bright_8 || pixel_8[8] < center_dark_8)) || (pixel_8[7] < center_dark_8 && pixel_8[8] < center_dark_8) || (pixel_8[7] > center_bright_8 && pixel_8[8] > center_bright_8)) begin
            judge_cnt_8 <= judge_cnt_7 + 1'b1;
            if (judge_cnt_7 + 1'b1 >= 4'd9) begin
                is_fast_before_8 <= 1'b1;
            end
            else begin
                is_fast_before_8 <= 1'b0;
            end
        end
        else begin
            is_fast_before_8 <= 1'b0;
            judge_cnt_8 <= 1'b0;
        end
    end
end
//pipeline_8 end
//pipeline_9 start
reg [7:0] pixel_9[15:0];
reg [7:0] center_9;
reg [4:0] judge_cnt_9;
wire [7:0] center_bright_9;
wire [7:0] center_dark_9;
assign center_bright_9 = (8'd255 - TH) >= center_9 ? (center_9 + TH) : 8'd255;
assign center_dark_9 = center_9 >= TH ? (center_9 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_9
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_9[i] <= 1'b0;
        end
    end
    else begin: pi_9
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_9[i] <= pixel_8[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_9 <= 1'b0;
        is_fast_before_9 <= 1'b0;
    end
    else begin
        if ((judge_cnt_8 == 1'b0 && (pixel_9[9] > center_bright_9 || pixel_9[9] < center_dark_9)) || (pixel_9[8] < center_dark_9 && pixel_9[9] < center_dark_9) || (pixel_9[8] > center_bright_9 && pixel_9[9] > center_bright_9)) begin
            judge_cnt_9 <= judge_cnt_8 + 1'b1;
            if (judge_cnt_8 + 1'b1 >= 4'd9 || is_fast_before_8 == 1'b1) begin
                is_fast_before_9 <= 1'b1;
            end
            else begin
                is_fast_before_9 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_8 == 1'b1) begin
                is_fast_before_9 <= 1'b1;
            end
            else begin
                is_fast_before_9 <= 1'b0;
            end
            judge_cnt_9 <= 1'b0;
        end
    end
end
//pipeline_9 end
//pipeline_10 start
reg [7:0] pixel_10[15:0];
reg [7:0] center_10;
reg [4:0] judge_cnt_10;
wire [7:0] center_bright_10;
wire [7:0] center_dark_10;
assign center_bright_10 = (8'd255 - TH) >= center_10 ? (center_10 + TH) : 8'd255;
assign center_dark_10 = center_10 >= TH ? (center_10 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_10
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_10[i] <= 1'b0;
        end
    end
    else begin: pi_10
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_10[i] <= pixel_9[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_10 <= 1'b0;
        is_fast_before_10 <= 1'b0;
    end
    else begin
        if ((judge_cnt_9 == 1'b0 && (pixel_10[10] > center_bright_10 || pixel_10[10] < center_dark_10)) || (pixel_10[9] < center_dark_10 && pixel_10[10] < center_dark_10) || (pixel_10[9] > center_bright_10 && pixel_10[10] > center_bright_10)) begin
            judge_cnt_10 <= judge_cnt_9 + 1'b1;
            if (judge_cnt_9 + 1'b1 >= 4'd9 || is_fast_before_9 == 1'b1) begin
                is_fast_before_10 <= 1'b1;
            end
            else begin
                is_fast_before_10 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_9 == 1'b1) begin
                is_fast_before_10 <= 1'b1;
            end
            else begin
                is_fast_before_10 <= 1'b0;
            end
            judge_cnt_10 <= 1'b0;
        end
    end
end
//pipeline_10 end
//pipeline_11 start
reg [7:0] pixel_11[15:0];
reg [7:0] center_11;
reg [4:0] judge_cnt_11;
wire [7:0] center_bright_11;
wire [7:0] center_dark_11;
assign center_bright_11 = (8'd255 - TH) >= center_11 ? (center_11 + TH) : 8'd255;
assign center_dark_11 = center_11 >= TH ? (center_11 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_11
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_11[i] <= 1'b0;
        end
    end
    else begin: pi_11
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_11[i] <= pixel_10[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_11 <= 1'b0;
        is_fast_before_11 <= 1'b0;
    end
    else begin
        if ((judge_cnt_10 == 1'b0 && (pixel_11[11] > center_bright_11 || pixel_11[11] < center_dark_11)) || (pixel_11[10] < center_dark_11 && pixel_11[11] < center_dark_11) || (pixel_11[10] > center_bright_11 && pixel_11[11] > center_bright_11)) begin
            judge_cnt_11 <= judge_cnt_10 + 1'b1;
            if (judge_cnt_10 + 1'b1 >= 4'd9 || is_fast_before_10 == 1'b1) begin
                is_fast_before_11 <= 1'b1;
            end
            else begin
                is_fast_before_11 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_10 == 1'b1) begin
                is_fast_before_11 <= 1'b1;
            end
            else begin
                is_fast_before_11 <= 1'b0;
            end
            judge_cnt_11 <= 1'b0;
        end
    end
end
//pipeline_11 end
//pipeline_12 start
reg [7:0] pixel_12[15:0];
reg [7:0] center_12;
reg [4:0] judge_cnt_12;
wire [7:0] center_bright_12;
wire [7:0] center_dark_12;
assign center_bright_12 = (8'd255 - TH) >= center_12 ? (center_12 + TH) : 8'd255;
assign center_dark_12 = center_12 >= TH ? (center_12 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_12
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_12[i] <= 1'b0;
        end
    end
    else begin: pi_12
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_12[i] <= pixel_11[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_12 <= 1'b0;
        is_fast_before_12 <= 1'b0;
    end
    else begin
        if ((judge_cnt_11 == 1'b0 && (pixel_12[12] > center_bright_12 || pixel_12[12] < center_dark_12)) || (pixel_12[11] < center_dark_12 && pixel_12[12] < center_dark_12) || (pixel_12[11] > center_bright_12 && pixel_12[12] > center_bright_12)) begin
            judge_cnt_12 <= judge_cnt_11 + 1'b1;
            if (judge_cnt_11 + 1'b1 >= 4'd9 || is_fast_before_11 == 1'b1) begin
                is_fast_before_12 <= 1'b1;
            end
            else begin
                is_fast_before_12 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_11 == 1'b1) begin
                is_fast_before_12 <= 1'b1;
            end
            else begin
                is_fast_before_12 <= 1'b0;
            end
            judge_cnt_12 <= 1'b0;
        end
    end
end
//pipeline_12 end
//pipeline_13 start
reg [7:0] pixel_13[15:0];
reg [7:0] center_13;
reg [4:0] judge_cnt_13;
wire [7:0] center_bright_13;
wire [7:0] center_dark_13;
assign center_bright_13 = (8'd255 - TH) >= center_13 ? (center_13 + TH) : 8'd255;
assign center_dark_13 = center_13 >= TH ? (center_13 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_13
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_13[i] <= 1'b0;
        end
    end
    else begin: pi_13
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_13[i] <= pixel_12[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_13 <= 1'b0;
        is_fast_before_13 <= 1'b0;
    end
    else begin
        if ((judge_cnt_12 == 1'b0 && (pixel_13[13] > center_bright_13 || pixel_13[13] < center_dark_13)) || (pixel_13[12] < center_dark_13 && pixel_13[13] < center_dark_13) || (pixel_13[12] > center_bright_13 && pixel_13[13] > center_bright_13)) begin
            judge_cnt_13 <= judge_cnt_12 + 1'b1;
            if (judge_cnt_12 + 1'b1 >= 4'd9 || is_fast_before_12 == 1'b1) begin
                is_fast_before_13 <= 1'b1;
            end
            else begin
                is_fast_before_13 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_12 == 1'b1) begin
                is_fast_before_13 <= 1'b1;
            end
            else begin
                is_fast_before_13 <= 1'b0;
            end
            judge_cnt_13 <= 1'b0;
        end
    end
end
//pipeline_13 end
//pipeline_14 start
reg [7:0] pixel_14[15:0];
reg [7:0] center_14;
reg [4:0] judge_cnt_14;
wire [7:0] center_bright_14;
wire [7:0] center_dark_14;
assign center_bright_14 = (8'd255 - TH) >= center_14 ? (center_14 + TH) : 8'd255;
assign center_dark_14 = center_14 >= TH ? (center_14 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_14
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_14[i] <= 1'b0;
        end
    end
    else begin: pi_14
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_14[i] <= pixel_13[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_14 <= 1'b0;
        is_fast_before_14 <= 1'b0;
    end
    else begin
        if ((judge_cnt_13 == 1'b0 && (pixel_14[14] > center_bright_14 || pixel_14[14] < center_dark_14)) || (pixel_14[13] < center_dark_14 && pixel_14[14] < center_dark_14) || (pixel_14[13] > center_bright_14 && pixel_14[14] > center_bright_14)) begin
            judge_cnt_14 <= judge_cnt_13 + 1'b1;
            if (judge_cnt_13 + 1'b1 >= 4'd9 || is_fast_before_13 == 1'b1) begin
                is_fast_before_14 <= 1'b1;
            end
            else begin
                is_fast_before_14 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_13 == 1'b1) begin
                is_fast_before_14 <= 1'b1;
            end
            else begin
                is_fast_before_14 <= 1'b0;
            end
            judge_cnt_14 <= 1'b0;
        end
    end
end
//pipeline_14 end
//pipeline_15 start
reg [7:0] pixel_15[15:0];
reg [7:0] center_15;
reg [4:0] judge_cnt_15;
wire [7:0] center_bright_15;
wire [7:0] center_dark_15;
assign center_bright_15 = (8'd255 - TH) >= center_15 ? (center_15 + TH) : 8'd255;
assign center_dark_15 = center_15 >= TH ? (center_15 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_15
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_15[i] <= 1'b0;
        end
    end
    else begin: pi_15
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_15[i] <= pixel_14[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_15 <= 1'b0;
        is_fast_before_15 <= 1'b0;
    end
    else begin
        if ((judge_cnt_14 == 1'b0 && (pixel_15[15] > center_bright_15 || pixel_15[15] < center_dark_15)) || (pixel_15[14] < center_dark_15 && pixel_15[15] < center_dark_15) || (pixel_15[14] > center_bright_15 && pixel_15[15] > center_bright_15)) begin
            judge_cnt_15 <= judge_cnt_14 + 1'b1;
            if (judge_cnt_14 + 1'b1 >= 4'd9 || is_fast_before_14 == 1'b1) begin
                is_fast_before_15 <= 1'b1;
            end
            else begin
                is_fast_before_15 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_14 == 1'b1) begin
                is_fast_before_15 <= 1'b1;
            end
            else begin
                is_fast_before_15 <= 1'b0;
            end
            judge_cnt_15 <= 1'b0;
        end
    end
end
//pipeline_15 end

//pipeline_16 start
reg [7:0] pixel_16[15:0];
reg [7:0] center_16;
reg [4:0] judge_cnt_16;
wire [7:0] center_bright_16;
wire [7:0] center_dark_16;
assign center_bright_16 = (8'd255 - TH) >= center_16 ? (center_16 + TH) : 8'd255;
assign center_dark_16 = center_16 >= TH ? (center_16 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_16
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_16[i] <= 1'b0;
        end
    end
    else begin: pi_16
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_16[i] <= pixel_15[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_16 <= 1'b0;
        is_fast_before_16 <= 1'b0;
    end
    else begin
        if ((judge_cnt_15 == 1'b0 && (pixel_16[0] > center_bright_16 || pixel_16[0] < center_dark_16)) || (pixel_16[15] < center_dark_16 && pixel_16[0] < center_dark_16) || (pixel_16[15] > center_bright_16 && pixel_16[0] > center_bright_16)) begin
            judge_cnt_16 <= judge_cnt_15 + 1'b1;
            if (judge_cnt_15 + 1'b1 >= 4'd9 || is_fast_before_15 == 1'b1) begin
                is_fast_before_16 <= 1'b1;
            end
            else begin
                is_fast_before_16 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_15 == 1'b1) begin
                is_fast_before_16 <= 1'b1;
            end
            else begin
                is_fast_before_16 <= 1'b0;
            end
            judge_cnt_16 <= 1'b0;
        end
    end
end
//pipeline_16 end
//pipeline_17 start
reg [7:0] pixel_17[15:0];
reg [7:0] center_17;
reg [4:0] judge_cnt_17;
wire [7:0] center_bright_17;
wire [7:0] center_dark_17;
assign center_bright_17 = (8'd255 - TH) >= center_17 ? (center_17 + TH) : 8'd255;
assign center_dark_17 = center_17 >= TH ? (center_17 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_17
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_17[i] <= 1'b0;
        end
    end
    else begin: pi_17
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_17[i] <= pixel_16[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_17 <= 1'b0;
        is_fast_before_17 <= 1'b0;
    end
    else begin
        if ((judge_cnt_16 == 1'b0 && (pixel_17[1] > center_bright_17 || pixel_17[1] < center_dark_17)) || (pixel_17[0] < center_dark_17 && pixel_17[1] < center_dark_17) || (pixel_17[0] > center_bright_17 && pixel_17[1] > center_bright_17)) begin
            judge_cnt_17 <= judge_cnt_16 + 1'b1;
            if (judge_cnt_16 + 1'b1 >= 4'd9 || is_fast_before_16 == 1'b1) begin
                is_fast_before_17 <= 1'b1;
            end
            else begin
                is_fast_before_17 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_16 == 1'b1) begin
                is_fast_before_17 <= 1'b1;
            end
            else begin
                is_fast_before_17 <= 1'b0;
            end
            judge_cnt_17 <= 1'b0;
        end
    end
end
//pipeline_17 end
//pipeline_18 start
reg [7:0] pixel_18[15:0];
reg [7:0] center_18;
reg [4:0] judge_cnt_18;
wire [7:0] center_bright_18;
wire [7:0] center_dark_18;
assign center_bright_18 = (8'd255 - TH) >= center_18 ? (center_18 + TH) : 8'd255;
assign center_dark_18 = center_18 >= TH ? (center_18 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_18
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_18[i] <= 1'b0;
        end
    end
    else begin: pi_18
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_18[i] <= pixel_17[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_18 <= 1'b0;
        is_fast_before_18 <= 1'b0;
    end
    else begin
        if ((judge_cnt_17 == 1'b0 && (pixel_18[2] > center_bright_18 || pixel_18[2] < center_dark_18)) || (pixel_18[1] < center_dark_18 && pixel_18[2] < center_dark_18) || (pixel_18[1] > center_bright_18 && pixel_18[2] > center_bright_18)) begin
            judge_cnt_18 <= judge_cnt_17 + 1'b1;
            if (judge_cnt_17 + 1'b1 >= 4'd9 || is_fast_before_17 == 1'b1) begin
                is_fast_before_18 <= 1'b1;
            end
            else begin
                is_fast_before_18 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_17 == 1'b1) begin
                is_fast_before_18 <= 1'b1;
            end
            else begin
                is_fast_before_18 <= 1'b0;
            end
            judge_cnt_18 <= 1'b0;
        end
    end
end
//pipeline_18 end
//pipeline_19 start
reg [7:0] pixel_19[15:0];
reg [7:0] center_19;
reg [4:0] judge_cnt_19;
wire [7:0] center_bright_19;
wire [7:0] center_dark_19;
assign center_bright_19 = (8'd255 - TH) >= center_19 ? (center_19 + TH) : 8'd255;
assign center_dark_19 = center_19 >= TH ? (center_19 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_19
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_19[i] <= 1'b0;
        end
    end
    else begin: pi_19
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_19[i] <= pixel_18[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_19 <= 1'b0;
        is_fast_before_19 <= 1'b0;
    end
    else begin
        if ((judge_cnt_18 == 1'b0 && (pixel_19[3] > center_bright_19 || pixel_19[3] < center_dark_19)) || (pixel_19[2] < center_dark_19 && pixel_19[3] < center_dark_19) || (pixel_19[2] > center_bright_19 && pixel_19[3] > center_bright_19)) begin
            judge_cnt_19 <= judge_cnt_18 + 1'b1;
            if (judge_cnt_18 + 1'b1 >= 4'd9 || is_fast_before_18 == 1'b1) begin
                is_fast_before_19 <= 1'b1;
            end
            else begin
                is_fast_before_19 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_18 == 1'b1) begin
                is_fast_before_19 <= 1'b1;
            end
            else begin
                is_fast_before_19 <= 1'b0;
            end
            judge_cnt_19 <= 1'b0;
        end
    end
end
//pipeline_19 end
//pipeline_20 start
reg [7:0] pixel_20[15:0];
reg [7:0] center_20;
reg [4:0] judge_cnt_20;
wire [7:0] center_bright_20;
wire [7:0] center_dark_20;
assign center_bright_20 = (8'd255 - TH) >= center_20 ? (center_20 + TH) : 8'd255;
assign center_dark_20 = center_20 >= TH ? (center_20 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_20
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_20[i] <= 1'b0;
        end
    end
    else begin: pi_20
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_20[i] <= pixel_19[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_20 <= 1'b0;
        is_fast_before_20 <= 1'b0;
    end
    else begin
        if ((judge_cnt_19 == 1'b0 && (pixel_20[4] > center_bright_20 || pixel_20[4] < center_dark_20)) || (pixel_20[3] < center_dark_20 && pixel_20[4] < center_dark_20) || (pixel_20[3] > center_bright_20 && pixel_20[4] > center_bright_20)) begin
            judge_cnt_20 <= judge_cnt_19 + 1'b1;
            if (judge_cnt_19 + 1'b1 >= 4'd9 || is_fast_before_19 == 1'b1) begin
                is_fast_before_20 <= 1'b1;
            end
            else begin
                is_fast_before_20 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_19 == 1'b1) begin
                is_fast_before_20 <= 1'b1;
            end
            else begin
                is_fast_before_20 <= 1'b0;
            end
            judge_cnt_20 <= 1'b0;
        end
    end
end
//pipeline_20 end
//pipeline_21 start
reg [7:0] pixel_21[15:0];
reg [7:0] center_21;
reg [4:0] judge_cnt_21;
wire [7:0] center_bright_21;
wire [7:0] center_dark_21;
assign center_bright_21 = (8'd255 - TH) >= center_21 ? (center_21 + TH) : 8'd255;
assign center_dark_21 = center_21 >= TH ? (center_21 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_21
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_21[i] <= 1'b0;
        end
    end
    else begin: pi_21
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_21[i] <= pixel_20[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_21 <= 1'b0;
        is_fast_before_21 <= 1'b0;
    end
    else begin
        if ((judge_cnt_20 == 1'b0 && (pixel_21[5] > center_bright_21 || pixel_21[5] < center_dark_21)) || (pixel_21[4] < center_dark_21 && pixel_21[5] < center_dark_21) || (pixel_21[4] > center_bright_21 && pixel_21[5] > center_bright_21)) begin
            judge_cnt_21 <= judge_cnt_20 + 1'b1;
            if (judge_cnt_20 + 1'b1 >= 4'd9 || is_fast_before_20 == 1'b1) begin
                is_fast_before_21 <= 1'b1;
            end
            else begin
                is_fast_before_21 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_20 == 1'b1) begin
                is_fast_before_21 <= 1'b1;
            end
            else begin
                is_fast_before_21 <= 1'b0;
            end
            judge_cnt_21 <= 1'b0;
        end
    end
end
//pipeline_21 end
//pipeline_22 start
reg [7:0] pixel_22[15:0];
reg [7:0] center_22;
reg [4:0] judge_cnt_22;
wire [7:0] center_bright_22;
wire [7:0] center_dark_22;
assign center_bright_22 = (8'd255 - TH) >= center_22 ? (center_22 + TH) : 8'd255;
assign center_dark_22 = center_22 >= TH ? (center_22 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_22
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_22[i] <= 1'b0;
        end
    end
    else begin: pi_22
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_22[i] <= pixel_21[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_22 <= 1'b0;
        is_fast_before_22 <= 1'b0;
    end
    else begin
        if ((judge_cnt_21 == 1'b0 && (pixel_22[6] > center_bright_22 || pixel_22[6] < center_dark_22)) || (pixel_22[5] < center_dark_22 && pixel_22[6] < center_dark_22) || (pixel_22[5] > center_bright_22 && pixel_22[6] > center_bright_22)) begin
            judge_cnt_22 <= judge_cnt_21 + 1'b1;
            if (judge_cnt_21 + 1'b1 >= 4'd9 || is_fast_before_21 == 1'b1) begin
                is_fast_before_22 <= 1'b1;
            end
            else begin
                is_fast_before_22 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_21 == 1'b1) begin
                is_fast_before_22 <= 1'b1;
            end
            else begin
                is_fast_before_22 <= 1'b0;
            end
            judge_cnt_22 <= 1'b0;
        end
    end
end
//pipeline_22 end
//pipeline_23 start
reg [7:0] pixel_23[15:0];
reg [7:0] center_23;
reg [4:0] judge_cnt_23;
wire [7:0] center_bright_23;
wire [7:0] center_dark_23;
assign center_bright_23 = (8'd255 - TH) >= center_23 ? (center_23 + TH) : 8'd255;
assign center_dark_23 = center_23 >= TH ? (center_23 - TH) : 8'd0;
always @(posedge clk or negedge en) begin
    if (!en) begin: pipe_23
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_23[i] <= 1'b0;
        end
    end
    else begin: pi_23
        integer i;
        for(i=0;i<16;i=i+1) begin
            pixel_23[i] <= pixel_22[i];
        end
    end
end
always @(posedge clk or negedge en) begin
    if (!en) begin
        judge_cnt_23 <= 1'b0;
        is_fast_before_23 <= 1'b0;
    end
    else begin
        if ((judge_cnt_22 == 1'b0 && (pixel_23[7] > center_bright_23 || pixel_23[7] < center_dark_23)) || (pixel_23[6] < center_dark_23 && pixel_23[7] < center_dark_23) || (pixel_23[6] > center_bright_23 && pixel_23[7] > center_bright_23)) begin
            judge_cnt_23 <= judge_cnt_22 + 1'b1;
            if (judge_cnt_22 + 1'b1 >= 4'd9 || is_fast_before_22 == 1'b1) begin
                is_fast_before_23 <= 1'b1;
            end
            else begin
                is_fast_before_23 <= 1'b0;
            end
        end
        else begin
            if (is_fast_before_22 == 1'b1) begin
                is_fast_before_23 <= 1'b1;
            end
            else begin
                is_fast_before_23 <= 1'b0;
            end
            judge_cnt_23 <= 1'b0;
        end

    end
end
//pipeline_23 end
always @(posedge clk or negedge en) begin
    if (!en) begin
        center_1 <= 1'b0;
        center_2 <= 1'b0;
        center_3 <= 1'b0;
        center_4 <= 1'b0;
        center_5 <= 1'b0;
        center_6 <= 1'b0;
        center_7 <= 1'b0;
        center_8 <= 1'b0;
        center_9 <= 1'b0;
        center_10 <= 1'b0;
        center_11 <= 1'b0;
        center_12 <= 1'b0;
        center_13 <= 1'b0;
        center_14 <= 1'b0;
        center_15 <= 1'b0;
        center_16 <= 1'b0;
        center_17 <= 1'b0;
        center_18 <= 1'b0;
        center_19 <= 1'b0;
        center_20 <= 1'b0;
        center_21 <= 1'b0;
        center_22 <= 1'b0;
        center_23 <= 1'b0;
    end
    else begin
        center_1 <= center;
        center_2 <= center_1;
        center_3 <= center_2;
        center_4 <= center_3;
        center_5 <= center_4;
        center_6 <= center_5;
        center_7 <= center_6;
        center_8 <= center_7;
        center_9 <= center_8;
        center_10 <= center_9;
        center_11 <= center_10;
        center_12 <= center_11;
        center_13 <= center_12;
        center_14 <= center_13;
        center_15 <= center_14;
        center_16 <= center_15;
        center_17 <= center_16;
        center_18 <= center_17;
        center_19 <= center_18;
        center_20 <= center_19;
        center_21 <= center_20;
        center_22 <= center_21;
        center_23 <= center_22;
    end
end
assign is_FAST = (is_fast_before_23 || judge_cnt_23 >= 4'd9) && (fast_row_cnt >= 8'd7 && fast_row_cnt <= 8'd231 && fast_col_cnt >= 9'd7 && fast_col_cnt <= 9'd367) ? 1'b1 : 1'b0;
endmodule
