`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/25 13:40:00
// Design Name: 
// Module Name: new_patches_ram
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


module new_patches_ram(
    input clk,
    input wea,
    input web,
    input [10:0] addra,
    input [10:0] addrb,
    output [7:0] dout_p0,
    output [7:0] dout_p1,
    output [7:0] dout_p2,
    output [7:0] dout_p3,
    output [7:0] dout_p4,
    output [7:0] dout_p5,
    output [7:0] dout_p6,
    output [7:0] dout_p7,
    output [7:0] dout_p8,
    output [7:0] dout_p9,
    output [7:0] dout_p10,
    output [7:0] dout_p11,
    input [7:0] din_0,
    input [7:0] din_1,
    input [7:0] din_2,
    input [7:0] din_3,
    input [7:0] din_4,
    input [7:0] din_5,
    input [7:0] din_6,
    input [7:0] din_7,
    input [7:0] din_8,
    input [7:0] din_9,
    input [7:0] din_10,
    input [7:0] din_11
    );

new_patches_0 new_patches_inst_0(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_0),
  .douta(dout_p0),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_0),
  .doutb()
);

new_patches_0 new_patches_inst_1(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_1),
  .douta(dout_p1),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_1),
  .doutb()
);

new_patches_0 new_patches_inst_2(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_2),
  .douta(dout_p2),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_2),
  .doutb()
);

new_patches_0 new_patches_inst_3(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_3),
  .douta(dout_p3),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_3),
  .doutb()
);

new_patches_0 new_patches_inst_4(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_4),
  .douta(dout_p4),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_4),
  .doutb()
);

new_patches_0 new_patches_inst_5(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_5),
  .douta(dout_p5),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_5),
  .doutb()
);

new_patches_0 new_patches_inst_6(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_6),
  .douta(dout_p6),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_6),
  .doutb()
);

new_patches_0 new_patches_inst_7(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_7),
  .douta(dout_p7),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_7),
  .doutb()
);

new_patches_0 new_patches_inst_8(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_8),
  .douta(dout_p8),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_8),
  .doutb()
);

new_patches_0 new_patches_inst_9(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_9),
  .douta(dout_p9),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_9),
  .doutb()
);

new_patches_0 new_patches_inst_10(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_10),
  .douta(dout_p10),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_10),
  .doutb()
);

new_patches_0 new_patches_inst_11(
  .clka(clk),
  .wea(wea),
  .addra(addra),
  .dina(din_11),
  .douta(dout_p11),
  .clkb(clk),
  .web(web),
  .addrb(addrb),
  .dinb(din_11),
  .doutb()
);
endmodule
