`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/07 22:15:58
// Design Name: 
// Module Name: new_patch_ram_control
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


module new_patch_ram_control(
    input clk,
    input en,
    input is_FAST,
    input [14:0] SHI_score,
    input [7:0] row_cnt,
    input [8:0] col_cnt,
    output wea_out,
    output web_out,
    output reg [10:0] addra,
    output reg [10:0] addrb,
    output reg out
);


assign wea_out = wea || wea_reg;
assign web_out = web || web_reg;

reg [3:0] port_A_cnt;
reg [3:0] port_B_cnt;
reg [239:0] ban_rows;
reg [375:0] ban_cols;
reg wea;
reg web;
reg wea_reg;
reg web_reg;
always @(posedge clk or negedge en) begin
    if (!en) begin
        wea_reg <= 1'b0;
        web_reg <= 1'b0;
        base_addra_reg <= 1'b0;
        base_addrb_reg <= 1'b0;
    end
    else begin 
        if (wea) begin //代表id_0发起请求，此时A并没有在写，而且B也没有在写，则选择A进行写入;或者此时A在写并且就在写id_0的东西，则覆盖原来写的
            base_addra_reg <= base_addra;
            wea_reg <= wea;
        end
        else if (port_A_cnt == 4'd11) begin
            wea_reg <= 1'b0;
        end

        if (web) begin
            base_addrb_reg <= base_addrb;
            web_reg <= web;
        end
        else if (port_B_cnt == 4'd11) begin
            web_reg <= 1'b0;
        end

        
    end
end


always @(posedge clk or negedge en) begin
    if(!en) begin
        ban_rows <= 1'b0;
        ban_cols <= 1'b0;
    end
    else begin
        if (wea || web) begin
            ban_rows[row_cnt+8'd8] <= 1'b1;
            ban_rows[row_cnt+8'd7] <= 1'b1;
            ban_rows[row_cnt+8'd6] <= 1'b1;
            ban_rows[row_cnt+8'd5] <= 1'b1;
            ban_rows[row_cnt+8'd4] <= 1'b1;
            ban_rows[row_cnt+8'd3] <= 1'b1;
            ban_rows[row_cnt+8'd2] <= 1'b1;
            ban_rows[row_cnt+8'd1] <= 1'b1;
            ban_rows[row_cnt] <= 1'b1;

            ban_cols[col_cnt+9'd8] <= 1'b1;
            ban_cols[col_cnt+9'd7] <= 1'b1;
            ban_cols[col_cnt+9'd6] <= 1'b1;
            ban_cols[col_cnt+9'd5] <= 1'b1;
            ban_cols[col_cnt+9'd4] <= 1'b1;
            ban_cols[col_cnt+9'd3] <= 1'b1;
            ban_cols[col_cnt+9'd2] <= 1'b1;
            ban_cols[col_cnt+9'd1] <= 1'b1;
            ban_cols[col_cnt] <= 1'b1;
            ban_cols[col_cnt-9'd7] <= 1'b1;
            ban_cols[col_cnt-9'd6] <= 1'b1;
            ban_cols[col_cnt-9'd5] <= 1'b1;
            ban_cols[col_cnt-9'd4] <= 1'b1;
            ban_cols[col_cnt-9'd3] <= 1'b1;
            ban_cols[col_cnt-9'd2] <= 1'b1;
            ban_cols[col_cnt-9'd1] <= 1'b1;
        end
        else if (ban_rows[row_cnt] == 1'b0) begin
            ban_cols <= 1'b0;
        end
    end
end

reg [10:0] base_addra;
reg [10:0] base_addrb;
reg [10:0] base_addra_reg;
reg [10:0] base_addrb_reg;

reg [6:0] writing_a_id;
reg [6:0] writing_b_id;
reg [14:0] port_A_score;
reg [14:0] port_B_score;
reg [6:0] port_A_id;
reg [6:0] port_B_id;

wire [21:0] min_patch;

always @(posedge clk or negedge en) begin
    if (!en) begin
        port_A_cnt <= 1'b0;
        port_B_cnt <= 1'b0;
    end
    else begin
        if (wea) begin
            port_A_cnt <= 1'b1;
        end
        else if (port_A_cnt == 4'd11) begin
            port_A_cnt <= 1'b0;
        end
        else if (wea_reg) begin
            port_A_cnt <= port_A_cnt + 1'b1;
        end
        
        if (web) begin
            port_B_cnt <= 1'b1;
        end
        else if (port_B_cnt == 4'd11) begin
            port_B_cnt <= 1'b0;
        end
        else if (web_reg) begin
            port_B_cnt <= port_B_cnt + 1'b1;
        end
        
    end
end

// reg out; // for temp simulation
reg [10:0] output_addr; // for temp simulation
always @(posedge clk or negedge en) begin
    if (!en) begin
        out <= 1'b0;
        output_addr <= 1'b0;
    end
    else begin
        if (row_cnt == 8'd239 && col_cnt == 9'd375) begin
            out <= 1'b1;
        end
        if (out) begin
            output_addr <= output_addr + 1'b1;
        end
        else begin
            output_addr <= output_addr;
        end
    end
end
always @(*) begin
    if (wea) begin
        addra = base_addra;
    end
    else if (wea_reg) begin
        case (port_A_cnt)
            4'd1: addra = base_addra_reg + 11'd1;
            4'd2: addra = base_addra_reg + 11'd2;
            4'd3: addra = base_addra_reg + 11'd3;
            4'd4: addra = base_addra_reg + 11'd4;
            4'd5: addra = base_addra_reg + 11'd5;
            4'd6: addra = base_addra_reg + 11'd6;
            4'd7: addra = base_addra_reg + 11'd7;
            4'd8: addra = base_addra_reg + 11'd8;
            4'd9: addra = base_addra_reg + 11'd9;
            4'd10: addra = base_addra_reg + 11'd10;
            4'd11: addra = base_addra_reg + 11'd11;
        endcase
    end
    else if (out) begin
        addra = output_addr;
    end
    else begin
        addra = 11'd0;
    end

    if (web) begin
        addrb = base_addrb;
    end
    else if (web_reg) begin
        case (port_B_cnt)
            4'd1: addrb = base_addrb_reg + 11'd1;
            4'd2: addrb = base_addrb_reg + 11'd2;
            4'd3: addrb = base_addrb_reg + 11'd3;
            4'd4: addrb = base_addrb_reg + 11'd4;
            4'd5: addrb = base_addrb_reg + 11'd5;
            4'd6: addrb = base_addrb_reg + 11'd6;
            4'd7: addrb = base_addrb_reg + 11'd7;
            4'd8: addrb = base_addrb_reg + 11'd8;
            4'd9: addrb = base_addrb_reg + 11'd9;
            4'd10: addrb = base_addrb_reg + 11'd10;
            4'd11: addrb = base_addrb_reg + 11'd11;
        endcase
    end
    else begin
        addrb = 11'd0;
    end
end


wire [14:0] output_score_0;
wire [14:0] output_score_1;
wire [14:0] output_score_2;
wire [14:0] output_score_3;
wire [14:0] output_score_4;
wire [14:0] output_score_5;
wire [14:0] output_score_6;
wire [14:0] output_score_7;
wire [14:0] output_score_8;
wire [14:0] output_score_9;
wire [14:0] output_score_10;
wire [14:0] output_score_11;
wire [14:0] output_score_12;
wire [14:0] output_score_13;
wire [14:0] output_score_14;
wire [14:0] output_score_15;
wire [14:0] output_score_16;
wire [14:0] output_score_17;
wire [14:0] output_score_18;
wire [14:0] output_score_19;
wire [14:0] output_score_20;
wire [14:0] output_score_21;
wire [14:0] output_score_22;
wire [14:0] output_score_23;
wire [14:0] output_score_24;
wire [14:0] output_score_25;
wire [14:0] output_score_26;
wire [14:0] output_score_27;
wire [14:0] output_score_28;
wire [14:0] output_score_29;
wire [14:0] output_score_30;
wire [14:0] output_score_31;
wire [14:0] output_score_32;
wire [14:0] output_score_33;
wire [14:0] output_score_34;
wire [14:0] output_score_35;
wire [14:0] output_score_36;
wire [14:0] output_score_37;
wire [14:0] output_score_38;
wire [14:0] output_score_39;
wire [14:0] output_score_40;
wire [14:0] output_score_41;
wire [14:0] output_score_42;
wire [14:0] output_score_43;
wire [14:0] output_score_44;
wire [14:0] output_score_45;
wire [14:0] output_score_46;
wire [14:0] output_score_47;
wire [14:0] output_score_48;
wire [14:0] output_score_49;
wire [14:0] output_score_50;
wire [14:0] output_score_51;
wire [14:0] output_score_52;
wire [14:0] output_score_53;
wire [14:0] output_score_54;
wire [14:0] output_score_55;
wire [14:0] output_score_56;
wire [14:0] output_score_57;
wire [14:0] output_score_58;
wire [14:0] output_score_59;
wire [14:0] output_score_60;
wire [14:0] output_score_61;
wire [14:0] output_score_62;
wire [14:0] output_score_63;
wire [14:0] output_score_64;
wire [14:0] output_score_65;
wire [14:0] output_score_66;
wire [14:0] output_score_67;
wire [14:0] output_score_68;
wire [14:0] output_score_69;
wire [14:0] output_score_70;
wire [14:0] output_score_71;
wire [14:0] output_score_72;
wire [14:0] output_score_73;
wire [14:0] output_score_74;
wire [14:0] output_score_75;
wire [14:0] output_score_76;
wire [14:0] output_score_77;
wire [14:0] output_score_78;
wire [14:0] output_score_79;
wire [14:0] output_score_80;
wire [14:0] output_score_81;
wire [14:0] output_score_82;
wire [14:0] output_score_83;
wire [14:0] output_score_84;
wire [14:0] output_score_85;
wire [14:0] output_score_86;
wire [14:0] output_score_87;
wire [14:0] output_score_88;
wire [14:0] output_score_89;
wire [14:0] output_score_90;
wire [14:0] output_score_91;
wire [14:0] output_score_92;
wire [14:0] output_score_93;
wire [14:0] output_score_94;
wire [14:0] output_score_95;
wire [14:0] output_score_96;
wire [14:0] output_score_97;
wire [14:0] output_score_98;
wire [14:0] output_score_99;
wire [6:0] P_ID_0;
wire [6:0] P_ID_1;
wire [6:0] P_ID_2;
wire [6:0] P_ID_3;
wire [6:0] P_ID_4;
wire [6:0] P_ID_5;
wire [6:0] P_ID_6;
wire [6:0] P_ID_7;
wire [6:0] P_ID_8;
wire [6:0] P_ID_9;
wire [6:0] P_ID_10;
wire [6:0] P_ID_11;
wire [6:0] P_ID_12;
wire [6:0] P_ID_13;
wire [6:0] P_ID_14;
wire [6:0] P_ID_15;
wire [6:0] P_ID_16;
wire [6:0] P_ID_17;
wire [6:0] P_ID_18;
wire [6:0] P_ID_19;
wire [6:0] P_ID_20;
wire [6:0] P_ID_21;
wire [6:0] P_ID_22;
wire [6:0] P_ID_23;
wire [6:0] P_ID_24;
wire [6:0] P_ID_25;
wire [6:0] P_ID_26;
wire [6:0] P_ID_27;
wire [6:0] P_ID_28;
wire [6:0] P_ID_29;
wire [6:0] P_ID_30;
wire [6:0] P_ID_31;
wire [6:0] P_ID_32;
wire [6:0] P_ID_33;
wire [6:0] P_ID_34;
wire [6:0] P_ID_35;
wire [6:0] P_ID_36;
wire [6:0] P_ID_37;
wire [6:0] P_ID_38;
wire [6:0] P_ID_39;
wire [6:0] P_ID_40;
wire [6:0] P_ID_41;
wire [6:0] P_ID_42;
wire [6:0] P_ID_43;
wire [6:0] P_ID_44;
wire [6:0] P_ID_45;
wire [6:0] P_ID_46;
wire [6:0] P_ID_47;
wire [6:0] P_ID_48;
wire [6:0] P_ID_49;
wire [6:0] P_ID_50;
wire [6:0] P_ID_51;
wire [6:0] P_ID_52;
wire [6:0] P_ID_53;
wire [6:0] P_ID_54;
wire [6:0] P_ID_55;
wire [6:0] P_ID_56;
wire [6:0] P_ID_57;
wire [6:0] P_ID_58;
wire [6:0] P_ID_59;
wire [6:0] P_ID_60;
wire [6:0] P_ID_61;
wire [6:0] P_ID_62;
wire [6:0] P_ID_63;
wire [6:0] P_ID_64;
wire [6:0] P_ID_65;
wire [6:0] P_ID_66;
wire [6:0] P_ID_67;
wire [6:0] P_ID_68;
wire [6:0] P_ID_69;
wire [6:0] P_ID_70;
wire [6:0] P_ID_71;
wire [6:0] P_ID_72;
wire [6:0] P_ID_73;
wire [6:0] P_ID_74;
wire [6:0] P_ID_75;
wire [6:0] P_ID_76;
wire [6:0] P_ID_77;
wire [6:0] P_ID_78;
wire [6:0] P_ID_79;
wire [6:0] P_ID_80;
wire [6:0] P_ID_81;
wire [6:0] P_ID_82;
wire [6:0] P_ID_83;
wire [6:0] P_ID_84;
wire [6:0] P_ID_85;
wire [6:0] P_ID_86;
wire [6:0] P_ID_87;
wire [6:0] P_ID_88;
wire [6:0] P_ID_89;
wire [6:0] P_ID_90;
wire [6:0] P_ID_91;
wire [6:0] P_ID_92;
wire [6:0] P_ID_93;
wire [6:0] P_ID_94;
wire [6:0] P_ID_95;
wire [6:0] P_ID_96;
wire [6:0] P_ID_97;
wire [6:0] P_ID_98;
wire [6:0] P_ID_99;
wire id_0;
wire id_1;
wire id_2;
wire id_3;
wire id_4;
wire id_5;
wire id_6;
wire id_7;
wire id_8;
wire id_9;
wire id_10;
wire id_11;
wire id_12;
wire id_13;
wire id_14;
wire id_15;
wire id_16;
wire id_17;
wire id_18;
wire id_19;
wire id_20;
wire id_21;
wire id_22;
wire id_23;
wire id_24;
wire id_25;
wire id_26;
wire id_27;
wire id_28;
wire id_29;
wire id_30;
wire id_31;
wire id_32;
wire id_33;
wire id_34;
wire id_35;
wire id_36;
wire id_37;
wire id_38;
wire id_39;
wire id_40;
wire id_41;
wire id_42;
wire id_43;
wire id_44;
wire id_45;
wire id_46;
wire id_47;
wire id_48;
wire id_49;
wire id_50;
wire id_51;
wire id_52;
wire id_53;
wire id_54;
wire id_55;
wire id_56;
wire id_57;
wire id_58;
wire id_59;
wire id_60;
wire id_61;
wire id_62;
wire id_63;
wire id_64;
wire id_65;
wire id_66;
wire id_67;
wire id_68;
wire id_69;
wire id_70;
wire id_71;
wire id_72;
wire id_73;
wire id_74;
wire id_75;
wire id_76;
wire id_77;
wire id_78;
wire id_79;
wire id_80;
wire id_81;
wire id_82;
wire id_83;
wire id_84;
wire id_85;
wire id_86;
wire id_87;
wire id_88;
wire id_89;
wire id_90;
wire id_91;
wire id_92;
wire id_93;
wire id_94;
wire id_95;
wire id_96;
wire id_97;
wire id_98;
wire id_99;
wire [6:0] renew_id;

always @(*) begin
    if (id_0 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd0) || writing_a_id == 7'd0)) begin
        base_addra = 11'd0;
        wea = 1'b1;
        port_A_score = output_score_0;
        port_A_id = 7'd0;
    end
    else if (id_0 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd0) || writing_b_id == 7'd0)) begin
        base_addrb = 11'd0;
        web = 1'b1;
        port_B_score = output_score_0;
        port_B_id = 7'd0;
    end
    else if (id_1 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd1) || writing_a_id == 7'd1)) begin
        base_addra = 11'd12;
        wea = 1'b1;
        port_A_score = output_score_1;
        port_A_id = 7'd1;
    end
    else if (id_1 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd1) || writing_b_id == 7'd1)) begin
        base_addrb = 11'd12;
        web = 1'b1;
        port_B_score = output_score_1;
        port_B_id = 7'd1;
    end
    else if (id_2 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd2) || writing_a_id == 7'd2)) begin
        base_addra = 11'd24;
        wea = 1'b1;
        port_A_score = output_score_2;
        port_A_id = 7'd2;
    end
    else if (id_2 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd2) || writing_b_id == 7'd2)) begin
        base_addrb = 11'd24;
        web = 1'b1;
        port_B_score = output_score_2;
        port_B_id = 7'd2;
    end
    else if (id_3 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd3) || writing_a_id == 7'd3)) begin
        base_addra = 11'd36;
        wea = 1'b1;
        port_A_score = output_score_3;
        port_A_id = 7'd3;
    end
    else if (id_3 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd3) || writing_b_id == 7'd3)) begin
        base_addrb = 11'd36;
        web = 1'b1;
        port_B_score = output_score_3;
        port_B_id = 7'd3;
    end
    else if (id_4 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd4) || writing_a_id == 7'd4)) begin
        base_addra = 11'd48;
        wea = 1'b1;
        port_A_score = output_score_4;
        port_A_id = 7'd4;
    end
    else if (id_4 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd4) || writing_b_id == 7'd4)) begin
        base_addrb = 11'd48;
        web = 1'b1;
        port_B_score = output_score_4;
        port_B_id = 7'd4;
    end
    else if (id_5 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd5) || writing_a_id == 7'd5)) begin
        base_addra = 11'd60;
        wea = 1'b1;
        port_A_score = output_score_5;
        port_A_id = 7'd5;
    end
    else if (id_5 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd5) || writing_b_id == 7'd5)) begin
        base_addrb = 11'd60;
        web = 1'b1;
        port_B_score = output_score_5;
        port_B_id = 7'd5;
    end
    else if (id_6 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd6) || writing_a_id == 7'd6)) begin
        base_addra = 11'd72;
        wea = 1'b1;
        port_A_score = output_score_6;
        port_A_id = 7'd6;
    end
    else if (id_6 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd6) || writing_b_id == 7'd6)) begin
        base_addrb = 11'd72;
        web = 1'b1;
        port_B_score = output_score_6;
        port_B_id = 7'd6;
    end
    else if (id_7 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd7) || writing_a_id == 7'd7)) begin
        base_addra = 11'd84;
        wea = 1'b1;
        port_A_score = output_score_7;
        port_A_id = 7'd7;
    end
    else if (id_7 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd7) || writing_b_id == 7'd7)) begin
        base_addrb = 11'd84;
        web = 1'b1;
        port_B_score = output_score_7;
        port_B_id = 7'd7;
    end
    else if (id_8 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd8) || writing_a_id == 7'd8)) begin
        base_addra = 11'd96;
        wea = 1'b1;
        port_A_score = output_score_8;
        port_A_id = 7'd8;
    end
    else if (id_8 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd8) || writing_b_id == 7'd8)) begin
        base_addrb = 11'd96;
        web = 1'b1;
        port_B_score = output_score_8;
        port_B_id = 7'd8;
    end
    else if (id_9 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd9) || writing_a_id == 7'd9)) begin
        base_addra = 11'd108;
        wea = 1'b1;
        port_A_score = output_score_9;
        port_A_id = 7'd9;
    end
    else if (id_9 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd9) || writing_b_id == 7'd9)) begin
        base_addrb = 11'd108;
        web = 1'b1;
        port_B_score = output_score_9;
        port_B_id = 7'd9;
    end
    else if (id_10 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd10) || writing_a_id == 7'd10)) begin
        base_addra = 11'd120;
        wea = 1'b1;
        port_A_score = output_score_10;
        port_A_id = 7'd10;
    end
    else if (id_10 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd10) || writing_b_id == 7'd10)) begin
        base_addrb = 11'd120;
        web = 1'b1;
        port_B_score = output_score_10;
        port_B_id = 7'd10;
    end
    else if (id_11 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd11) || writing_a_id == 7'd11)) begin
        base_addra = 11'd132;
        wea = 1'b1;
        port_A_score = output_score_11;
        port_A_id = 7'd11;
    end
    else if (id_11 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd11) || writing_b_id == 7'd11)) begin
        base_addrb = 11'd132;
        web = 1'b1;
        port_B_score = output_score_11;
        port_B_id = 7'd11;
    end
    else if (id_12 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd12) || writing_a_id == 7'd12)) begin
        base_addra = 11'd144;
        wea = 1'b1;
        port_A_score = output_score_12;
        port_A_id = 7'd12;
    end
    else if (id_12 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd12) || writing_b_id == 7'd12)) begin
        base_addrb = 11'd144;
        web = 1'b1;
        port_B_score = output_score_12;
        port_B_id = 7'd12;
    end
    else if (id_13 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd13) || writing_a_id == 7'd13)) begin
        base_addra = 11'd156;
        wea = 1'b1;
        port_A_score = output_score_13;
        port_A_id = 7'd13;
    end
    else if (id_13 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd13) || writing_b_id == 7'd13)) begin
        base_addrb = 11'd156;
        web = 1'b1;
        port_B_score = output_score_13;
        port_B_id = 7'd13;
    end
    else if (id_14 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd14) || writing_a_id == 7'd14)) begin
        base_addra = 11'd168;
        wea = 1'b1;
        port_A_score = output_score_14;
        port_A_id = 7'd14;
    end
    else if (id_14 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd14) || writing_b_id == 7'd14)) begin
        base_addrb = 11'd168;
        web = 1'b1;
        port_B_score = output_score_14;
        port_B_id = 7'd14;
    end
    else if (id_15 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd15) || writing_a_id == 7'd15)) begin
        base_addra = 11'd180;
        wea = 1'b1;
        port_A_score = output_score_15;
        port_A_id = 7'd15;
    end
    else if (id_15 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd15) || writing_b_id == 7'd15)) begin
        base_addrb = 11'd180;
        web = 1'b1;
        port_B_score = output_score_15;
        port_B_id = 7'd15;
    end
    else if (id_16 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd16) || writing_a_id == 7'd16)) begin
        base_addra = 11'd192;
        wea = 1'b1;
        port_A_score = output_score_16;
        port_A_id = 7'd16;
    end
    else if (id_16 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd16) || writing_b_id == 7'd16)) begin
        base_addrb = 11'd192;
        web = 1'b1;
        port_B_score = output_score_16;
        port_B_id = 7'd16;
    end
    else if (id_17 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd17) || writing_a_id == 7'd17)) begin
        base_addra = 11'd204;
        wea = 1'b1;
        port_A_score = output_score_17;
        port_A_id = 7'd17;
    end
    else if (id_17 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd17) || writing_b_id == 7'd17)) begin
        base_addrb = 11'd204;
        web = 1'b1;
        port_B_score = output_score_17;
        port_B_id = 7'd17;
    end
    else if (id_18 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd18) || writing_a_id == 7'd18)) begin
        base_addra = 11'd216;
        wea = 1'b1;
        port_A_score = output_score_18;
        port_A_id = 7'd18;
    end
    else if (id_18 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd18) || writing_b_id == 7'd18)) begin
        base_addrb = 11'd216;
        web = 1'b1;
        port_B_score = output_score_18;
        port_B_id = 7'd18;
    end
    else if (id_19 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd19) || writing_a_id == 7'd19)) begin
        base_addra = 11'd228;
        wea = 1'b1;
        port_A_score = output_score_19;
        port_A_id = 7'd19;
    end
    else if (id_19 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd19) || writing_b_id == 7'd19)) begin
        base_addrb = 11'd228;
        web = 1'b1;
        port_B_score = output_score_19;
        port_B_id = 7'd19;
    end
    else if (id_20 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd20) || writing_a_id == 7'd20)) begin
        base_addra = 11'd240;
        wea = 1'b1;
        port_A_score = output_score_20;
        port_A_id = 7'd20;
    end
    else if (id_20 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd20) || writing_b_id == 7'd20)) begin
        base_addrb = 11'd240;
        web = 1'b1;
        port_B_score = output_score_20;
        port_B_id = 7'd20;
    end
    else if (id_21 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd21) || writing_a_id == 7'd21)) begin
        base_addra = 11'd252;
        wea = 1'b1;
        port_A_score = output_score_21;
        port_A_id = 7'd21;
    end
    else if (id_21 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd21) || writing_b_id == 7'd21)) begin
        base_addrb = 11'd252;
        web = 1'b1;
        port_B_score = output_score_21;
        port_B_id = 7'd21;
    end
    else if (id_22 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd22) || writing_a_id == 7'd22)) begin
        base_addra = 11'd264;
        wea = 1'b1;
        port_A_score = output_score_22;
        port_A_id = 7'd22;
    end
    else if (id_22 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd22) || writing_b_id == 7'd22)) begin
        base_addrb = 11'd264;
        web = 1'b1;
        port_B_score = output_score_22;
        port_B_id = 7'd22;
    end
    else if (id_23 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd23) || writing_a_id == 7'd23)) begin
        base_addra = 11'd276;
        wea = 1'b1;
        port_A_score = output_score_23;
        port_A_id = 7'd23;
    end
    else if (id_23 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd23) || writing_b_id == 7'd23)) begin
        base_addrb = 11'd276;
        web = 1'b1;
        port_B_score = output_score_23;
        port_B_id = 7'd23;
    end
    else if (id_24 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd24) || writing_a_id == 7'd24)) begin
        base_addra = 11'd288;
        wea = 1'b1;
        port_A_score = output_score_24;
        port_A_id = 7'd24;
    end
    else if (id_24 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd24) || writing_b_id == 7'd24)) begin
        base_addrb = 11'd288;
        web = 1'b1;
        port_B_score = output_score_24;
        port_B_id = 7'd24;
    end
    else if (id_25 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd25) || writing_a_id == 7'd25)) begin
        base_addra = 11'd300;
        wea = 1'b1;
        port_A_score = output_score_25;
        port_A_id = 7'd25;
    end
    else if (id_25 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd25) || writing_b_id == 7'd25)) begin
        base_addrb = 11'd300;
        web = 1'b1;
        port_B_score = output_score_25;
        port_B_id = 7'd25;
    end
    else if (id_26 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd26) || writing_a_id == 7'd26)) begin
        base_addra = 11'd312;
        wea = 1'b1;
        port_A_score = output_score_26;
        port_A_id = 7'd26;
    end
    else if (id_26 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd26) || writing_b_id == 7'd26)) begin
        base_addrb = 11'd312;
        web = 1'b1;
        port_B_score = output_score_26;
        port_B_id = 7'd26;
    end
    else if (id_27 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd27) || writing_a_id == 7'd27)) begin
        base_addra = 11'd324;
        wea = 1'b1;
        port_A_score = output_score_27;
        port_A_id = 7'd27;
    end
    else if (id_27 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd27) || writing_b_id == 7'd27)) begin
        base_addrb = 11'd324;
        web = 1'b1;
        port_B_score = output_score_27;
        port_B_id = 7'd27;
    end
    else if (id_28 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd28) || writing_a_id == 7'd28)) begin
        base_addra = 11'd336;
        wea = 1'b1;
        port_A_score = output_score_28;
        port_A_id = 7'd28;
    end
    else if (id_28 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd28) || writing_b_id == 7'd28)) begin
        base_addrb = 11'd336;
        web = 1'b1;
        port_B_score = output_score_28;
        port_B_id = 7'd28;
    end
    else if (id_29 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd29) || writing_a_id == 7'd29)) begin
        base_addra = 11'd348;
        wea = 1'b1;
        port_A_score = output_score_29;
        port_A_id = 7'd29;
    end
    else if (id_29 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd29) || writing_b_id == 7'd29)) begin
        base_addrb = 11'd348;
        web = 1'b1;
        port_B_score = output_score_29;
        port_B_id = 7'd29;
    end
    else if (id_30 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd30) || writing_a_id == 7'd30)) begin
        base_addra = 11'd360;
        wea = 1'b1;
        port_A_score = output_score_30;
        port_A_id = 7'd30;
    end
    else if (id_30 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd30) || writing_b_id == 7'd30)) begin
        base_addrb = 11'd360;
        web = 1'b1;
        port_B_score = output_score_30;
        port_B_id = 7'd30;
    end
    else if (id_31 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd31) || writing_a_id == 7'd31)) begin
        base_addra = 11'd372;
        wea = 1'b1;
        port_A_score = output_score_31;
        port_A_id = 7'd31;
    end
    else if (id_31 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd31) || writing_b_id == 7'd31)) begin
        base_addrb = 11'd372;
        web = 1'b1;
        port_B_score = output_score_31;
        port_B_id = 7'd31;
    end
    else if (id_32 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd32) || writing_a_id == 7'd32)) begin
        base_addra = 11'd384;
        wea = 1'b1;
        port_A_score = output_score_32;
        port_A_id = 7'd32;
    end
    else if (id_32 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd32) || writing_b_id == 7'd32)) begin
        base_addrb = 11'd384;
        web = 1'b1;
        port_B_score = output_score_32;
        port_B_id = 7'd32;
    end
    else if (id_33 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd33) || writing_a_id == 7'd33)) begin
        base_addra = 11'd396;
        wea = 1'b1;
        port_A_score = output_score_33;
        port_A_id = 7'd33;
    end
    else if (id_33 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd33) || writing_b_id == 7'd33)) begin
        base_addrb = 11'd396;
        web = 1'b1;
        port_B_score = output_score_33;
        port_B_id = 7'd33;
    end
    else if (id_34 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd34) || writing_a_id == 7'd34)) begin
        base_addra = 11'd408;
        wea = 1'b1;
        port_A_score = output_score_34;
        port_A_id = 7'd34;
    end
    else if (id_34 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd34) || writing_b_id == 7'd34)) begin
        base_addrb = 11'd408;
        web = 1'b1;
        port_B_score = output_score_34;
        port_B_id = 7'd34;
    end
    else if (id_35 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd35) || writing_a_id == 7'd35)) begin
        base_addra = 11'd420;
        wea = 1'b1;
        port_A_score = output_score_35;
        port_A_id = 7'd35;
    end
    else if (id_35 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd35) || writing_b_id == 7'd35)) begin
        base_addrb = 11'd420;
        web = 1'b1;
        port_B_score = output_score_35;
        port_B_id = 7'd35;
    end
    else if (id_36 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd36) || writing_a_id == 7'd36)) begin
        base_addra = 11'd432;
        wea = 1'b1;
        port_A_score = output_score_36;
        port_A_id = 7'd36;
    end
    else if (id_36 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd36) || writing_b_id == 7'd36)) begin
        base_addrb = 11'd432;
        web = 1'b1;
        port_B_score = output_score_36;
        port_B_id = 7'd36;
    end
    else if (id_37 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd37) || writing_a_id == 7'd37)) begin
        base_addra = 11'd444;
        wea = 1'b1;
        port_A_score = output_score_37;
        port_A_id = 7'd37;
    end
    else if (id_37 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd37) || writing_b_id == 7'd37)) begin
        base_addrb = 11'd444;
        web = 1'b1;
        port_B_score = output_score_37;
        port_B_id = 7'd37;
    end
    else if (id_38 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd38) || writing_a_id == 7'd38)) begin
        base_addra = 11'd456;
        wea = 1'b1;
        port_A_score = output_score_38;
        port_A_id = 7'd38;
    end
    else if (id_38 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd38) || writing_b_id == 7'd38)) begin
        base_addrb = 11'd456;
        web = 1'b1;
        port_B_score = output_score_38;
        port_B_id = 7'd38;
    end
    else if (id_39 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd39) || writing_a_id == 7'd39)) begin
        base_addra = 11'd468;
        wea = 1'b1;
        port_A_score = output_score_39;
        port_A_id = 7'd39;
    end
    else if (id_39 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd39) || writing_b_id == 7'd39)) begin
        base_addrb = 11'd468;
        web = 1'b1;
        port_B_score = output_score_39;
        port_B_id = 7'd39;
    end
    else if (id_40 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd40) || writing_a_id == 7'd40)) begin
        base_addra = 11'd480;
        wea = 1'b1;
        port_A_score = output_score_40;
        port_A_id = 7'd40;
    end
    else if (id_40 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd40) || writing_b_id == 7'd40)) begin
        base_addrb = 11'd480;
        web = 1'b1;
        port_B_score = output_score_40;
        port_B_id = 7'd40;
    end
    else if (id_41 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd41) || writing_a_id == 7'd41)) begin
        base_addra = 11'd492;
        wea = 1'b1;
        port_A_score = output_score_41;
        port_A_id = 7'd41;
    end
    else if (id_41 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd41) || writing_b_id == 7'd41)) begin
        base_addrb = 11'd492;
        web = 1'b1;
        port_B_score = output_score_41;
        port_B_id = 7'd41;
    end
    else if (id_42 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd42) || writing_a_id == 7'd42)) begin
        base_addra = 11'd504;
        wea = 1'b1;
        port_A_score = output_score_42;
        port_A_id = 7'd42;
    end
    else if (id_42 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd42) || writing_b_id == 7'd42)) begin
        base_addrb = 11'd504;
        web = 1'b1;
        port_B_score = output_score_42;
        port_B_id = 7'd42;
    end
    else if (id_43 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd43) || writing_a_id == 7'd43)) begin
        base_addra = 11'd516;
        wea = 1'b1;
        port_A_score = output_score_43;
        port_A_id = 7'd43;
    end
    else if (id_43 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd43) || writing_b_id == 7'd43)) begin
        base_addrb = 11'd516;
        web = 1'b1;
        port_B_score = output_score_43;
        port_B_id = 7'd43;
    end
    else if (id_44 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd44) || writing_a_id == 7'd44)) begin
        base_addra = 11'd528;
        wea = 1'b1;
        port_A_score = output_score_44;
        port_A_id = 7'd44;
    end
    else if (id_44 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd44) || writing_b_id == 7'd44)) begin
        base_addrb = 11'd528;
        web = 1'b1;
        port_B_score = output_score_44;
        port_B_id = 7'd44;
    end
    else if (id_45 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd45) || writing_a_id == 7'd45)) begin
        base_addra = 11'd540;
        wea = 1'b1;
        port_A_score = output_score_45;
        port_A_id = 7'd45;
    end
    else if (id_45 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd45) || writing_b_id == 7'd45)) begin
        base_addrb = 11'd540;
        web = 1'b1;
        port_B_score = output_score_45;
        port_B_id = 7'd45;
    end
    else if (id_46 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd46) || writing_a_id == 7'd46)) begin
        base_addra = 11'd552;
        wea = 1'b1;
        port_A_score = output_score_46;
        port_A_id = 7'd46;
    end
    else if (id_46 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd46) || writing_b_id == 7'd46)) begin
        base_addrb = 11'd552;
        web = 1'b1;
        port_B_score = output_score_46;
        port_B_id = 7'd46;
    end
    else if (id_47 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd47) || writing_a_id == 7'd47)) begin
        base_addra = 11'd564;
        wea = 1'b1;
        port_A_score = output_score_47;
        port_A_id = 7'd47;
    end
    else if (id_47 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd47) || writing_b_id == 7'd47)) begin
        base_addrb = 11'd564;
        web = 1'b1;
        port_B_score = output_score_47;
        port_B_id = 7'd47;
    end
    else if (id_48 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd48) || writing_a_id == 7'd48)) begin
        base_addra = 11'd576;
        wea = 1'b1;
        port_A_score = output_score_48;
        port_A_id = 7'd48;
    end
    else if (id_48 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd48) || writing_b_id == 7'd48)) begin
        base_addrb = 11'd576;
        web = 1'b1;
        port_B_score = output_score_48;
        port_B_id = 7'd48;
    end
    else if (id_49 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd49) || writing_a_id == 7'd49)) begin
        base_addra = 11'd588;
        wea = 1'b1;
        port_A_score = output_score_49;
        port_A_id = 7'd49;
    end
    else if (id_49 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd49) || writing_b_id == 7'd49)) begin
        base_addrb = 11'd588;
        web = 1'b1;
        port_B_score = output_score_49;
        port_B_id = 7'd49;
    end
    else if (id_50 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd50) || writing_a_id == 7'd50)) begin
        base_addra = 11'd600;
        wea = 1'b1;
        port_A_score = output_score_50;
        port_A_id = 7'd50;
    end
    else if (id_50 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd50) || writing_b_id == 7'd50)) begin
        base_addrb = 11'd600;
        web = 1'b1;
        port_B_score = output_score_50;
        port_B_id = 7'd50;
    end
    else if (id_51 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd51) || writing_a_id == 7'd51)) begin
        base_addra = 11'd612;
        wea = 1'b1;
        port_A_score = output_score_51;
        port_A_id = 7'd51;
    end
    else if (id_51 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd51) || writing_b_id == 7'd51)) begin
        base_addrb = 11'd612;
        web = 1'b1;
        port_B_score = output_score_51;
        port_B_id = 7'd51;
    end
    else if (id_52 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd52) || writing_a_id == 7'd52)) begin
        base_addra = 11'd624;
        wea = 1'b1;
        port_A_score = output_score_52;
        port_A_id = 7'd52;
    end
    else if (id_52 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd52) || writing_b_id == 7'd52)) begin
        base_addrb = 11'd624;
        web = 1'b1;
        port_B_score = output_score_52;
        port_B_id = 7'd52;
    end
    else if (id_53 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd53) || writing_a_id == 7'd53)) begin
        base_addra = 11'd636;
        wea = 1'b1;
        port_A_score = output_score_53;
        port_A_id = 7'd53;
    end
    else if (id_53 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd53) || writing_b_id == 7'd53)) begin
        base_addrb = 11'd636;
        web = 1'b1;
        port_B_score = output_score_53;
        port_B_id = 7'd53;
    end
    else if (id_54 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd54) || writing_a_id == 7'd54)) begin
        base_addra = 11'd648;
        wea = 1'b1;
        port_A_score = output_score_54;
        port_A_id = 7'd54;
    end
    else if (id_54 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd54) || writing_b_id == 7'd54)) begin
        base_addrb = 11'd648;
        web = 1'b1;
        port_B_score = output_score_54;
        port_B_id = 7'd54;
    end
    else if (id_55 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd55) || writing_a_id == 7'd55)) begin
        base_addra = 11'd660;
        wea = 1'b1;
        port_A_score = output_score_55;
        port_A_id = 7'd55;
    end
    else if (id_55 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd55) || writing_b_id == 7'd55)) begin
        base_addrb = 11'd660;
        web = 1'b1;
        port_B_score = output_score_55;
        port_B_id = 7'd55;
    end
    else if (id_56 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd56) || writing_a_id == 7'd56)) begin
        base_addra = 11'd672;
        wea = 1'b1;
        port_A_score = output_score_56;
        port_A_id = 7'd56;
    end
    else if (id_56 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd56) || writing_b_id == 7'd56)) begin
        base_addrb = 11'd672;
        web = 1'b1;
        port_B_score = output_score_56;
        port_B_id = 7'd56;
    end
    else if (id_57 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd57) || writing_a_id == 7'd57)) begin
        base_addra = 11'd684;
        wea = 1'b1;
        port_A_score = output_score_57;
        port_A_id = 7'd57;
    end
    else if (id_57 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd57) || writing_b_id == 7'd57)) begin
        base_addrb = 11'd684;
        web = 1'b1;
        port_B_score = output_score_57;
        port_B_id = 7'd57;
    end
    else if (id_58 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd58) || writing_a_id == 7'd58)) begin
        base_addra = 11'd696;
        wea = 1'b1;
        port_A_score = output_score_58;
        port_A_id = 7'd58;
    end
    else if (id_58 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd58) || writing_b_id == 7'd58)) begin
        base_addrb = 11'd696;
        web = 1'b1;
        port_B_score = output_score_58;
        port_B_id = 7'd58;
    end
    else if (id_59 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd59) || writing_a_id == 7'd59)) begin
        base_addra = 11'd708;
        wea = 1'b1;
        port_A_score = output_score_59;
        port_A_id = 7'd59;
    end
    else if (id_59 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd59) || writing_b_id == 7'd59)) begin
        base_addrb = 11'd708;
        web = 1'b1;
        port_B_score = output_score_59;
        port_B_id = 7'd59;
    end
    else if (id_60 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd60) || writing_a_id == 7'd60)) begin
        base_addra = 11'd720;
        wea = 1'b1;
        port_A_score = output_score_60;
        port_A_id = 7'd60;
    end
    else if (id_60 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd60) || writing_b_id == 7'd60)) begin
        base_addrb = 11'd720;
        web = 1'b1;
        port_B_score = output_score_60;
        port_B_id = 7'd60;
    end
    else if (id_61 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd61) || writing_a_id == 7'd61)) begin
        base_addra = 11'd732;
        wea = 1'b1;
        port_A_score = output_score_61;
        port_A_id = 7'd61;
    end
    else if (id_61 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd61) || writing_b_id == 7'd61)) begin
        base_addrb = 11'd732;
        web = 1'b1;
        port_B_score = output_score_61;
        port_B_id = 7'd61;
    end
    else if (id_62 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd62) || writing_a_id == 7'd62)) begin
        base_addra = 11'd744;
        wea = 1'b1;
        port_A_score = output_score_62;
        port_A_id = 7'd62;
    end
    else if (id_62 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd62) || writing_b_id == 7'd62)) begin
        base_addrb = 11'd744;
        web = 1'b1;
        port_B_score = output_score_62;
        port_B_id = 7'd62;
    end
    else if (id_63 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd63) || writing_a_id == 7'd63)) begin
        base_addra = 11'd756;
        wea = 1'b1;
        port_A_score = output_score_63;
        port_A_id = 7'd63;
    end
    else if (id_63 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd63) || writing_b_id == 7'd63)) begin
        base_addrb = 11'd756;
        web = 1'b1;
        port_B_score = output_score_63;
        port_B_id = 7'd63;
    end
    else if (id_64 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd64) || writing_a_id == 7'd64)) begin
        base_addra = 11'd768;
        wea = 1'b1;
        port_A_score = output_score_64;
        port_A_id = 7'd64;
    end
    else if (id_64 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd64) || writing_b_id == 7'd64)) begin
        base_addrb = 11'd768;
        web = 1'b1;
        port_B_score = output_score_64;
        port_B_id = 7'd64;
    end
    else if (id_65 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd65) || writing_a_id == 7'd65)) begin
        base_addra = 11'd780;
        wea = 1'b1;
        port_A_score = output_score_65;
        port_A_id = 7'd65;
    end
    else if (id_65 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd65) || writing_b_id == 7'd65)) begin
        base_addrb = 11'd780;
        web = 1'b1;
        port_B_score = output_score_65;
        port_B_id = 7'd65;
    end
    else if (id_66 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd66) || writing_a_id == 7'd66)) begin
        base_addra = 11'd792;
        wea = 1'b1;
        port_A_score = output_score_66;
        port_A_id = 7'd66;
    end
    else if (id_66 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd66) || writing_b_id == 7'd66)) begin
        base_addrb = 11'd792;
        web = 1'b1;
        port_B_score = output_score_66;
        port_B_id = 7'd66;
    end
    else if (id_67 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd67) || writing_a_id == 7'd67)) begin
        base_addra = 11'd804;
        wea = 1'b1;
        port_A_score = output_score_67;
        port_A_id = 7'd67;
    end
    else if (id_67 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd67) || writing_b_id == 7'd67)) begin
        base_addrb = 11'd804;
        web = 1'b1;
        port_B_score = output_score_67;
        port_B_id = 7'd67;
    end
    else if (id_68 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd68) || writing_a_id == 7'd68)) begin
        base_addra = 11'd816;
        wea = 1'b1;
        port_A_score = output_score_68;
        port_A_id = 7'd68;
    end
    else if (id_68 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd68) || writing_b_id == 7'd68)) begin
        base_addrb = 11'd816;
        web = 1'b1;
        port_B_score = output_score_68;
        port_B_id = 7'd68;
    end
    else if (id_69 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd69) || writing_a_id == 7'd69)) begin
        base_addra = 11'd828;
        wea = 1'b1;
        port_A_score = output_score_69;
        port_A_id = 7'd69;
    end
    else if (id_69 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd69) || writing_b_id == 7'd69)) begin
        base_addrb = 11'd828;
        web = 1'b1;
        port_B_score = output_score_69;
        port_B_id = 7'd69;
    end
    else if (id_70 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd70) || writing_a_id == 7'd70)) begin
        base_addra = 11'd840;
        wea = 1'b1;
        port_A_score = output_score_70;
        port_A_id = 7'd70;
    end
    else if (id_70 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd70) || writing_b_id == 7'd70)) begin
        base_addrb = 11'd840;
        web = 1'b1;
        port_B_score = output_score_70;
        port_B_id = 7'd70;
    end
    else if (id_71 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd71) || writing_a_id == 7'd71)) begin
        base_addra = 11'd852;
        wea = 1'b1;
        port_A_score = output_score_71;
        port_A_id = 7'd71;
    end
    else if (id_71 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd71) || writing_b_id == 7'd71)) begin
        base_addrb = 11'd852;
        web = 1'b1;
        port_B_score = output_score_71;
        port_B_id = 7'd71;
    end
    else if (id_72 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd72) || writing_a_id == 7'd72)) begin
        base_addra = 11'd864;
        wea = 1'b1;
        port_A_score = output_score_72;
        port_A_id = 7'd72;
    end
    else if (id_72 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd72) || writing_b_id == 7'd72)) begin
        base_addrb = 11'd864;
        web = 1'b1;
        port_B_score = output_score_72;
        port_B_id = 7'd72;
    end
    else if (id_73 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd73) || writing_a_id == 7'd73)) begin
        base_addra = 11'd876;
        wea = 1'b1;
        port_A_score = output_score_73;
        port_A_id = 7'd73;
    end
    else if (id_73 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd73) || writing_b_id == 7'd73)) begin
        base_addrb = 11'd876;
        web = 1'b1;
        port_B_score = output_score_73;
        port_B_id = 7'd73;
    end
    else if (id_74 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd74) || writing_a_id == 7'd74)) begin
        base_addra = 11'd888;
        wea = 1'b1;
        port_A_score = output_score_74;
        port_A_id = 7'd74;
    end
    else if (id_74 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd74) || writing_b_id == 7'd74)) begin
        base_addrb = 11'd888;
        web = 1'b1;
        port_B_score = output_score_74;
        port_B_id = 7'd74;
    end
    else if (id_75 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd75) || writing_a_id == 7'd75)) begin
        base_addra = 11'd900;
        wea = 1'b1;
        port_A_score = output_score_75;
        port_A_id = 7'd75;
    end
    else if (id_75 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd75) || writing_b_id == 7'd75)) begin
        base_addrb = 11'd900;
        web = 1'b1;
        port_B_score = output_score_75;
        port_B_id = 7'd75;
    end
    else if (id_76 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd76) || writing_a_id == 7'd76)) begin
        base_addra = 11'd912;
        wea = 1'b1;
        port_A_score = output_score_76;
        port_A_id = 7'd76;
    end
    else if (id_76 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd76) || writing_b_id == 7'd76)) begin
        base_addrb = 11'd912;
        web = 1'b1;
        port_B_score = output_score_76;
        port_B_id = 7'd76;
    end
    else if (id_77 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd77) || writing_a_id == 7'd77)) begin
        base_addra = 11'd924;
        wea = 1'b1;
        port_A_score = output_score_77;
        port_A_id = 7'd77;
    end
    else if (id_77 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd77) || writing_b_id == 7'd77)) begin
        base_addrb = 11'd924;
        web = 1'b1;
        port_B_score = output_score_77;
        port_B_id = 7'd77;
    end
    else if (id_78 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd78) || writing_a_id == 7'd78)) begin
        base_addra = 11'd936;
        wea = 1'b1;
        port_A_score = output_score_78;
        port_A_id = 7'd78;
    end
    else if (id_78 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd78) || writing_b_id == 7'd78)) begin
        base_addrb = 11'd936;
        web = 1'b1;
        port_B_score = output_score_78;
        port_B_id = 7'd78;
    end
    else if (id_79 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd79) || writing_a_id == 7'd79)) begin
        base_addra = 11'd948;
        wea = 1'b1;
        port_A_score = output_score_79;
        port_A_id = 7'd79;
    end
    else if (id_79 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd79) || writing_b_id == 7'd79)) begin
        base_addrb = 11'd948;
        web = 1'b1;
        port_B_score = output_score_79;
        port_B_id = 7'd79;
    end
    else if (id_80 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd80) || writing_a_id == 7'd80)) begin
        base_addra = 11'd960;
        wea = 1'b1;
        port_A_score = output_score_80;
        port_A_id = 7'd80;
    end
    else if (id_80 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd80) || writing_b_id == 7'd80)) begin
        base_addrb = 11'd960;
        web = 1'b1;
        port_B_score = output_score_80;
        port_B_id = 7'd80;
    end
    else if (id_81 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd81) || writing_a_id == 7'd81)) begin
        base_addra = 11'd972;
        wea = 1'b1;
        port_A_score = output_score_81;
        port_A_id = 7'd81;
    end
    else if (id_81 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd81) || writing_b_id == 7'd81)) begin
        base_addrb = 11'd972;
        web = 1'b1;
        port_B_score = output_score_81;
        port_B_id = 7'd81;
    end
    else if (id_82 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd82) || writing_a_id == 7'd82)) begin
        base_addra = 11'd984;
        wea = 1'b1;
        port_A_score = output_score_82;
        port_A_id = 7'd82;
    end
    else if (id_82 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd82) || writing_b_id == 7'd82)) begin
        base_addrb = 11'd984;
        web = 1'b1;
        port_B_score = output_score_82;
        port_B_id = 7'd82;
    end
    else if (id_83 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd83) || writing_a_id == 7'd83)) begin
        base_addra = 11'd996;
        wea = 1'b1;
        port_A_score = output_score_83;
        port_A_id = 7'd83;
    end
    else if (id_83 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd83) || writing_b_id == 7'd83)) begin
        base_addrb = 11'd996;
        web = 1'b1;
        port_B_score = output_score_83;
        port_B_id = 7'd83;
    end
    else if (id_84 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd84) || writing_a_id == 7'd84)) begin
        base_addra = 11'd1008;
        wea = 1'b1;
        port_A_score = output_score_84;
        port_A_id = 7'd84;
    end
    else if (id_84 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd84) || writing_b_id == 7'd84)) begin
        base_addrb = 11'd1008;
        web = 1'b1;
        port_B_score = output_score_84;
        port_B_id = 7'd84;
    end
    else if (id_85 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd85) || writing_a_id == 7'd85)) begin
        base_addra = 11'd1020;
        wea = 1'b1;
        port_A_score = output_score_85;
        port_A_id = 7'd85;
    end
    else if (id_85 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd85) || writing_b_id == 7'd85)) begin
        base_addrb = 11'd1020;
        web = 1'b1;
        port_B_score = output_score_85;
        port_B_id = 7'd85;
    end
    else if (id_86 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd86) || writing_a_id == 7'd86)) begin
        base_addra = 11'd1032;
        wea = 1'b1;
        port_A_score = output_score_86;
        port_A_id = 7'd86;
    end
    else if (id_86 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd86) || writing_b_id == 7'd86)) begin
        base_addrb = 11'd1032;
        web = 1'b1;
        port_B_score = output_score_86;
        port_B_id = 7'd86;
    end
    else if (id_87 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd87) || writing_a_id == 7'd87)) begin
        base_addra = 11'd1044;
        wea = 1'b1;
        port_A_score = output_score_87;
        port_A_id = 7'd87;
    end
    else if (id_87 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd87) || writing_b_id == 7'd87)) begin
        base_addrb = 11'd1044;
        web = 1'b1;
        port_B_score = output_score_87;
        port_B_id = 7'd87;
    end
    else if (id_88 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd88) || writing_a_id == 7'd88)) begin
        base_addra = 11'd1056;
        wea = 1'b1;
        port_A_score = output_score_88;
        port_A_id = 7'd88;
    end
    else if (id_88 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd88) || writing_b_id == 7'd88)) begin
        base_addrb = 11'd1056;
        web = 1'b1;
        port_B_score = output_score_88;
        port_B_id = 7'd88;
    end
    else if (id_89 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd89) || writing_a_id == 7'd89)) begin
        base_addra = 11'd1068;
        wea = 1'b1;
        port_A_score = output_score_89;
        port_A_id = 7'd89;
    end
    else if (id_89 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd89) || writing_b_id == 7'd89)) begin
        base_addrb = 11'd1068;
        web = 1'b1;
        port_B_score = output_score_89;
        port_B_id = 7'd89;
    end
    else if (id_90 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd90) || writing_a_id == 7'd90)) begin
        base_addra = 11'd1080;
        wea = 1'b1;
        port_A_score = output_score_90;
        port_A_id = 7'd90;
    end
    else if (id_90 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd90) || writing_b_id == 7'd90)) begin
        base_addrb = 11'd1080;
        web = 1'b1;
        port_B_score = output_score_90;
        port_B_id = 7'd90;
    end
    else if (id_91 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd91) || writing_a_id == 7'd91)) begin
        base_addra = 11'd1092;
        wea = 1'b1;
        port_A_score = output_score_91;
        port_A_id = 7'd91;
    end
    else if (id_91 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd91) || writing_b_id == 7'd91)) begin
        base_addrb = 11'd1092;
        web = 1'b1;
        port_B_score = output_score_91;
        port_B_id = 7'd91;
    end
    else if (id_92 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd92) || writing_a_id == 7'd92)) begin
        base_addra = 11'd1104;
        wea = 1'b1;
        port_A_score = output_score_92;
        port_A_id = 7'd92;
    end
    else if (id_92 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd92) || writing_b_id == 7'd92)) begin
        base_addrb = 11'd1104;
        web = 1'b1;
        port_B_score = output_score_92;
        port_B_id = 7'd92;
    end
    else if (id_93 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd93) || writing_a_id == 7'd93)) begin
        base_addra = 11'd1116;
        wea = 1'b1;
        port_A_score = output_score_93;
        port_A_id = 7'd93;
    end
    else if (id_93 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd93) || writing_b_id == 7'd93)) begin
        base_addrb = 11'd1116;
        web = 1'b1;
        port_B_score = output_score_93;
        port_B_id = 7'd93;
    end
    else if (id_94 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd94) || writing_a_id == 7'd94)) begin
        base_addra = 11'd1128;
        wea = 1'b1;
        port_A_score = output_score_94;
        port_A_id = 7'd94;
    end
    else if (id_94 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd94) || writing_b_id == 7'd94)) begin
        base_addrb = 11'd1128;
        web = 1'b1;
        port_B_score = output_score_94;
        port_B_id = 7'd94;
    end
    else if (id_95 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd95) || writing_a_id == 7'd95)) begin
        base_addra = 11'd1140;
        wea = 1'b1;
        port_A_score = output_score_95;
        port_A_id = 7'd95;
    end
    else if (id_95 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd95) || writing_b_id == 7'd95)) begin
        base_addrb = 11'd1140;
        web = 1'b1;
        port_B_score = output_score_95;
        port_B_id = 7'd95;
    end
    else if (id_96 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd96) || writing_a_id == 7'd96)) begin
        base_addra = 11'd1152;
        wea = 1'b1;
        port_A_score = output_score_96;
        port_A_id = 7'd96;
    end
    else if (id_96 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd96) || writing_b_id == 7'd96)) begin
        base_addrb = 11'd1152;
        web = 1'b1;
        port_B_score = output_score_96;
        port_B_id = 7'd96;
    end
    else if (id_97 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd97) || writing_a_id == 7'd97)) begin
        base_addra = 11'd1164;
        wea = 1'b1;
        port_A_score = output_score_97;
        port_A_id = 7'd97;
    end
    else if (id_97 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd97) || writing_b_id == 7'd97)) begin
        base_addrb = 11'd1164;
        web = 1'b1;
        port_B_score = output_score_97;
        port_B_id = 7'd97;
    end
    else if (id_98 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd98) || writing_a_id == 7'd98)) begin
        base_addra = 11'd1176;
        wea = 1'b1;
        port_A_score = output_score_98;
        port_A_id = 7'd98;
    end
    else if (id_98 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd98) || writing_b_id == 7'd98)) begin
        base_addrb = 11'd1176;
        web = 1'b1;
        port_B_score = output_score_98;
        port_B_id = 7'd98;
    end
    else if (id_99 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd99) || writing_a_id == 7'd99)) begin
        base_addra = 11'd1188;
        wea = 1'b1;
        port_A_score = output_score_99;
        port_A_id = 7'd99;
    end
    else if (id_99 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd99) || writing_b_id == 7'd99)) begin
        base_addrb = 11'd1188;
        web = 1'b1;
        port_B_score = output_score_99;
        port_B_id = 7'd99;
    end
    // else if (id_temp_0 && port_A_cnt == 4'd0) begin
    //     if (id_temp_0_score > worst_score) begin
    //        base_addra = worst_id * 11'd12;
    //        wea = 1'b1;
    //        port_A_score = id_temp_0_score;
    //        port_A_id = worst_id; 
    //     end
    // end
    // else if (id_temp_0 && port_B_cnt == 4'd0) begin
    //     if (id_temp_0_score > worst_score) begin
    //        base_addrb = worst_id * 11'd12;
    //        web = 1'b1;
    //        port_B_score = id_temp_0_score;
    //        port_B_id = worst_id; 
    //     end
    // end
    else begin
        wea = 1'b0;
        web = 1'b0;
        base_addra = 1'b0;
        base_addrb = 1'b0;
        port_A_score = 1'b0;
        port_B_score = 1'b0;
        port_A_id = 1'b0;
        port_B_id = 1'b0;
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        writing_a_id <= 7'd100;
    end
    else begin
        // if (id_0 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd0) || writing_a_id == 7'd0)) begin
        //     writing_a_id <= 7'd0;
        // end
        // else if (id_1 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd1) || writing_a_id == 7'd1)) begin
        //     writing_a_id <= 7'd1;
        // end
        // else if (id_2 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd2) || writing_a_id == 7'd2)) begin
        //     writing_a_id <= 7'd2;
        // end
        // else if (id_3 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd3) || writing_a_id == 7'd3)) begin
        //     writing_a_id <= 7'd3;
        // end
        // else if (id_4 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd4) || writing_a_id == 7'd4)) begin
        //     writing_a_id <= 7'd4;
        // end
        // else if (id_5 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd5) || writing_a_id == 7'd5)) begin
        //     writing_a_id <= 7'd5;
        // end
        // else if (id_6 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd6) || writing_a_id == 7'd6)) begin
        //     writing_a_id <= 7'd6;
        // end
        // else if (id_7 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd7) || writing_a_id == 7'd7)) begin
        //     writing_a_id <= 7'd7;
        // end
        // else if (id_8 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd8) || writing_a_id == 7'd8)) begin
        //     writing_a_id <= 7'd8;
        // end
        // else if (id_9 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd9) || writing_a_id == 7'd9)) begin
        //     writing_a_id <= 7'd9;
        // end
        // else if (id_10 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd10) || writing_a_id == 7'd10)) begin
        //     writing_a_id <= 7'd10;
        // end
        // else if (id_11 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd11) || writing_a_id == 7'd11)) begin
        //     writing_a_id <= 7'd11;
        // end
        // else if (id_12 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd12) || writing_a_id == 7'd12)) begin
        //     writing_a_id <= 7'd12;
        // end
        // else if (id_13 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd13) || writing_a_id == 7'd13)) begin
        //     writing_a_id <= 7'd13;
        // end
        // else if (id_14 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd14) || writing_a_id == 7'd14)) begin
        //     writing_a_id <= 7'd14;
        // end
        // else if (id_15 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd15) || writing_a_id == 7'd15)) begin
        //     writing_a_id <= 7'd15;
        // end
        // else if (id_16 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd16) || writing_a_id == 7'd16)) begin
        //     writing_a_id <= 7'd16;
        // end
        // else if (id_17 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd17) || writing_a_id == 7'd17)) begin
        //     writing_a_id <= 7'd17;
        // end
        // else if (id_18 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd18) || writing_a_id == 7'd18)) begin
        //     writing_a_id <= 7'd18;
        // end
        // else if (id_19 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd19) || writing_a_id == 7'd19)) begin
        //     writing_a_id <= 7'd19;
        // end
        // else if (id_20 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd20) || writing_a_id == 7'd20)) begin
        //     writing_a_id <= 7'd20;
        // end
        // else if (id_21 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd21) || writing_a_id == 7'd21)) begin
        //     writing_a_id <= 7'd21;
        // end
        // else if (id_22 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd22) || writing_a_id == 7'd22)) begin
        //     writing_a_id <= 7'd22;
        // end
        // else if (id_23 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd23) || writing_a_id == 7'd23)) begin
        //     writing_a_id <= 7'd23;
        // end
        // else if (id_24 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd24) || writing_a_id == 7'd24)) begin
        //     writing_a_id <= 7'd24;
        // end
        // else if (id_25 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd25) || writing_a_id == 7'd25)) begin
        //     writing_a_id <= 7'd25;
        // end
        // else if (id_26 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd26) || writing_a_id == 7'd26)) begin
        //     writing_a_id <= 7'd26;
        // end
        // else if (id_27 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd27) || writing_a_id == 7'd27)) begin
        //     writing_a_id <= 7'd27;
        // end
        // else if (id_28 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd28) || writing_a_id == 7'd28)) begin
        //     writing_a_id <= 7'd28;
        // end
        // else if (id_29 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd29) || writing_a_id == 7'd29)) begin
        //     writing_a_id <= 7'd29;
        // end
        // else if (id_30 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd30) || writing_a_id == 7'd30)) begin
        //     writing_a_id <= 7'd30;
        // end
        // else if (id_31 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd31) || writing_a_id == 7'd31)) begin
        //     writing_a_id <= 7'd31;
        // end
        // else if (id_32 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd32) || writing_a_id == 7'd32)) begin
        //     writing_a_id <= 7'd32;
        // end
        // else if (id_33 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd33) || writing_a_id == 7'd33)) begin
        //     writing_a_id <= 7'd33;
        // end
        // else if (id_34 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd34) || writing_a_id == 7'd34)) begin
        //     writing_a_id <= 7'd34;
        // end
        // else if (id_35 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd35) || writing_a_id == 7'd35)) begin
        //     writing_a_id <= 7'd35;
        // end
        // else if (id_36 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd36) || writing_a_id == 7'd36)) begin
        //     writing_a_id <= 7'd36;
        // end
        // else if (id_37 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd37) || writing_a_id == 7'd37)) begin
        //     writing_a_id <= 7'd37;
        // end
        // else if (id_38 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd38) || writing_a_id == 7'd38)) begin
        //     writing_a_id <= 7'd38;
        // end
        // else if (id_39 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd39) || writing_a_id == 7'd39)) begin
        //     writing_a_id <= 7'd39;
        // end
        // else if (id_40 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd40) || writing_a_id == 7'd40)) begin
        //     writing_a_id <= 7'd40;
        // end
        // else if (id_41 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd41) || writing_a_id == 7'd41)) begin
        //     writing_a_id <= 7'd41;
        // end
        // else if (id_42 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd42) || writing_a_id == 7'd42)) begin
        //     writing_a_id <= 7'd42;
        // end
        // else if (id_43 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd43) || writing_a_id == 7'd43)) begin
        //     writing_a_id <= 7'd43;
        // end
        // else if (id_44 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd44) || writing_a_id == 7'd44)) begin
        //     writing_a_id <= 7'd44;
        // end
        // else if (id_45 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd45) || writing_a_id == 7'd45)) begin
        //     writing_a_id <= 7'd45;
        // end
        // else if (id_46 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd46) || writing_a_id == 7'd46)) begin
        //     writing_a_id <= 7'd46;
        // end
        // else if (id_47 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd47) || writing_a_id == 7'd47)) begin
        //     writing_a_id <= 7'd47;
        // end
        // else if (id_48 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd48) || writing_a_id == 7'd48)) begin
        //     writing_a_id <= 7'd48;
        // end
        // else if (id_49 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd49) || writing_a_id == 7'd49)) begin
        //     writing_a_id <= 7'd49;
        // end
        // else if (id_50 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd50) || writing_a_id == 7'd50)) begin
        //     writing_a_id <= 7'd50;
        // end
        // else if (id_51 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd51) || writing_a_id == 7'd51)) begin
        //     writing_a_id <= 7'd51;
        // end
        // else if (id_52 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd52) || writing_a_id == 7'd52)) begin
        //     writing_a_id <= 7'd52;
        // end
        // else if (id_53 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd53) || writing_a_id == 7'd53)) begin
        //     writing_a_id <= 7'd53;
        // end
        // else if (id_54 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd54) || writing_a_id == 7'd54)) begin
        //     writing_a_id <= 7'd54;
        // end
        // else if (id_55 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd55) || writing_a_id == 7'd55)) begin
        //     writing_a_id <= 7'd55;
        // end
        // else if (id_56 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd56) || writing_a_id == 7'd56)) begin
        //     writing_a_id <= 7'd56;
        // end
        // else if (id_57 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd57) || writing_a_id == 7'd57)) begin
        //     writing_a_id <= 7'd57;
        // end
        // else if (id_58 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd58) || writing_a_id == 7'd58)) begin
        //     writing_a_id <= 7'd58;
        // end
        // else if (id_59 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd59) || writing_a_id == 7'd59)) begin
        //     writing_a_id <= 7'd59;
        // end
        // else if (id_60 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd60) || writing_a_id == 7'd60)) begin
        //     writing_a_id <= 7'd60;
        // end
        // else if (id_61 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd61) || writing_a_id == 7'd61)) begin
        //     writing_a_id <= 7'd61;
        // end
        // else if (id_62 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd62) || writing_a_id == 7'd62)) begin
        //     writing_a_id <= 7'd62;
        // end
        // else if (id_63 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd63) || writing_a_id == 7'd63)) begin
        //     writing_a_id <= 7'd63;
        // end
        // else if (id_64 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd64) || writing_a_id == 7'd64)) begin
        //     writing_a_id <= 7'd64;
        // end
        // else if (id_65 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd65) || writing_a_id == 7'd65)) begin
        //     writing_a_id <= 7'd65;
        // end
        // else if (id_66 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd66) || writing_a_id == 7'd66)) begin
        //     writing_a_id <= 7'd66;
        // end
        // else if (id_67 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd67) || writing_a_id == 7'd67)) begin
        //     writing_a_id <= 7'd67;
        // end
        // else if (id_68 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd68) || writing_a_id == 7'd68)) begin
        //     writing_a_id <= 7'd68;
        // end
        // else if (id_69 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd69) || writing_a_id == 7'd69)) begin
        //     writing_a_id <= 7'd69;
        // end
        // else if (id_70 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd70) || writing_a_id == 7'd70)) begin
        //     writing_a_id <= 7'd70;
        // end
        // else if (id_71 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd71) || writing_a_id == 7'd71)) begin
        //     writing_a_id <= 7'd71;
        // end
        // else if (id_72 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd72) || writing_a_id == 7'd72)) begin
        //     writing_a_id <= 7'd72;
        // end
        // else if (id_73 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd73) || writing_a_id == 7'd73)) begin
        //     writing_a_id <= 7'd73;
        // end
        // else if (id_74 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd74) || writing_a_id == 7'd74)) begin
        //     writing_a_id <= 7'd74;
        // end
        // else if (id_75 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd75) || writing_a_id == 7'd75)) begin
        //     writing_a_id <= 7'd75;
        // end
        // else if (id_76 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd76) || writing_a_id == 7'd76)) begin
        //     writing_a_id <= 7'd76;
        // end
        // else if (id_77 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd77) || writing_a_id == 7'd77)) begin
        //     writing_a_id <= 7'd77;
        // end
        // else if (id_78 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd78) || writing_a_id == 7'd78)) begin
        //     writing_a_id <= 7'd78;
        // end
        // else if (id_79 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd79) || writing_a_id == 7'd79)) begin
        //     writing_a_id <= 7'd79;
        // end
        // else if (id_80 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd80) || writing_a_id == 7'd80)) begin
        //     writing_a_id <= 7'd80;
        // end
        // else if (id_81 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd81) || writing_a_id == 7'd81)) begin
        //     writing_a_id <= 7'd81;
        // end
        // else if (id_82 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd82) || writing_a_id == 7'd82)) begin
        //     writing_a_id <= 7'd82;
        // end
        // else if (id_83 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd83) || writing_a_id == 7'd83)) begin
        //     writing_a_id <= 7'd83;
        // end
        // else if (id_84 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd84) || writing_a_id == 7'd84)) begin
        //     writing_a_id <= 7'd84;
        // end
        // else if (id_85 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd85) || writing_a_id == 7'd85)) begin
        //     writing_a_id <= 7'd85;
        // end
        // else if (id_86 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd86) || writing_a_id == 7'd86)) begin
        //     writing_a_id <= 7'd86;
        // end
        // else if (id_87 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd87) || writing_a_id == 7'd87)) begin
        //     writing_a_id <= 7'd87;
        // end
        // else if (id_88 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd88) || writing_a_id == 7'd88)) begin
        //     writing_a_id <= 7'd88;
        // end
        // else if (id_89 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd89) || writing_a_id == 7'd89)) begin
        //     writing_a_id <= 7'd89;
        // end
        // else if (id_90 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd90) || writing_a_id == 7'd90)) begin
        //     writing_a_id <= 7'd90;
        // end
        // else if (id_91 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd91) || writing_a_id == 7'd91)) begin
        //     writing_a_id <= 7'd91;
        // end
        // else if (id_92 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd92) || writing_a_id == 7'd92)) begin
        //     writing_a_id <= 7'd92;
        // end
        // else if (id_93 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd93) || writing_a_id == 7'd93)) begin
        //     writing_a_id <= 7'd93;
        // end
        // else if (id_94 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd94) || writing_a_id == 7'd94)) begin
        //     writing_a_id <= 7'd94;
        // end
        // else if (id_95 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd95) || writing_a_id == 7'd95)) begin
        //     writing_a_id <= 7'd95;
        // end
        // else if (id_96 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd96) || writing_a_id == 7'd96)) begin
        //     writing_a_id <= 7'd96;
        // end
        // else if (id_97 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd97) || writing_a_id == 7'd97)) begin
        //     writing_a_id <= 7'd97;
        // end
        // else if (id_98 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd98) || writing_a_id == 7'd98)) begin
        //     writing_a_id <= 7'd98;
        // end
        // else if (id_99 && ((port_A_cnt == 4'd0 && writing_b_id != 7'd99) || writing_a_id == 7'd99)) begin
        //     writing_a_id <= 7'd99;
        // end
        // else if (port_A_cnt == 4'd11) begin
        //     writing_a_id <= 7'd100;
        // end
        // else if (id_temp_0 && (port_A_cnt == 4'd0 && writing_b_id != wor) begin
        //     writing_a_id <= worst_id;
        // end
        // else if (id_temp_0 && port_B_cnt == 4'd0) begin
        //     writing_b_id <= worst_id;
        // end
        // else if (port_A_cnt == 4'd11) begin
        //     writing_a_id <= 7'd100;
        // end
        if(wea) begin
            writing_a_id <= port_A_id;
        end
        else if (port_A_cnt == 4'd11) begin
            writing_a_id <= 7'd100;
        end
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        writing_b_id <= 7'd100;
    end
    else begin
        // if (id_0 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd0) || writing_b_id == 7'd0)) begin
        //     writing_b_id <= 7'd0;
        // end
        // else if (id_1 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd1) || writing_b_id == 7'd1)) begin
        //     writing_b_id <= 7'd1;
        // end
        // else if (id_2 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd2) || writing_b_id == 7'd2)) begin
        //     writing_b_id <= 7'd2;
        // end
        // else if (id_3 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd3) || writing_b_id == 7'd3)) begin
        //     writing_b_id <= 7'd3;
        // end
        // else if (id_4 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd4) || writing_b_id == 7'd4)) begin
        //     writing_b_id <= 7'd4;
        // end
        // else if (id_5 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd5) || writing_b_id == 7'd5)) begin
        //     writing_b_id <= 7'd5;
        // end
        // else if (id_6 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd6) || writing_b_id == 7'd6)) begin
        //     writing_b_id <= 7'd6;
        // end
        // else if (id_7 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd7) || writing_b_id == 7'd7)) begin
        //     writing_b_id <= 7'd7;
        // end
        // else if (id_8 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd8) || writing_b_id == 7'd8)) begin
        //     writing_b_id <= 7'd8;
        // end
        // else if (id_9 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd9) || writing_b_id == 7'd9)) begin
        //     writing_b_id <= 7'd9;
        // end
        // else if (id_10 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd10) || writing_b_id == 7'd10)) begin
        //     writing_b_id <= 7'd10;
        // end
        // else if (id_11 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd11) || writing_b_id == 7'd11)) begin
        //     writing_b_id <= 7'd11;
        // end
        // else if (id_12 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd12) || writing_b_id == 7'd12)) begin
        //     writing_b_id <= 7'd12;
        // end
        // else if (id_13 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd13) || writing_b_id == 7'd13)) begin
        //     writing_b_id <= 7'd13;
        // end
        // else if (id_14 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd14) || writing_b_id == 7'd14)) begin
        //     writing_b_id <= 7'd14;
        // end
        // else if (id_15 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd15) || writing_b_id == 7'd15)) begin
        //     writing_b_id <= 7'd15;
        // end
        // else if (id_16 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd16) || writing_b_id == 7'd16)) begin
        //     writing_b_id <= 7'd16;
        // end
        // else if (id_17 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd17) || writing_b_id == 7'd17)) begin
        //     writing_b_id <= 7'd17;
        // end
        // else if (id_18 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd18) || writing_b_id == 7'd18)) begin
        //     writing_b_id <= 7'd18;
        // end
        // else if (id_19 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd19) || writing_b_id == 7'd19)) begin
        //     writing_b_id <= 7'd19;
        // end
        // else if (id_20 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd20) || writing_b_id == 7'd20)) begin
        //     writing_b_id <= 7'd20;
        // end
        // else if (id_21 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd21) || writing_b_id == 7'd21)) begin
        //     writing_b_id <= 7'd21;
        // end
        // else if (id_22 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd22) || writing_b_id == 7'd22)) begin
        //     writing_b_id <= 7'd22;
        // end
        // else if (id_23 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd23) || writing_b_id == 7'd23)) begin
        //     writing_b_id <= 7'd23;
        // end
        // else if (id_24 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd24) || writing_b_id == 7'd24)) begin
        //     writing_b_id <= 7'd24;
        // end
        // else if (id_25 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd25) || writing_b_id == 7'd25)) begin
        //     writing_b_id <= 7'd25;
        // end
        // else if (id_26 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd26) || writing_b_id == 7'd26)) begin
        //     writing_b_id <= 7'd26;
        // end
        // else if (id_27 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd27) || writing_b_id == 7'd27)) begin
        //     writing_b_id <= 7'd27;
        // end
        // else if (id_28 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd28) || writing_b_id == 7'd28)) begin
        //     writing_b_id <= 7'd28;
        // end
        // else if (id_29 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd29) || writing_b_id == 7'd29)) begin
        //     writing_b_id <= 7'd29;
        // end
        // else if (id_30 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd30) || writing_b_id == 7'd30)) begin
        //     writing_b_id <= 7'd30;
        // end
        // else if (id_31 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd31) || writing_b_id == 7'd31)) begin
        //     writing_b_id <= 7'd31;
        // end
        // else if (id_32 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd32) || writing_b_id == 7'd32)) begin
        //     writing_b_id <= 7'd32;
        // end
        // else if (id_33 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd33) || writing_b_id == 7'd33)) begin
        //     writing_b_id <= 7'd33;
        // end
        // else if (id_34 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd34) || writing_b_id == 7'd34)) begin
        //     writing_b_id <= 7'd34;
        // end
        // else if (id_35 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd35) || writing_b_id == 7'd35)) begin
        //     writing_b_id <= 7'd35;
        // end
        // else if (id_36 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd36) || writing_b_id == 7'd36)) begin
        //     writing_b_id <= 7'd36;
        // end
        // else if (id_37 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd37) || writing_b_id == 7'd37)) begin
        //     writing_b_id <= 7'd37;
        // end
        // else if (id_38 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd38) || writing_b_id == 7'd38)) begin
        //     writing_b_id <= 7'd38;
        // end
        // else if (id_39 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd39) || writing_b_id == 7'd39)) begin
        //     writing_b_id <= 7'd39;
        // end
        // else if (id_40 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd40) || writing_b_id == 7'd40)) begin
        //     writing_b_id <= 7'd40;
        // end
        // else if (id_41 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd41) || writing_b_id == 7'd41)) begin
        //     writing_b_id <= 7'd41;
        // end
        // else if (id_42 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd42) || writing_b_id == 7'd42)) begin
        //     writing_b_id <= 7'd42;
        // end
        // else if (id_43 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd43) || writing_b_id == 7'd43)) begin
        //     writing_b_id <= 7'd43;
        // end
        // else if (id_44 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd44) || writing_b_id == 7'd44)) begin
        //     writing_b_id <= 7'd44;
        // end
        // else if (id_45 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd45) || writing_b_id == 7'd45)) begin
        //     writing_b_id <= 7'd45;
        // end
        // else if (id_46 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd46) || writing_b_id == 7'd46)) begin
        //     writing_b_id <= 7'd46;
        // end
        // else if (id_47 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd47) || writing_b_id == 7'd47)) begin
        //     writing_b_id <= 7'd47;
        // end
        // else if (id_48 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd48) || writing_b_id == 7'd48)) begin
        //     writing_b_id <= 7'd48;
        // end
        // else if (id_49 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd49) || writing_b_id == 7'd49)) begin
        //     writing_b_id <= 7'd49;
        // end
        // else if (id_50 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd50) || writing_b_id == 7'd50)) begin
        //     writing_b_id <= 7'd50;
        // end
        // else if (id_51 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd51) || writing_b_id == 7'd51)) begin
        //     writing_b_id <= 7'd51;
        // end
        // else if (id_52 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd52) || writing_b_id == 7'd52)) begin
        //     writing_b_id <= 7'd52;
        // end
        // else if (id_53 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd53) || writing_b_id == 7'd53)) begin
        //     writing_b_id <= 7'd53;
        // end
        // else if (id_54 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd54) || writing_b_id == 7'd54)) begin
        //     writing_b_id <= 7'd54;
        // end
        // else if (id_55 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd55) || writing_b_id == 7'd55)) begin
        //     writing_b_id <= 7'd55;
        // end
        // else if (id_56 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd56) || writing_b_id == 7'd56)) begin
        //     writing_b_id <= 7'd56;
        // end
        // else if (id_57 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd57) || writing_b_id == 7'd57)) begin
        //     writing_b_id <= 7'd57;
        // end
        // else if (id_58 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd58) || writing_b_id == 7'd58)) begin
        //     writing_b_id <= 7'd58;
        // end
        // else if (id_59 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd59) || writing_b_id == 7'd59)) begin
        //     writing_b_id <= 7'd59;
        // end
        // else if (id_60 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd60) || writing_b_id == 7'd60)) begin
        //     writing_b_id <= 7'd60;
        // end
        // else if (id_61 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd61) || writing_b_id == 7'd61)) begin
        //     writing_b_id <= 7'd61;
        // end
        // else if (id_62 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd62) || writing_b_id == 7'd62)) begin
        //     writing_b_id <= 7'd62;
        // end
        // else if (id_63 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd63) || writing_b_id == 7'd63)) begin
        //     writing_b_id <= 7'd63;
        // end
        // else if (id_64 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd64) || writing_b_id == 7'd64)) begin
        //     writing_b_id <= 7'd64;
        // end
        // else if (id_65 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd65) || writing_b_id == 7'd65)) begin
        //     writing_b_id <= 7'd65;
        // end
        // else if (id_66 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd66) || writing_b_id == 7'd66)) begin
        //     writing_b_id <= 7'd66;
        // end
        // else if (id_67 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd67) || writing_b_id == 7'd67)) begin
        //     writing_b_id <= 7'd67;
        // end
        // else if (id_68 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd68) || writing_b_id == 7'd68)) begin
        //     writing_b_id <= 7'd68;
        // end
        // else if (id_69 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd69) || writing_b_id == 7'd69)) begin
        //     writing_b_id <= 7'd69;
        // end
        // else if (id_70 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd70) || writing_b_id == 7'd70)) begin
        //     writing_b_id <= 7'd70;
        // end
        // else if (id_71 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd71) || writing_b_id == 7'd71)) begin
        //     writing_b_id <= 7'd71;
        // end
        // else if (id_72 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd72) || writing_b_id == 7'd72)) begin
        //     writing_b_id <= 7'd72;
        // end
        // else if (id_73 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd73) || writing_b_id == 7'd73)) begin
        //     writing_b_id <= 7'd73;
        // end
        // else if (id_74 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd74) || writing_b_id == 7'd74)) begin
        //     writing_b_id <= 7'd74;
        // end
        // else if (id_75 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd75) || writing_b_id == 7'd75)) begin
        //     writing_b_id <= 7'd75;
        // end
        // else if (id_76 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd76) || writing_b_id == 7'd76)) begin
        //     writing_b_id <= 7'd76;
        // end
        // else if (id_77 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd77) || writing_b_id == 7'd77)) begin
        //     writing_b_id <= 7'd77;
        // end
        // else if (id_78 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd78) || writing_b_id == 7'd78)) begin
        //     writing_b_id <= 7'd78;
        // end
        // else if (id_79 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd79) || writing_b_id == 7'd79)) begin
        //     writing_b_id <= 7'd79;
        // end
        // else if (id_80 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd80) || writing_b_id == 7'd80)) begin
        //     writing_b_id <= 7'd80;
        // end
        // else if (id_81 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd81) || writing_b_id == 7'd81)) begin
        //     writing_b_id <= 7'd81;
        // end
        // else if (id_82 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd82) || writing_b_id == 7'd82)) begin
        //     writing_b_id <= 7'd82;
        // end
        // else if (id_83 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd83) || writing_b_id == 7'd83)) begin
        //     writing_b_id <= 7'd83;
        // end
        // else if (id_84 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd84) || writing_b_id == 7'd84)) begin
        //     writing_b_id <= 7'd84;
        // end
        // else if (id_85 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd85) || writing_b_id == 7'd85)) begin
        //     writing_b_id <= 7'd85;
        // end
        // else if (id_86 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd86) || writing_b_id == 7'd86)) begin
        //     writing_b_id <= 7'd86;
        // end
        // else if (id_87 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd87) || writing_b_id == 7'd87)) begin
        //     writing_b_id <= 7'd87;
        // end
        // else if (id_88 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd88) || writing_b_id == 7'd88)) begin
        //     writing_b_id <= 7'd88;
        // end
        // else if (id_89 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd89) || writing_b_id == 7'd89)) begin
        //     writing_b_id <= 7'd89;
        // end
        // else if (id_90 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd90) || writing_b_id == 7'd90)) begin
        //     writing_b_id <= 7'd90;
        // end
        // else if (id_91 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd91) || writing_b_id == 7'd91)) begin
        //     writing_b_id <= 7'd91;
        // end
        // else if (id_92 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd92) || writing_b_id == 7'd92)) begin
        //     writing_b_id <= 7'd92;
        // end
        // else if (id_93 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd93) || writing_b_id == 7'd93)) begin
        //     writing_b_id <= 7'd93;
        // end
        // else if (id_94 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd94) || writing_b_id == 7'd94)) begin
        //     writing_b_id <= 7'd94;
        // end
        // else if (id_95 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd95) || writing_b_id == 7'd95)) begin
        //     writing_b_id <= 7'd95;
        // end
        // else if (id_96 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd96) || writing_b_id == 7'd96)) begin
        //     writing_b_id <= 7'd96;
        // end
        // else if (id_97 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd97) || writing_b_id == 7'd97)) begin
        //     writing_b_id <= 7'd97;
        // end
        // else if (id_98 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd98) || writing_b_id == 7'd98)) begin
        //     writing_b_id <= 7'd98;
        // end
        // else if (id_99 && ((port_B_cnt == 4'd0 && writing_a_id != 7'd99) || writing_b_id == 7'd99)) begin
        //     writing_b_id <= 7'd99;
        // end
        if(web) begin
            writing_b_id <= port_B_id;
        end
        else if (port_B_cnt == 4'd11) begin
            writing_b_id <= 7'd100;
        end
    end
end

minimum find_minimum_inst(
    .com_0({P_ID_0, output_score_0}),
    .com_1({P_ID_1, output_score_1}),
    .com_2({P_ID_2, output_score_2}),
    .com_3({P_ID_3, output_score_3}),
    .com_4({P_ID_4, output_score_4}),
    .com_5({P_ID_5, output_score_5}),
    .com_6({P_ID_6, output_score_6}),
    .com_7({P_ID_7, output_score_7}),
    .com_8({P_ID_8, output_score_8}),
    .com_9({P_ID_9, output_score_9}),
    .com_10({P_ID_10, output_score_10}),
    .com_11({P_ID_11, output_score_11}),
    .com_12({P_ID_12, output_score_12}),
    .com_13({P_ID_13, output_score_13}),
    .com_14({P_ID_14, output_score_14}),
    .com_15({P_ID_15, output_score_15}),
    .com_16({P_ID_16, output_score_16}),
    .com_17({P_ID_17, output_score_17}),
    .com_18({P_ID_18, output_score_18}),
    .com_19({P_ID_19, output_score_19}),
    .com_20({P_ID_20, output_score_20}),
    .com_21({P_ID_21, output_score_21}),
    .com_22({P_ID_22, output_score_22}),
    .com_23({P_ID_23, output_score_23}),
    .com_24({P_ID_24, output_score_24}),
    .com_25({P_ID_25, output_score_25}),
    .com_26({P_ID_26, output_score_26}),
    .com_27({P_ID_27, output_score_27}),
    .com_28({P_ID_28, output_score_28}),
    .com_29({P_ID_29, output_score_29}),
    .com_30({P_ID_30, output_score_30}),
    .com_31({P_ID_31, output_score_31}),
    .com_32({P_ID_32, output_score_32}),
    .com_33({P_ID_33, output_score_33}),
    .com_34({P_ID_34, output_score_34}),
    .com_35({P_ID_35, output_score_35}),
    .com_36({P_ID_36, output_score_36}),
    .com_37({P_ID_37, output_score_37}),
    .com_38({P_ID_38, output_score_38}),
    .com_39({P_ID_39, output_score_39}),
    .com_40({P_ID_40, output_score_40}),
    .com_41({P_ID_41, output_score_41}),
    .com_42({P_ID_42, output_score_42}),
    .com_43({P_ID_43, output_score_43}),
    .com_44({P_ID_44, output_score_44}),
    .com_45({P_ID_45, output_score_45}),
    .com_46({P_ID_46, output_score_46}),
    .com_47({P_ID_47, output_score_47}),
    .com_48({P_ID_48, output_score_48}),
    .com_49({P_ID_49, output_score_49}),
    .com_50({P_ID_50, output_score_50}),
    .com_51({P_ID_51, output_score_51}),
    .com_52({P_ID_52, output_score_52}),
    .com_53({P_ID_53, output_score_53}),
    .com_54({P_ID_54, output_score_54}),
    .com_55({P_ID_55, output_score_55}),
    .com_56({P_ID_56, output_score_56}),
    .com_57({P_ID_57, output_score_57}),
    .com_58({P_ID_58, output_score_58}),
    .com_59({P_ID_59, output_score_59}),
    .com_60({P_ID_60, output_score_60}),
    .com_61({P_ID_61, output_score_61}),
    .com_62({P_ID_62, output_score_62}),
    .com_63({P_ID_63, output_score_63}),
    .com_64({P_ID_64, output_score_64}),
    .com_65({P_ID_65, output_score_65}),
    .com_66({P_ID_66, output_score_66}),
    .com_67({P_ID_67, output_score_67}),
    .com_68({P_ID_68, output_score_68}),
    .com_69({P_ID_69, output_score_69}),
    .com_70({P_ID_70, output_score_70}),
    .com_71({P_ID_71, output_score_71}),
    .com_72({P_ID_72, output_score_72}),
    .com_73({P_ID_73, output_score_73}),
    .com_74({P_ID_74, output_score_74}),
    .com_75({P_ID_75, output_score_75}),
    .com_76({P_ID_76, output_score_76}),
    .com_77({P_ID_77, output_score_77}),
    .com_78({P_ID_78, output_score_78}),
    .com_79({P_ID_79, output_score_79}),
    .com_80({P_ID_80, output_score_80}),
    .com_81({P_ID_81, output_score_81}),
    .com_82({P_ID_82, output_score_82}),
    .com_83({P_ID_83, output_score_83}),
    .com_84({P_ID_84, output_score_84}),
    .com_85({P_ID_85, output_score_85}),
    .com_86({P_ID_86, output_score_86}),
    .com_87({P_ID_87, output_score_87}),
    .com_88({P_ID_88, output_score_88}),
    .com_89({P_ID_89, output_score_89}),
    .com_90({P_ID_90, output_score_90}),
    .com_91({P_ID_91, output_score_91}),
    .com_92({P_ID_92, output_score_92}),
    .com_93({P_ID_93, output_score_93}),
    .com_94({P_ID_94, output_score_94}),
    .com_95({P_ID_95, output_score_95}),
    .com_96({P_ID_96, output_score_96}),
    .com_97({P_ID_97, output_score_97}),
    .com_98({P_ID_98, output_score_98}),
    .com_99({P_ID_99, output_score_99}),
    .min(min_patch)
    );

new_patch #(0) new_patch_inst_0(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(1'b1),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_1),
    .wr_en(id_0),
    .output_score(output_score_0),
    .ID(P_ID_0),
    .renew_id(renew_id)
);
new_patch #(1) new_patch_inst_1(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_1),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_2),
    .wr_en(id_1),
    .output_score(output_score_1),
    .ID(P_ID_1),
    .renew_id(renew_id)
);
new_patch #(2) new_patch_inst_2(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_2),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_3),
    .wr_en(id_2),
    .output_score(output_score_2),
    .ID(P_ID_2),
    .renew_id(renew_id)
);
new_patch #(3) new_patch_inst_3(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_3),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_4),
    .wr_en(id_3),
    .output_score(output_score_3),
    .ID(P_ID_3),
    .renew_id(renew_id)
);
new_patch #(4) new_patch_inst_4(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_4),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_5),
    .wr_en(id_4),
    .output_score(output_score_4),
    .ID(P_ID_4),
    .renew_id(renew_id)
);
new_patch #(5) new_patch_inst_5(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_5),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_6),
    .wr_en(id_5),
    .output_score(output_score_5),
    .ID(P_ID_5),
    .renew_id(renew_id)
);
new_patch #(6) new_patch_inst_6(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_6),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_7),
    .wr_en(id_6),
    .output_score(output_score_6),
    .ID(P_ID_6),
    .renew_id(renew_id)
);
new_patch #(7) new_patch_inst_7(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_7),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_8),
    .wr_en(id_7),
    .output_score(output_score_7),
    .ID(P_ID_7),
    .renew_id(renew_id)
);
new_patch #(8) new_patch_inst_8(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_8),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_9),
    .wr_en(id_8),
    .output_score(output_score_8),
    .ID(P_ID_8),
    .renew_id(renew_id)
);
new_patch #(9) new_patch_inst_9(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_9),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_10),
    .wr_en(id_9),
    .output_score(output_score_9),
    .ID(P_ID_9),
    .renew_id(renew_id)
);
new_patch #(10) new_patch_inst_10(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_10),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_11),
    .wr_en(id_10),
    .output_score(output_score_10),
    .ID(P_ID_10),
    .renew_id(renew_id)
);
new_patch #(11) new_patch_inst_11(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_11),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_12),
    .wr_en(id_11),
    .output_score(output_score_11),
    .ID(P_ID_11),
    .renew_id(renew_id)
);
new_patch #(12) new_patch_inst_12(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_12),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_13),
    .wr_en(id_12),
    .output_score(output_score_12),
    .ID(P_ID_12),
    .renew_id(renew_id)
);
new_patch #(13) new_patch_inst_13(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_13),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_14),
    .wr_en(id_13),
    .output_score(output_score_13),
    .ID(P_ID_13),
    .renew_id(renew_id)
);
new_patch #(14) new_patch_inst_14(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_14),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_15),
    .wr_en(id_14),
    .output_score(output_score_14),
    .ID(P_ID_14),
    .renew_id(renew_id)
);
new_patch #(15) new_patch_inst_15(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_15),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_16),
    .wr_en(id_15),
    .output_score(output_score_15),
    .ID(P_ID_15),
    .renew_id(renew_id)
);
new_patch #(16) new_patch_inst_16(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_16),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_17),
    .wr_en(id_16),
    .output_score(output_score_16),
    .ID(P_ID_16),
    .renew_id(renew_id)
);
new_patch #(17) new_patch_inst_17(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_17),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_18),
    .wr_en(id_17),
    .output_score(output_score_17),
    .ID(P_ID_17),
    .renew_id(renew_id)
);
new_patch #(18) new_patch_inst_18(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_18),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_19),
    .wr_en(id_18),
    .output_score(output_score_18),
    .ID(P_ID_18),
    .renew_id(renew_id)
);
new_patch #(19) new_patch_inst_19(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_19),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_20),
    .wr_en(id_19),
    .output_score(output_score_19),
    .ID(P_ID_19),
    .renew_id(renew_id)
);
new_patch #(20) new_patch_inst_20(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_20),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_21),
    .wr_en(id_20),
    .output_score(output_score_20),
    .ID(P_ID_20),
    .renew_id(renew_id)
);
new_patch #(21) new_patch_inst_21(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_21),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_22),
    .wr_en(id_21),
    .output_score(output_score_21),
    .ID(P_ID_21),
    .renew_id(renew_id)
);
new_patch #(22) new_patch_inst_22(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_22),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_23),
    .wr_en(id_22),
    .output_score(output_score_22),
    .ID(P_ID_22),
    .renew_id(renew_id)
);
new_patch #(23) new_patch_inst_23(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_23),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_24),
    .wr_en(id_23),
    .output_score(output_score_23),
    .ID(P_ID_23),
    .renew_id(renew_id)
);
new_patch #(24) new_patch_inst_24(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_24),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_25),
    .wr_en(id_24),
    .output_score(output_score_24),
    .ID(P_ID_24),
    .renew_id(renew_id)
);
new_patch #(25) new_patch_inst_25(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_25),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_26),
    .wr_en(id_25),
    .output_score(output_score_25),
    .ID(P_ID_25),
    .renew_id(renew_id)
);
new_patch #(26) new_patch_inst_26(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_26),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_27),
    .wr_en(id_26),
    .output_score(output_score_26),
    .ID(P_ID_26),
    .renew_id(renew_id)
);
new_patch #(27) new_patch_inst_27(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_27),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_28),
    .wr_en(id_27),
    .output_score(output_score_27),
    .ID(P_ID_27),
    .renew_id(renew_id)
);
new_patch #(28) new_patch_inst_28(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_28),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_29),
    .wr_en(id_28),
    .output_score(output_score_28),
    .ID(P_ID_28),
    .renew_id(renew_id)
);
new_patch #(29) new_patch_inst_29(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_29),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_30),
    .wr_en(id_29),
    .output_score(output_score_29),
    .ID(P_ID_29),
    .renew_id(renew_id)
);
new_patch #(30) new_patch_inst_30(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_30),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_31),
    .wr_en(id_30),
    .output_score(output_score_30),
    .ID(P_ID_30),
    .renew_id(renew_id)
);
new_patch #(31) new_patch_inst_31(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_31),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_32),
    .wr_en(id_31),
    .output_score(output_score_31),
    .ID(P_ID_31),
    .renew_id(renew_id)
);
new_patch #(32) new_patch_inst_32(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_32),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_33),
    .wr_en(id_32),
    .output_score(output_score_32),
    .ID(P_ID_32),
    .renew_id(renew_id)
);
new_patch #(33) new_patch_inst_33(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_33),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_34),
    .wr_en(id_33),
    .output_score(output_score_33),
    .ID(P_ID_33),
    .renew_id(renew_id)
);
new_patch #(34) new_patch_inst_34(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_34),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_35),
    .wr_en(id_34),
    .output_score(output_score_34),
    .ID(P_ID_34),
    .renew_id(renew_id)
);
new_patch #(35) new_patch_inst_35(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_35),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_36),
    .wr_en(id_35),
    .output_score(output_score_35),
    .ID(P_ID_35),
    .renew_id(renew_id)
);
new_patch #(36) new_patch_inst_36(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_36),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_37),
    .wr_en(id_36),
    .output_score(output_score_36),
    .ID(P_ID_36),
    .renew_id(renew_id)
);
new_patch #(37) new_patch_inst_37(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_37),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_38),
    .wr_en(id_37),
    .output_score(output_score_37),
    .ID(P_ID_37),
    .renew_id(renew_id)
);
new_patch #(38) new_patch_inst_38(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_38),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_39),
    .wr_en(id_38),
    .output_score(output_score_38),
    .ID(P_ID_38),
    .renew_id(renew_id)
);
new_patch #(39) new_patch_inst_39(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_39),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_40),
    .wr_en(id_39),
    .output_score(output_score_39),
    .ID(P_ID_39),
    .renew_id(renew_id)
);
new_patch #(40) new_patch_inst_40(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_40),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_41),
    .wr_en(id_40),
    .output_score(output_score_40),
    .ID(P_ID_40),
    .renew_id(renew_id)
);
new_patch #(41) new_patch_inst_41(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_41),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_42),
    .wr_en(id_41),
    .output_score(output_score_41),
    .ID(P_ID_41),
    .renew_id(renew_id)
);
new_patch #(42) new_patch_inst_42(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_42),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_43),
    .wr_en(id_42),
    .output_score(output_score_42),
    .ID(P_ID_42),
    .renew_id(renew_id)
);
new_patch #(43) new_patch_inst_43(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_43),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_44),
    .wr_en(id_43),
    .output_score(output_score_43),
    .ID(P_ID_43),
    .renew_id(renew_id)
);
new_patch #(44) new_patch_inst_44(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_44),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_45),
    .wr_en(id_44),
    .output_score(output_score_44),
    .ID(P_ID_44),
    .renew_id(renew_id)
);
new_patch #(45) new_patch_inst_45(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_45),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_46),
    .wr_en(id_45),
    .output_score(output_score_45),
    .ID(P_ID_45),
    .renew_id(renew_id)
);
new_patch #(46) new_patch_inst_46(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_46),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_47),
    .wr_en(id_46),
    .output_score(output_score_46),
    .ID(P_ID_46),
    .renew_id(renew_id)
);
new_patch #(47) new_patch_inst_47(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_47),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_48),
    .wr_en(id_47),
    .output_score(output_score_47),
    .ID(P_ID_47),
    .renew_id(renew_id)
);
new_patch #(48) new_patch_inst_48(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_48),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_49),
    .wr_en(id_48),
    .output_score(output_score_48),
    .ID(P_ID_48),
    .renew_id(renew_id)
);
new_patch #(49) new_patch_inst_49(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_49),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_50),
    .wr_en(id_49),
    .output_score(output_score_49),
    .ID(P_ID_49),
    .renew_id(renew_id)
);
new_patch #(50) new_patch_inst_50(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_50),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_51),
    .wr_en(id_50),
    .output_score(output_score_50),
    .ID(P_ID_50),
    .renew_id(renew_id)
);
new_patch #(51) new_patch_inst_51(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_51),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_52),
    .wr_en(id_51),
    .output_score(output_score_51),
    .ID(P_ID_51),
    .renew_id(renew_id)
);
new_patch #(52) new_patch_inst_52(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_52),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_53),
    .wr_en(id_52),
    .output_score(output_score_52),
    .ID(P_ID_52),
    .renew_id(renew_id)
);
new_patch #(53) new_patch_inst_53(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_53),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_54),
    .wr_en(id_53),
    .output_score(output_score_53),
    .ID(P_ID_53),
    .renew_id(renew_id)
);
new_patch #(54) new_patch_inst_54(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_54),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_55),
    .wr_en(id_54),
    .output_score(output_score_54),
    .ID(P_ID_54),
    .renew_id(renew_id)
);
new_patch #(55) new_patch_inst_55(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_55),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_56),
    .wr_en(id_55),
    .output_score(output_score_55),
    .ID(P_ID_55),
    .renew_id(renew_id)
);
new_patch #(56) new_patch_inst_56(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_56),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_57),
    .wr_en(id_56),
    .output_score(output_score_56),
    .ID(P_ID_56),
    .renew_id(renew_id)
);
new_patch #(57) new_patch_inst_57(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_57),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_58),
    .wr_en(id_57),
    .output_score(output_score_57),
    .ID(P_ID_57),
    .renew_id(renew_id)
);
new_patch #(58) new_patch_inst_58(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_58),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_59),
    .wr_en(id_58),
    .output_score(output_score_58),
    .ID(P_ID_58),
    .renew_id(renew_id)
);
new_patch #(59) new_patch_inst_59(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_59),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_60),
    .wr_en(id_59),
    .output_score(output_score_59),
    .ID(P_ID_59),
    .renew_id(renew_id)
);
new_patch #(60) new_patch_inst_60(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_60),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_61),
    .wr_en(id_60),
    .output_score(output_score_60),
    .ID(P_ID_60),
    .renew_id(renew_id)
);
new_patch #(61) new_patch_inst_61(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_61),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_62),
    .wr_en(id_61),
    .output_score(output_score_61),
    .ID(P_ID_61),
    .renew_id(renew_id)
);
new_patch #(62) new_patch_inst_62(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_62),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_63),
    .wr_en(id_62),
    .output_score(output_score_62),
    .ID(P_ID_62),
    .renew_id(renew_id)
);
new_patch #(63) new_patch_inst_63(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_63),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_64),
    .wr_en(id_63),
    .output_score(output_score_63),
    .ID(P_ID_63),
    .renew_id(renew_id)
);
new_patch #(64) new_patch_inst_64(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_64),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_65),
    .wr_en(id_64),
    .output_score(output_score_64),
    .ID(P_ID_64),
    .renew_id(renew_id)
);
new_patch #(65) new_patch_inst_65(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_65),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_66),
    .wr_en(id_65),
    .output_score(output_score_65),
    .ID(P_ID_65),
    .renew_id(renew_id)
);
new_patch #(66) new_patch_inst_66(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_66),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_67),
    .wr_en(id_66),
    .output_score(output_score_66),
    .ID(P_ID_66),
    .renew_id(renew_id)
);
new_patch #(67) new_patch_inst_67(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_67),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_68),
    .wr_en(id_67),
    .output_score(output_score_67),
    .ID(P_ID_67),
    .renew_id(renew_id)
);
new_patch #(68) new_patch_inst_68(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_68),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_69),
    .wr_en(id_68),
    .output_score(output_score_68),
    .ID(P_ID_68),
    .renew_id(renew_id)
);
new_patch #(69) new_patch_inst_69(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_69),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_70),
    .wr_en(id_69),
    .output_score(output_score_69),
    .ID(P_ID_69),
    .renew_id(renew_id)
);
new_patch #(70) new_patch_inst_70(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_70),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_71),
    .wr_en(id_70),
    .output_score(output_score_70),
    .ID(P_ID_70),
    .renew_id(renew_id)
);
new_patch #(71) new_patch_inst_71(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_71),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_72),
    .wr_en(id_71),
    .output_score(output_score_71),
    .ID(P_ID_71),
    .renew_id(renew_id)
);
new_patch #(72) new_patch_inst_72(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_72),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_73),
    .wr_en(id_72),
    .output_score(output_score_72),
    .ID(P_ID_72),
    .renew_id(renew_id)
);
new_patch #(73) new_patch_inst_73(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_73),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_74),
    .wr_en(id_73),
    .output_score(output_score_73),
    .ID(P_ID_73),
    .renew_id(renew_id)
);
new_patch #(74) new_patch_inst_74(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_74),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_75),
    .wr_en(id_74),
    .output_score(output_score_74),
    .ID(P_ID_74),
    .renew_id(renew_id)
);
new_patch #(75) new_patch_inst_75(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_75),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_76),
    .wr_en(id_75),
    .output_score(output_score_75),
    .ID(P_ID_75),
    .renew_id(renew_id)
);
new_patch #(76) new_patch_inst_76(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_76),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_77),
    .wr_en(id_76),
    .output_score(output_score_76),
    .ID(P_ID_76),
    .renew_id(renew_id)
);
new_patch #(77) new_patch_inst_77(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_77),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_78),
    .wr_en(id_77),
    .output_score(output_score_77),
    .ID(P_ID_77),
    .renew_id(renew_id)
);
new_patch #(78) new_patch_inst_78(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_78),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_79),
    .wr_en(id_78),
    .output_score(output_score_78),
    .ID(P_ID_78),
    .renew_id(renew_id)
);
new_patch #(79) new_patch_inst_79(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_79),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_80),
    .wr_en(id_79),
    .output_score(output_score_79),
    .ID(P_ID_79),
    .renew_id(renew_id)
);
new_patch #(80) new_patch_inst_80(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_80),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_81),
    .wr_en(id_80),
    .output_score(output_score_80),
    .ID(P_ID_80),
    .renew_id(renew_id)
);
new_patch #(81) new_patch_inst_81(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_81),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_82),
    .wr_en(id_81),
    .output_score(output_score_81),
    .ID(P_ID_81),
    .renew_id(renew_id)
);
new_patch #(82) new_patch_inst_82(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_82),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_83),
    .wr_en(id_82),
    .output_score(output_score_82),
    .ID(P_ID_82),
    .renew_id(renew_id)
);
new_patch #(83) new_patch_inst_83(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_83),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_84),
    .wr_en(id_83),
    .output_score(output_score_83),
    .ID(P_ID_83),
    .renew_id(renew_id)
);
new_patch #(84) new_patch_inst_84(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_84),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_85),
    .wr_en(id_84),
    .output_score(output_score_84),
    .ID(P_ID_84),
    .renew_id(renew_id)
);
new_patch #(85) new_patch_inst_85(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_85),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_86),
    .wr_en(id_85),
    .output_score(output_score_85),
    .ID(P_ID_85),
    .renew_id(renew_id)
);
new_patch #(86) new_patch_inst_86(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_86),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_87),
    .wr_en(id_86),
    .output_score(output_score_86),
    .ID(P_ID_86),
    .renew_id(renew_id)
);
new_patch #(87) new_patch_inst_87(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_87),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_88),
    .wr_en(id_87),
    .output_score(output_score_87),
    .ID(P_ID_87),
    .renew_id(renew_id)
);
new_patch #(88) new_patch_inst_88(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_88),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_89),
    .wr_en(id_88),
    .output_score(output_score_88),
    .ID(P_ID_88),
    .renew_id(renew_id)
);
new_patch #(89) new_patch_inst_89(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_89),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_90),
    .wr_en(id_89),
    .output_score(output_score_89),
    .ID(P_ID_89),
    .renew_id(renew_id)
);
new_patch #(90) new_patch_inst_90(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_90),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_91),
    .wr_en(id_90),
    .output_score(output_score_90),
    .ID(P_ID_90),
    .renew_id(renew_id)
);
new_patch #(91) new_patch_inst_91(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_91),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_92),
    .wr_en(id_91),
    .output_score(output_score_91),
    .ID(P_ID_91),
    .renew_id(renew_id)
);
new_patch #(92) new_patch_inst_92(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_92),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_93),
    .wr_en(id_92),
    .output_score(output_score_92),
    .ID(P_ID_92),
    .renew_id(renew_id)
);
new_patch #(93) new_patch_inst_93(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_93),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_94),
    .wr_en(id_93),
    .output_score(output_score_93),
    .ID(P_ID_93),
    .renew_id(renew_id)
);
new_patch #(94) new_patch_inst_94(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_94),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_95),
    .wr_en(id_94),
    .output_score(output_score_94),
    .ID(P_ID_94),
    .renew_id(renew_id)
);
new_patch #(95) new_patch_inst_95(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_95),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_96),
    .wr_en(id_95),
    .output_score(output_score_95),
    .ID(P_ID_95),
    .renew_id(renew_id)
);
new_patch #(96) new_patch_inst_96(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_96),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_97),
    .wr_en(id_96),
    .output_score(output_score_96),
    .ID(P_ID_96),
    .renew_id(renew_id)
);
new_patch #(97) new_patch_inst_97(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_97),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_98),
    .wr_en(id_97),
    .output_score(output_score_97),
    .ID(P_ID_97),
    .renew_id(renew_id)
);
new_patch #(98) new_patch_inst_98(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_98),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_99),
    .wr_en(id_98),
    .output_score(output_score_98),
    .ID(P_ID_98),
    .renew_id(renew_id)
);
new_patch #(99) new_patch_inst_99(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_99),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .next_active(active_100),
    .wr_en(id_99),
    .output_score(output_score_99),
    .ID(P_ID_99),
    .renew_id(renew_id)
);

special_patch spec_patch_inst(
    .clk(clk),
    .en(en),
    .row_cnt(row_cnt),
    .col_cnt(col_cnt),
    .new_score(SHI_score),
    .is_FAST(is_FAST),
    .active(active_100),
    .worst_score(min_patch[14:0]),
    .worst_id(min_patch[21:15]),
    .ban_rows(ban_rows),
    .ban_cols(ban_cols),
    .renew_id(renew_id)
    );
endmodule
