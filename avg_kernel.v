
module avg_kernel(
    input clk,
    input en,
    input [WIDTH-1:0] din_1,
    input [WIDTH-1:0] din_0,
    input [9:0] row_cnt,
    input [9:0] col_cnt,
    output [9:0] dout,
    output reg out_valid,
    output odd_out
    );
parameter WIDTH = 8;
parameter ROW = 480;
parameter COL = 752;

reg [WIDTH-1:0] kernel [3:0];
always @(posedge clk or negedge en) begin
    if (!en) 
    begin: kernel_rst
        integer i;
        for(i=0;i<4;i=i+1) begin
            kernel[i] <= 8'd1;
        end
    end
    else 
        begin: kernel_inst
        integer i;
        kernel[3]  <= din_1;
        kernel[1]  <= din_0;
        kernel[2]  <= kernel[3];
        kernel[0]  <= kernel[1];
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        out_valid <= 1'b0;
    end
    else begin
        if (row_cnt == 10'd1 && col_cnt == 10'd1) begin
            out_valid <= 1'b1;
        end
        else if (row_cnt == 10'd480 && col_cnt == 10'd0) begin
            out_valid <= 1'b0;
        end
        else begin
            out_valid <= out_valid;
        end
    end
end

assign odd_out = ((row_cnt[0] == 1'b1 && col_cnt >= 10'd2) || (row_cnt[0] == 1'b0 && col_cnt < 10'd2)) && col_cnt[0] == 1'b0 ? 1'b1 : 1'b0;
// assign kernel_flag = row_cnt >= 10'd4 && col_cnt >= 10'd4 && row_cnt <= (ROW - 1'b1) && col_cnt <= (COL - 1'b1) ? 1'b1 : 1'b0;
wire [WIDTH+1:0] k [3:0];
assign k[0] = {2'b0, kernel[0]};
assign k[1] = {2'b0, kernel[1]};
assign k[2] = {2'b0, kernel[2]};
assign k[3] = {2'b0, kernel[3]};

assign dout = k[0] + k[1] + k[2] + k[3];

endmodule