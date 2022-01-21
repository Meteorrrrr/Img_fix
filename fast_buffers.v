module fast_buffers(
	input clk,
	input en,
	input [WIDTH-1:0] din
	);

parameter WIDTH = 8;
parameter ROW = 240;
parameter COL = 376;

reg [7:0] row_cnt;
reg [8:0] col_cnt;

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
		if (row_cnt == 8'd2 && col_cnt == 9'd1) begin
			kernel_en <= 1'b1;
		end
		else begin
			kernel_en <= kernel_en;
		end
	end
end

linebuffer linebuffer_3(
	.CE(en),
	.CLK(clk),
	.D(din),
	.Q(l_3)
	);

linebuffer linebuffer_2(
	.CE(en),
	.CLK(clk),
	.D(l_3),
	.Q(l_2)
	);

linebuffer linebuffer_1(
	.CE(en),
	.CLK(clk),
	.D(l_2),
	.Q(l_1)
	);

linebuffer linebuffer_0(
	.CE(en),
	.CLK(clk),
	.D(l_1),
	.Q(l_0)
	);

endmodule