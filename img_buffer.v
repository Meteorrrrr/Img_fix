`timescale 1ns/1ps

module img_buffer (
        en,
        clk,
        din,
        dout,
        valid_in,
        valid_out
    );

parameter WIDTH = 8;//数据位宽
parameter COL = 752;//图像宽度

input  en;
input  clk;
input  [WIDTH-1:0] din; // din 8bits
output [WIDTH-1:0] dout;
input  valid_in;//输入数据有效，写使能
output valid_out;//输出给下一级的valid_in，也即上一级开始读的同时下一级就可以开始写入

wire   rd_en;//读使能
reg    [9:0] cnt;//这里的宽度注意要根据COL的值来设置，需要满足cnt的范围≥图像宽度

always @(posedge clk or negedge en) begin
    if(!en)
        cnt <= {10{1'b0}};
    else if(valid_in)
        if(cnt == COL)
            cnt <= COL;
        else
            cnt <= cnt +1'b1;
    else
        cnt <= cnt;
end
//一行数据写完之后，该级fifo就可以开始读出，下一级也可以开始写入了
assign rd_en = ((cnt == COL) && (valid_in)) ? 1'b1:1'b0;
assign valid_out = rd_en;

input_fifo input_fifo_inst(
    .clk (clk),
    .din (din),
    .wr_en (valid_in),
    .rd_en (rd_en),
    .dout(dout),
    .empty(),
    .full()
);
endmodule