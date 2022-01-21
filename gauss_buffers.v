
module gauss_buffers(
	input clk,
	input en,
	input [WIDTH-1:0] din,
	output [7:0] pyr_out,
	output out_valid,
	output odd_out
	);

parameter WIDTH = 8;
parameter ROW = 480;
parameter COL = 752;

reg [9:0] row_cnt;
reg [9:0] col_cnt;

always @(posedge clk or negedge en) begin
	if (!en) begin
		col_cnt <= 1'b0;
	end
	else begin
		if (col_cnt == COL - 1) begin
			col_cnt <= 1'b0;
		end
		else begin
			col_cnt <= col_cnt + 1'b1;
		end
	end
end

always @(posedge clk or negedge en) begin
	if (!en) begin
		row_cnt <= 1'b0;
	end
	else begin
		if (row_cnt == (ROW + 2'd3) && col_cnt == 1'b1) begin // 在(753, 1)停止
			row_cnt <= 1'b0;
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
end

wire [WIDTH-1:0] l_3;
wire [WIDTH-1:0] l_2;
wire [WIDTH-1:0] l_1;
wire [WIDTH-1:0] l_0;

reg kernel_en;
always @(posedge clk or negedge en) begin
	if (!en) begin
		kernel_en <= 1'b0;
	end
	else begin
		if (row_cnt == 10'd2 && col_cnt == 10'd1) begin
			kernel_en <= 1'b1;
		end
		else begin
			kernel_en <= kernel_en;
		end
	end
end

pyr_buffer pyr_buffer_3(
	.CE(en),
	.CLK(clk),
	.D(din),
	.Q(l_3)
	);

pyr_buffer pyr_buffer_2(
	.CE(en),
	.CLK(clk),
	.D(l_3),
	.Q(l_2)
	);

pyr_buffer pyr_buffer_1(
	.CE(en),
	.CLK(clk),
	.D(l_2),
	.Q(l_1)
	);

pyr_buffer pyr_buffer_0(
	.CE(en),
	.CLK(clk),
	.D(l_1),
	.Q(l_0)
	);

wire [15:0] dout;
assign pyr_out = dout[15:8];
gauss_kernel kernel_inst(
	.clk(clk),
	.en(kernel_en),
	.row_cnt(row_cnt),
	.col_cnt(col_cnt),
	.din_4(din),
	.din_3(l_3),
	.din_2(l_2),
	.din_1(l_1),
	.din_0(l_0),
	.dout(dout),
	.out_valid(out_valid),
	.odd_out(odd_out)
);
endmodule