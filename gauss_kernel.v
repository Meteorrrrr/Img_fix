
module gauss_kernel(
	input clk,
	input en,
	input [WIDTH-1:0] din_4,
	input [WIDTH-1:0] din_3,
	input [WIDTH-1:0] din_2,
	input [WIDTH-1:0] din_1,
	input [WIDTH-1:0] din_0,
	input [9:0] row_cnt,
	input [9:0] col_cnt,
	output [15:0] dout,
	output reg out_valid,
	output odd_out
	);
parameter WIDTH = 8;
parameter ROW = 480;
parameter COL = 752;

reg [WIDTH-1:0] kernel [24:0];
always @(posedge clk or negedge en) begin
	if (!en) 
	begin: kernel_rst
		integer i;
		for(i=0;i<25;i=i+1) begin
			kernel[i] <= 1'b0;
		end
	end
	else 
		begin: kernel_inst
        integer i;
        kernel[24] <= din_4;
        kernel[19] <= din_3;
        kernel[14] <= din_2;
        kernel[9]  <= din_1;
        kernel[4]  <= din_0;
        for(i=0;i<4;i=i+1) begin
            kernel[24-i-1] <= kernel[24-i];
            kernel[19-i-1] <= kernel[19-i];
            kernel[14-i-1] <= kernel[14-i];
            kernel[9-i-1]  <= kernel[9-i];
            kernel[4-i-1]  <= kernel[4-i];
        end
	end
end

reg kernel_flag;
always @(posedge clk or negedge en) begin
	if (!en) begin
		kernel_flag <= 1'b0;
	end
	else begin
		if (row_cnt >= 10'd4 && col_cnt >= 10'd4 && row_cnt <= (ROW - 1'b1) && col_cnt < (COL - 1'b1))begin
			kernel_flag <= 1'b1;
		end
		else begin
			kernel_flag <= 1'b0;
		end
	end
end

always @(posedge clk or negedge en) begin
	if (!en) begin
		out_valid <= 1'b0;
	end
	else begin
		if (row_cnt == 10'd2 && col_cnt == 10'd7) begin
			out_valid <= 1'b1;
		end
		else if (row_cnt == 10'd482 && col_cnt == 10'd7) begin
			out_valid <= 1'b0;
		end
		else begin
			out_valid <= out_valid;
		end
	end
end

assign odd_out = ((row_cnt[0] == 1'b0 && col_cnt >= 10'd8) || (row_cnt[0] == 1'b1 && col_cnt < 10'd8)) && col_cnt[0] == 1'b0 ? 1'b1 : 1'b0;
// assign kernel_flag = row_cnt >= 10'd4 && col_cnt >= 10'd4 && row_cnt <= (ROW - 1'b1) && col_cnt <= (COL - 1'b1) ? 1'b1 : 1'b0;
wire [WIDTH-1:0] k [24:0];
assign k[0] = kernel_flag ? kernel[0] : 8'b1;
assign k[1] = kernel_flag ? kernel[1] : 8'b1;
assign k[2] = kernel_flag ? kernel[2] : 8'b1;
assign k[3] = kernel_flag ? kernel[3] : 8'b1;
assign k[4] = kernel_flag ? kernel[4] : 8'b1;
assign k[5] = kernel_flag ? kernel[5] : 8'b1;
assign k[6] = kernel_flag ? kernel[6] : 8'b1;
assign k[7] = kernel_flag ? kernel[7] : 8'b1;
assign k[8] = kernel_flag ? kernel[8] : 8'b1;
assign k[9] = kernel_flag ? kernel[9] : 8'b1;
assign k[10] = kernel_flag ? kernel[10] : 8'b1;
assign k[11] = kernel_flag ? kernel[11] : 8'b1;
assign k[12] = kernel_flag ? kernel[12] : 8'b1;
assign k[13] = kernel_flag ? kernel[13] : 8'b1;
assign k[14] = kernel_flag ? kernel[14] : 8'b1;
assign k[15] = kernel_flag ? kernel[15] : 8'b1;
assign k[16] = kernel_flag ? kernel[16] : 8'b1;
assign k[17] = kernel_flag ? kernel[17] : 8'b1;
assign k[18] = kernel_flag ? kernel[18] : 8'b1;
assign k[19] = kernel_flag ? kernel[19] : 8'b1;
assign k[20] = kernel_flag ? kernel[20] : 8'b1;
assign k[21] = kernel_flag ? kernel[21] : 8'b1;
assign k[22] = kernel_flag ? kernel[22] : 8'b1;
assign k[23] = kernel_flag ? kernel[23] : 8'b1;
assign k[24] = kernel_flag ? kernel[24] : 8'b1;

wire [10:0] mul_6_0;
wire [10:0] mul_6_1;
wire [10:0] mul_6_2;
wire [10:0] mul_6_3;

wire [12:0] mul_24_0;
wire [12:0] mul_24_1;
wire [12:0] mul_24_2;
wire [12:0] mul_24_3;

wire [13:0] mul_36;

wire [15:0] sum_s1_1;
wire [15:0] sum_s1_2;
wire [15:0] sum_s1_3;
wire [15:0] sum_s1_4;
wire [15:0] sum_s1_5;
wire [15:0] sum_s1_6;
wire [15:0] sum_s1_7;
wire [15:0] sum_s1_8;
wire [15:0] sum_s1_9;
wire [15:0] sum_s1_10;
wire [15:0] sum_s1_11;
wire [15:0] sum_s1_12;
wire [15:0] sum_s1_13;

wire [15:0] sum_s2_1;
wire [15:0] sum_s2_2;
wire [15:0] sum_s2_3;
wire [15:0] sum_s2_4;
wire [15:0] sum_s2_5;
wire [15:0] sum_s2_6;
wire [15:0] sum_s2_7;

wire [15:0] sum_s3_1;
wire [15:0] sum_s3_2;
wire [15:0] sum_s3_3;
wire [15:0] sum_s3_4;

wire [15:0] sum_s4_1;
wire [15:0] sum_s4_2;

// output wire [15:0] dout;

mul6 mul6_inst0(
	.A(k[2]),
	.P(mul_6_0)
);

mul6 mul6_inst1(
	.A(k[10]),
	.P(mul_6_1)
);

mul6 mul6_inst2(
	.A(k[14]),
	.P(mul_6_2)
);

mul6 mul6_inst3(
	.A(k[22]),
	.P(mul_6_3)
);

mul24 mul24_inst0(
	.A(k[7]),
	.P(mul_24_0)
);

mul24 mul24_inst1(
	.A(k[11]),
	.P(mul_24_1)
);

mul24 mul24_inst2(
	.A(k[13]),
	.P(mul_24_2)
);

mul24 mul24_inst3(
	.A(k[17]),
	.P(mul_24_3)
);

mul36 mul36_inst(
	.A(k[12]),
	.P(mul_36)
);

fix_add add_inst01(
	.A({8'b0,k[0]}),
	.B({8'b0,k[1]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_1)
);

fix_add add_inst02(
	.A({5'b0,mul_6_0}),
	.B({8'b0,k[3]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_2)
);

fix_add add_inst03(
	.A({8'b0,k[4]}),
	.B({8'b0,k[5]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_3)
);

fix_add add_inst04(
	.A({8'b0,k[6]}<<4),
	.B({3'b0,mul_24_0}),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_4)
);

fix_add add_inst05(
	.A({8'b0,k[8]}<<4),
	.B({8'b0,k[9]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_5)
);

fix_add add_inst06(
	.A({5'b0,mul_6_1}),
	.B({3'b0,mul_24_1}),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_6)
);

fix_add add_inst07(
	.A({2'b0,mul_36}),
	.B({3'b0,mul_24_2}),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_7)
);

fix_add add_inst08(
	.A({5'b0,mul_6_2}),
	.B({8'b0,k[15]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_8)
);

fix_add add_inst09(
	.A({8'b0,k[16]}<<4),
	.B({3'b0,mul_24_3}),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_9)
);

fix_add add_inst010(
	.A({8'b0,k[18]}<<4),
	.B({8'b0,k[19]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_10)
);

fix_add add_inst011(
	.A({8'b0,k[20]}),
	.B({8'b0,k[21]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_11)
);

fix_add add_inst012(
	.A({5'b0,mul_6_3}),
	.B({8'b0,k[23]}<<2),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_12)
);

fix_add add_inst013(
	.A({8'b0,k[24]}),
	.B({8'b0,8'b0}),
	.CLK(clk),
	.CE(en),
	.S(sum_s1_13)
);

fix_add add_inst21(
	.A(sum_s1_1),
	.B(sum_s1_2),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_1)
);

fix_add add_inst22(
	.A(sum_s1_3),
	.B(sum_s1_4),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_2)
);

fix_add add_inst23(
	.A(sum_s1_5),
	.B(sum_s1_6),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_3)
);

fix_add add_inst24(
	.A(sum_s1_7),
	.B(sum_s1_8),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_4)
);

fix_add add_inst25(
	.A(sum_s1_9),
	.B(sum_s1_10),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_5)
);

fix_add add_inst26(
	.A(sum_s1_11),
	.B(sum_s1_12),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_6)
);

fix_add add_inst27(
	.A(sum_s1_13),
	.B(16'b0),
	.CLK(clk),
	.CE(en),
	.S(sum_s2_7)
);

fix_add add_inst31(
	.A(sum_s2_1),
	.B(sum_s2_2),
	.CLK(clk),
	.CE(en),
	.S(sum_s3_1)
);

fix_add add_inst32(
	.A(sum_s2_3),
	.B(sum_s2_4),
	.CLK(clk),
	.CE(en),
	.S(sum_s3_2)
);

fix_add add_inst33(
	.A(sum_s2_5),
	.B(sum_s2_6),
	.CLK(clk),
	.CE(en),
	.S(sum_s3_3)
);

fix_add add_inst34(
	.A(sum_s2_7),
	.B(16'b0),
	.CLK(clk),
	.CE(en),
	.S(sum_s3_4)
);

fix_add add_inst41(
	.A(sum_s3_1),
	.B(sum_s3_2),
	.CLK(clk),
	.CE(en),
	.S(sum_s4_1)
);

fix_add add_inst42(
	.A(sum_s3_3),
	.B(sum_s3_4),
	.CLK(clk),
	.CE(en),
	.S(sum_s4_2)
);

fix_add add_inst51(
	.A(sum_s4_1),
	.B(sum_s4_2),
	.CLK(clk),
	.CE(en),
	.S(dout)
);


endmodule