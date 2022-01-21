`define CAM_IDLE 2'b00
`define CAM_INPUT0 2'b01
`define CAM_INPUTA 2'b10
`define CAM_INPUTB 2'b11
module img_top(
	// 来自camera的输出
	input cam_clk,
	input rst,
	input en,
	input [7:0] cam_data_in,
	input hs,
	input vs,
	input data_valid,

	// 来自workspace的需求：提取预测patch并输出
	input [4:0] predict_ID,
	input [7:0] predict_Y,
	input [8:0] predict_X,
	output [7:0] predict_l0,
    output [7:0] predict_l1,
    output [7:0] predict_l2,
    output [7:0] predict_l3,
    output [7:0] predict_l4,
    output [7:0] predict_l5,
    output [7:0] predict_l6,
    output [7:0] predict_l7,
    output [14:0] predict_score,

    // 来自workspace的需求：获取新patch信息
    input output_new_patches_en,
    input output_new_patches,
    output [7:0] new_patches_output_l0,
    output [7:0] new_patches_output_l1,
    output [7:0] new_patches_output_l2,
    output [7:0] new_patches_output_l3,
    output [7:0] new_patches_output_l4,
    output [7:0] new_patches_output_l5,
    output [7:0] new_patches_output_l6,
    output [7:0] new_patches_output_l7, 
    output [7:0] new_patches_output_l8,
    output [7:0] new_patches_output_l9,
    output [7:0] new_patches_output_l10,
    output [7:0] new_patches_output_l11,
    output [7:0] new_patches_output_Y,
    output [8:0] new_patches_output_X,
    output [14:0] new_patches_output_score,

	// 用于测试时输出
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
    output simu_out, // 使能，表示开始输出bram的值到txt里面
    output dv_clk
);

// 这里是第一段：结合data_valid信号实现ping-pong+新clk操作
reg [1:0] current_cam_state;
reg [1:0] next_cam_state;
reg [9:0] cam_input_cnt;
always @(posedge cam_clk or negedge rst) begin
	if (!rst) begin
		current_cam_state <= `CAM_IDLE;
	end
	else begin
		current_cam_state <= next_cam_state;
	end
end

always @(posedge cam_clk or negedge rst) begin
	if (!rst) begin
		cam_input_cnt <= 1'b0;
	end
	else begin
		if (data_valid) begin
			if (cam_input_cnt == 10'd751) begin
				cam_input_cnt <= 1'b0;
			end
			else begin
				cam_input_cnt <= cam_input_cnt + 1'b1;
			end
		end
	end
end

always @(*) begin
	case(current_cam_state)
		`CAM_IDLE: begin
			if (vs) begin
				next_cam_state = `CAM_INPUT0;
			end
			else begin
				next_cam_state = `CAM_IDLE;
			end
		end
		`CAM_INPUT0: begin
			if (data_valid && cam_input_cnt == 10'd751) begin
				next_cam_state = `CAM_INPUTB;
			end
			else if (!vs) begin
				next_cam_state = `CAM_IDLE;
			end
			else begin
				next_cam_state = `CAM_INPUT0;
			end
		end
		`CAM_INPUTA: begin
			if (data_valid && cam_input_cnt == 10'd751) begin
				next_cam_state = `CAM_INPUTB;
			end
			else if (!vs) begin
				next_cam_state = `CAM_IDLE;
			end
			else begin
				next_cam_state = `CAM_INPUTA;
			end
		end
		`CAM_INPUTB: begin
			if (data_valid && cam_input_cnt == 10'd751) begin
				next_cam_state = `CAM_INPUTA;
			end
			else if (!vs) begin
				next_cam_state = `CAM_IDLE;
			end
			else begin
				next_cam_state = `CAM_INPUTB;
			end
		end
	endcase
end


wire [7:0] cam_fifo_out0;
wire [7:0] cam_fifo_out1;
wire cam_fifo_0_wr;
wire cam_fifo_1_wr;
wire cam_fifo_0_rd;
wire cam_fifo_1_rd;
assign cam_fifo_0_wr = (current_cam_state == `CAM_INPUTA || current_cam_state == `CAM_INPUT0) && data_valid ? 1'b1 : 1'b0;
assign cam_fifo_1_wr = current_cam_state == `CAM_INPUTB && data_valid ? 1'b1 : 1'b0;
reg [9:0] fix_rd_cnt;
always @(posedge cam_clk or negedge rst) begin
	if (!rst) begin
		fix_rd_cnt <= 1'b0;
	end
	else begin
		if (current_cam_state == `CAM_INPUTB || current_cam_state == `CAM_INPUTA) begin
			if (cam_input_cnt == 10'd751 && data_valid) begin
				fix_rd_cnt <= 1'b0;
			end
			else if (cam_input_cnt <= 10'd752) begin // 把752设置为无效，即为如果读0-751之后还没写完另一条fifo，会进入752,此时则不读了，等待状态跳转归零同时重新开始读
				fix_rd_cnt <= fix_rd_cnt + 1'b1;
			end
		end
	end
end
assign cam_fifo_0_rd = current_cam_state == `CAM_INPUTB && fix_rd_cnt <= 10'd751 ? 1'b1 : 1'b0;
assign cam_fifo_1_rd = current_cam_state == `CAM_INPUTA && fix_rd_cnt <= 10'd751 ? 1'b1 : 1'b0;
cam_data_fifo cam_data_fifo_inst0(
	.clk(cam_clk),
	.srst(!rst),
	.din(cam_data_in),
	.wr_en(cam_fifo_0_wr),
	.rd_en(cam_fifo_0_rd),
	.dout(cam_fifo_out0)
);
cam_data_fifo cam_data_fifo_inst1(
	.clk(cam_clk),
	.srst(!rst),
	.din(cam_data_in),
	.wr_en(cam_fifo_1_wr),
	.rd_en(cam_fifo_1_rd),
	.dout(cam_fifo_out1)
);
wire [7:0] data_in_fix;
assign data_in_fix = cam_fifo_0_rd ? cam_fifo_out0 : cam_fifo_1_rd ? cam_fifo_out1 : 1'b0;
wire fix_clk;
reg [8:0] rd_row_cnt;
reg con_do;
always @(posedge cam_clk or negedge rst) begin
	if (!rst) begin
		rd_row_cnt <= 1'b0;
		con_do <= 1'b0;
	end
	else if (en) begin
		if (fix_rd_cnt == 10'd751) begin
			rd_row_cnt <= rd_row_cnt + 1'b1;
		end
		if (rd_row_cnt == 9'd479) begin // 读到最后一行的时候就不需要再等了，一直工作即可
			con_do <= 1'b1;
		end
	end
	else begin
		con_do <= 1'b0;
	end
end
assign fix_clk = (((current_cam_state == `CAM_INPUTB || current_cam_state == `CAM_INPUTA) && fix_rd_cnt <= 10'd750) || con_do) & cam_clk;

// 这里是经过了第一次处理的时钟，会连续操作752然后等待
wire [7:0] pyr_out;
wire pyr_out_valid;
wire pyr_odd_out;
avg_buffers avg_inst(
	.clk(fix_clk),
	.en(en),
	.rst(rst),
	.din(data_in_fix),
	.pyr_out(pyr_out),
	.out_valid(pyr_out_valid),
	.odd_out(pyr_odd_out)
);

reg div4_o_r;
reg [1:0] div_cnt1;
always@(posedge fix_clk or negedge rst)begin
	if(!rst)
		div_cnt1<=2'b00;
	else
		div_cnt1<=div_cnt1+1'b1;
end
 
always@(posedge fix_clk or negedge rst) begin                                      //计数器放在外面 来实现计数   div_cnt1
	if(!rst)                           //00 01 10 11 捕捉00和10 实现四分频
		div4_o_r<=1'b0;
	else if(div_cnt1==2'b00 || div_cnt1==2'b10)
		div4_o_r<=~div4_o_r;
	else
		div4_o_r<=div4_o_r;
end
assign dv_clk = div4_o_r;



// 以下为四分频时钟部分
wire [7:0] pyr_fifo_out;
wire [7:0] fea_in;
reg rd_en;
always @(posedge div4_o_r or negedge rst) begin
	if (!rst) begin
		rd_en <= 1'b0;
	end
	else if(en)begin
		if (pyr_out_valid) begin
			rd_en <= 1'b1;
		end
		else begin
			rd_en <= rd_en;
		end
	end
end

wire empty;
wire [7:0] pyr_bf_l10;
wire [7:0] pyr_bf_l9;
wire [7:0] pyr_bf_l8;
wire [7:0] pyr_bf_l7;
wire [7:0] pyr_bf_l6;
wire [7:0] pyr_bf_l5;
wire [7:0] pyr_bf_l4;
wire [7:0] pyr_bf_l3;
wire [7:0] pyr_bf_l2;
wire [7:0] pyr_bf_l1;
wire [7:0] pyr_bf_l0;
wire [7:0] row_cnt;
wire [8:0] col_cnt;
// 暂时假设patch size是8，那么有7行linebuffer，目前这个先输出来实现FAST角点先
fea_buffers fea_inst(
    .clk(div4_o_r),
    .en(rst),
    .in_valid(rd_en && !empty),
    .din(pyr_fifo_out),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .l_10(pyr_bf_l10),
    .l_9(pyr_bf_l9),
    .l_8(pyr_bf_l8),
    .l_7(pyr_bf_l7),
    .l_6(pyr_bf_l6),
	.l_5(pyr_bf_l5),
	.l_4(pyr_bf_l4),
	.l_3(pyr_bf_l3),
	.l_2(pyr_bf_l2),
	.l_1(pyr_bf_l1),
	.l_0(pyr_bf_l0)
); 


wire fast_result;
fast_detector fast_inst(
    .clk(div4_o_r),
    .en(rst),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .f_6(pyr_bf_l9),
    .f_5(pyr_bf_l8),
    .f_4(pyr_bf_l7),
    .f_3(pyr_bf_l6),
    .f_2(pyr_bf_l5),
    .f_1(pyr_bf_l4),
    .f_0(pyr_bf_l3),
    .is_FAST(fast_result)
    );

wire is_FAST;
fast_result_buffer fast_result_buffer_inst( //1024
    .CLK(div4_o_r),
    .D(fast_result),
    .Q(is_FAST)
    );

wire [7:0] row_cnt_shi;
wire [8:0] col_cnt_shi;
wire [14:0] SHI_score;
wire [7:0] store_new_patches_0;
wire [7:0] store_new_patches_1;
wire [7:0] store_new_patches_2;
wire [7:0] store_new_patches_3;
wire [7:0] store_new_patches_4;
wire [7:0] store_new_patches_5;
wire [7:0] store_new_patches_6;
wire [7:0] store_new_patches_7;
wire [7:0] store_new_patches_8;
wire [7:0] store_new_patches_9;
wire [7:0] store_new_patches_10;
wire [7:0] store_new_patches_11;
shi_detect shi_detect_inst(
    .clk(div4_o_r),
    .en(rst),
    .row_cnt_in(row_cnt),
    .col_cnt_in(col_cnt),
    .score(SHI_score),
    .g_11(pyr_fifo_out),
    .g_10(pyr_bf_l10),
    .g_9(pyr_bf_l9),
    .g_8(pyr_bf_l8),
    .g_7(pyr_bf_l7),
    .g_6(pyr_bf_l6),
    .g_5(pyr_bf_l5),
    .g_4(pyr_bf_l4),
    .g_3(pyr_bf_l3),
    .g_2(pyr_bf_l2),
    .g_1(pyr_bf_l1),
    .g_0(pyr_bf_l0),
    .store_0(store_new_patches_0),
	.store_1(store_new_patches_1),
	.store_2(store_new_patches_2),
	.store_3(store_new_patches_3),
	.store_4(store_new_patches_4),
	.store_5(store_new_patches_5),
	.store_6(store_new_patches_6),
	.store_7(store_new_patches_7),
	.store_8(store_new_patches_8),
	.store_9(store_new_patches_9),
	.store_10(store_new_patches_10),
	.store_11(store_new_patches_11),
    .row_cnt(row_cnt_shi),
    .col_cnt(col_cnt_shi)
    );

input_fifo input_fifo_inst(
	.srst(!rst),
	.wr_clk(fix_clk),
	.rd_clk(div4_o_r),
	.din(pyr_out),
	.wr_en(pyr_odd_out && pyr_out_valid),
	.rd_en(rd_en),
	.dout(pyr_fifo_out),
	.empty(empty)
);

wire new_patches_wea;
wire new_patches_web;
wire [10:0] new_patches_addra;
wire [10:0] new_patches_addrb;
new_patch_ram_control patch_control_inst(
	.clk(div4_o_r),
	.en(rst),
	.row_cnt(row_cnt_shi),
	.col_cnt(col_cnt_shi),
	.is_FAST(is_FAST),
	.SHI_score(SHI_score),
	.out(simu_out),
	.wea_out(new_patches_wea),
	.web_out(new_patches_web),
	.addra(new_patches_addra),
	.addrb(new_patches_addrb)
	);

new_patches_ram new_patches_ram_inst(
	.clk(div4_o_r),
	.wea(new_patches_wea),
	.web(new_patches_web),
	.addra(new_patches_addra),
	.addrb(new_patches_addrb),
	.din_0(store_new_patches_0),
	.din_1(store_new_patches_1),
	.din_2(store_new_patches_2),
	.din_3(store_new_patches_3),
	.din_4(store_new_patches_4),
	.din_5(store_new_patches_5),
	.din_6(store_new_patches_6),
	.din_7(store_new_patches_7),
	.din_8(store_new_patches_8),
	.din_9(store_new_patches_9),
	.din_10(store_new_patches_10),
	.din_11(store_new_patches_11),
	.dout_p0(dout_p0),
	.dout_p1(dout_p1),
	.dout_p2(dout_p2),
	.dout_p3(dout_p3),
	.dout_p4(dout_p4),
	.dout_p5(dout_p5),
	.dout_p6(dout_p6),
	.dout_p7(dout_p7),
	.dout_p8(dout_p8),
	.dout_p9(dout_p9),
	.dout_p10(dout_p10),
	.dout_p11(dout_p11)
	);


endmodule