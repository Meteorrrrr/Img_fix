`timescale 1ns/1ps
`define CLK_PERIOD 20//50MHZ
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 18:59:57
// Design Name: 
// Module Name: bit_test
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


module bit_test();

reg clk;
wire [15:0] sum;
wire [13:0] r;
reg [12:0] a;
reg [12:0] b;
reg [7:0] c;
wire [15:0] r1;
assign r1 = {2'b0,r};
wire [7:0] r2;
assign r2 = c<<2;
initial begin
    clk = 1;
    #(`CLK_PERIOD*2);
    a <= 13'b0_0000_0000_0010;
    b <= 13'b0_0000_0000_0110;
    c <= 8'b0000_0001;
    #(`CLK_PERIOD*2);
    a <= 13'b0_0000_0000_1010;
    b <= 13'b0_0000_0000_1110;
    c <= 8'b0000_1110;
end
always #(`CLK_PERIOD/2) clk = ~clk;

fix_add add_inst1(
    .A({3'b0,a}),
    .B({3'b0,b}),
    .CLK(clk),
    .CE(1'b1),
    .S(sum)
);

mul36 mul36_inst(
    .A(c),
    .P(r)
);
endmodule
