
module avg_buffers(
	input clk,
	input en,
	input rst,
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

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		col_cnt <= 1'b0;
	end
	else if(en)begin
		if (col_cnt == COL - 1) begin
			col_cnt <= 1'b0;
		end
		else begin
			col_cnt <= col_cnt + 1'b1;
		end
	end
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		row_cnt <= 1'b0;
	end
	else if(en)begin
		if (row_cnt == ROW && col_cnt == 1'b0) begin // 在(752, 0)停止
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

wire [WIDTH-1:0] l_0;


pyr_buffer pyr_buffer_0(
	.CE(1'b1),
	.CLK(clk),
	.D(din),
	.Q(l_0)
	);

wire [9:0] dout;
assign pyr_out = dout[9:2];
avg_kernel avg_kernel_inst(
	.clk(clk),
	.en(en),
	.row_cnt(row_cnt),
	.col_cnt(col_cnt),
	.din_1(din),
	.din_0(l_0),
	.dout(dout),
	.out_valid(out_valid),
	.odd_out(odd_out)
);
endmodule