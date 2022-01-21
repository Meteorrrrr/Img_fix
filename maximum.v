`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/18 19:43:41
// Design Name: 
// Module Name: maximum
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


module maximum(
    input [W-1:0] com_0,
    input [W-1:0] com_1,
    input [W-1:0] com_2,
    input [W-1:0] com_3,
    input [W-1:0] com_4,
    input [W-1:0] com_5,
    input [W-1:0] com_6,
    input [W-1:0] com_7,
    input [W-1:0] com_8,
    input [W-1:0] com_9,
    input [W-1:0] com_10,
    input [W-1:0] com_11,
    input [W-1:0] com_12,
    input [W-1:0] com_13,
    input [W-1:0] com_14,
    input [W-1:0] com_15,
    input [W-1:0] com_16,
    input [W-1:0] com_17,
    input [W-1:0] com_18,
    input [W-1:0] com_19,
    input [W-1:0] com_20,
    input [W-1:0] com_21,
    input [W-1:0] com_22,
    input [W-1:0] com_23,
    input [W-1:0] com_24,
    input [W-1:0] com_25,
    input [W-1:0] com_26,
    input [W-1:0] com_27,
    input [W-1:0] com_28,
    input [W-1:0] com_29,
    input [W-1:0] com_30,
    input [W-1:0] com_31,
    input [W-1:0] com_32,
    input [W-1:0] com_33,
    input [W-1:0] com_34,
    input [W-1:0] com_35,
    input [W-1:0] com_36,
    input [W-1:0] com_37,
    input [W-1:0] com_38,
    input [W-1:0] com_39,
    input [W-1:0] com_40,
    input [W-1:0] com_41,
    input [W-1:0] com_42,
    input [W-1:0] com_43,
    input [W-1:0] com_44,
    input [W-1:0] com_45,
    input [W-1:0] com_46,
    input [W-1:0] com_47,
    input [W-1:0] com_48,
    input [W-1:0] com_49,
    input [W-1:0] com_50,
    input [W-1:0] com_51,
    input [W-1:0] com_52,
    input [W-1:0] com_53,
    input [W-1:0] com_54,
    input [W-1:0] com_55,
    input [W-1:0] com_56,
    input [W-1:0] com_57,
    input [W-1:0] com_58,
    input [W-1:0] com_59,
    input [W-1:0] com_60,
    input [W-1:0] com_61,
    input [W-1:0] com_62,
    input [W-1:0] com_63,
    input [W-1:0] com_64,
    input [W-1:0] com_65,
    input [W-1:0] com_66,
    input [W-1:0] com_67,
    input [W-1:0] com_68,
    input [W-1:0] com_69,
    input [W-1:0] com_70,
    input [W-1:0] com_71,
    input [W-1:0] com_72,
    input [W-1:0] com_73,
    input [W-1:0] com_74,
    input [W-1:0] com_75,
    input [W-1:0] com_76,
    input [W-1:0] com_77,
    input [W-1:0] com_78,
    input [W-1:0] com_79,
    input [W-1:0] com_80,
    input [W-1:0] com_81,
    input [W-1:0] com_82,
    input [W-1:0] com_83,
    input [W-1:0] com_84,
    input [W-1:0] com_85,
    input [W-1:0] com_86,
    input [W-1:0] com_87,
    input [W-1:0] com_88,
    input [W-1:0] com_89,
    input [W-1:0] com_90,
    input [W-1:0] com_91,
    input [W-1:0] com_92,
    input [W-1:0] com_93,
    input [W-1:0] com_94,
    input [W-1:0] com_95,
    input [W-1:0] com_96,
    input [W-1:0] com_97,
    input [W-1:0] com_98,
    input [W-1:0] com_99,
    output [W-1:0] max
    );
parameter W = 22;
parameter SBit = 15;
wire [W-1:0] stage0_result_0;
wire [W-1:0] stage0_result_1;
wire [W-1:0] stage0_result_2;
wire [W-1:0] stage0_result_3;
wire [W-1:0] stage0_result_4;
wire [W-1:0] stage0_result_5;
wire [W-1:0] stage0_result_6;
wire [W-1:0] stage0_result_7;
wire [W-1:0] stage0_result_8;
wire [W-1:0] stage0_result_9;
wire [W-1:0] stage0_result_10;
wire [W-1:0] stage0_result_11;
wire [W-1:0] stage0_result_12;
wire [W-1:0] stage0_result_13;
wire [W-1:0] stage0_result_14;
wire [W-1:0] stage0_result_15;
wire [W-1:0] stage0_result_16;
wire [W-1:0] stage0_result_17;
wire [W-1:0] stage0_result_18;
wire [W-1:0] stage0_result_19;
wire [W-1:0] stage0_result_20;
wire [W-1:0] stage0_result_21;
wire [W-1:0] stage0_result_22;
wire [W-1:0] stage0_result_23;
wire [W-1:0] stage0_result_24;
wire [W-1:0] stage0_result_25;
wire [W-1:0] stage0_result_26;
wire [W-1:0] stage0_result_27;
wire [W-1:0] stage0_result_28;
wire [W-1:0] stage0_result_29;
wire [W-1:0] stage0_result_30;
wire [W-1:0] stage0_result_31;
wire [W-1:0] stage0_result_32;
wire [W-1:0] stage0_result_33;
wire [W-1:0] stage0_result_34;
wire [W-1:0] stage0_result_35;
wire [W-1:0] stage0_result_36;
wire [W-1:0] stage0_result_37;
wire [W-1:0] stage0_result_38;
wire [W-1:0] stage0_result_39;
wire [W-1:0] stage0_result_40;
wire [W-1:0] stage0_result_41;
wire [W-1:0] stage0_result_42;
wire [W-1:0] stage0_result_43;
wire [W-1:0] stage0_result_44;
wire [W-1:0] stage0_result_45;
wire [W-1:0] stage0_result_46;
wire [W-1:0] stage0_result_47;
wire [W-1:0] stage0_result_48;
wire [W-1:0] stage0_result_49;

wire [W-1:0] stage1_result_0;
wire [W-1:0] stage1_result_1;
wire [W-1:0] stage1_result_2;
wire [W-1:0] stage1_result_3;
wire [W-1:0] stage1_result_4;
wire [W-1:0] stage1_result_5;
wire [W-1:0] stage1_result_6;
wire [W-1:0] stage1_result_7;
wire [W-1:0] stage1_result_8;
wire [W-1:0] stage1_result_9;
wire [W-1:0] stage1_result_10;
wire [W-1:0] stage1_result_11;
wire [W-1:0] stage1_result_12;
wire [W-1:0] stage1_result_13;
wire [W-1:0] stage1_result_14;
wire [W-1:0] stage1_result_15;
wire [W-1:0] stage1_result_16;
wire [W-1:0] stage1_result_17;
wire [W-1:0] stage1_result_18;
wire [W-1:0] stage1_result_19;
wire [W-1:0] stage1_result_20;
wire [W-1:0] stage1_result_21;
wire [W-1:0] stage1_result_22;
wire [W-1:0] stage1_result_23;
wire [W-1:0] stage1_result_24;

wire [W-1:0] stage2_result_0;
wire [W-1:0] stage2_result_1;
wire [W-1:0] stage2_result_2;
wire [W-1:0] stage2_result_3;
wire [W-1:0] stage2_result_4;
wire [W-1:0] stage2_result_5;
wire [W-1:0] stage2_result_6;
wire [W-1:0] stage2_result_7;
wire [W-1:0] stage2_result_8;
wire [W-1:0] stage2_result_9;
wire [W-1:0] stage2_result_10;
wire [W-1:0] stage2_result_11;
wire [W-1:0] stage2_result_12;

wire [W-1:0] stage3_result_0;
wire [W-1:0] stage3_result_1;
wire [W-1:0] stage3_result_2;
wire [W-1:0] stage3_result_3;
wire [W-1:0] stage3_result_4;
wire [W-1:0] stage3_result_5;
wire [W-1:0] stage3_result_6;

wire [W-1:0] stage4_result_0;
wire [W-1:0] stage4_result_1;
wire [W-1:0] stage4_result_2;
wire [W-1:0] stage4_result_3;

wire [W-1:0] stage5_result_0;
wire [W-1:0] stage5_result_1;

assign stage0_result_0 = com_0[SBit-1:0] > com_1[SBit-1:0] ? com_0 : com_1;
assign stage0_result_1 = com_2[SBit-1:0] > com_3[SBit-1:0] ? com_2 : com_3;
assign stage0_result_2 = com_4[SBit-1:0] > com_5[SBit-1:0] ? com_4 : com_5;
assign stage0_result_3 = com_6[SBit-1:0] > com_7[SBit-1:0] ? com_6 : com_7;
assign stage0_result_4 = com_8[SBit-1:0] > com_9[SBit-1:0] ? com_8 : com_9;
assign stage0_result_5 = com_10[SBit-1:0] > com_11[SBit-1:0] ? com_10 : com_11;
assign stage0_result_6 = com_12[SBit-1:0] > com_13[SBit-1:0] ? com_12 : com_13;
assign stage0_result_7 = com_14[SBit-1:0] > com_15[SBit-1:0] ? com_14 : com_15;
assign stage0_result_8 = com_16[SBit-1:0] > com_17[SBit-1:0] ? com_16 : com_17;
assign stage0_result_9 = com_18[SBit-1:0] > com_19[SBit-1:0] ? com_18 : com_19;
assign stage0_result_10 = com_20[SBit-1:0] > com_21[SBit-1:0] ? com_20 : com_21;
assign stage0_result_11 = com_22[SBit-1:0] > com_23[SBit-1:0] ? com_22 : com_23;
assign stage0_result_12 = com_24[SBit-1:0] > com_25[SBit-1:0] ? com_24 : com_25;
assign stage0_result_13 = com_26[SBit-1:0] > com_27[SBit-1:0] ? com_26 : com_27;
assign stage0_result_14 = com_28[SBit-1:0] > com_29[SBit-1:0] ? com_28 : com_29;
assign stage0_result_15 = com_30[SBit-1:0] > com_31[SBit-1:0] ? com_30 : com_31;
assign stage0_result_16 = com_32[SBit-1:0] > com_33[SBit-1:0] ? com_32 : com_33;
assign stage0_result_17 = com_34[SBit-1:0] > com_35[SBit-1:0] ? com_34 : com_35;
assign stage0_result_18 = com_36[SBit-1:0] > com_37[SBit-1:0] ? com_36 : com_37;
assign stage0_result_19 = com_38[SBit-1:0] > com_39[SBit-1:0] ? com_38 : com_39;
assign stage0_result_20 = com_40[SBit-1:0] > com_41[SBit-1:0] ? com_40 : com_41;
assign stage0_result_21 = com_42[SBit-1:0] > com_43[SBit-1:0] ? com_42 : com_43;
assign stage0_result_22 = com_44[SBit-1:0] > com_45[SBit-1:0] ? com_44 : com_45;
assign stage0_result_23 = com_46[SBit-1:0] > com_47[SBit-1:0] ? com_46 : com_47;
assign stage0_result_24 = com_48[SBit-1:0] > com_49[SBit-1:0] ? com_48 : com_49;
assign stage0_result_25 = com_50[SBit-1:0] > com_51[SBit-1:0] ? com_50 : com_51;
assign stage0_result_26 = com_52[SBit-1:0] > com_53[SBit-1:0] ? com_52 : com_53;
assign stage0_result_27 = com_54[SBit-1:0] > com_55[SBit-1:0] ? com_54 : com_55;
assign stage0_result_28 = com_56[SBit-1:0] > com_57[SBit-1:0] ? com_56 : com_57;
assign stage0_result_29 = com_58[SBit-1:0] > com_59[SBit-1:0] ? com_58 : com_59;
assign stage0_result_30 = com_60[SBit-1:0] > com_61[SBit-1:0] ? com_60 : com_61;
assign stage0_result_31 = com_62[SBit-1:0] > com_63[SBit-1:0] ? com_62 : com_63;
assign stage0_result_32 = com_64[SBit-1:0] > com_65[SBit-1:0] ? com_64 : com_65;
assign stage0_result_33 = com_66[SBit-1:0] > com_67[SBit-1:0] ? com_66 : com_67;
assign stage0_result_34 = com_68[SBit-1:0] > com_69[SBit-1:0] ? com_68 : com_69;
assign stage0_result_35 = com_70[SBit-1:0] > com_71[SBit-1:0] ? com_70 : com_71;
assign stage0_result_36 = com_72[SBit-1:0] > com_73[SBit-1:0] ? com_72 : com_73;
assign stage0_result_37 = com_74[SBit-1:0] > com_75[SBit-1:0] ? com_74 : com_75;
assign stage0_result_38 = com_76[SBit-1:0] > com_77[SBit-1:0] ? com_76 : com_77;
assign stage0_result_39 = com_78[SBit-1:0] > com_79[SBit-1:0] ? com_78 : com_79;
assign stage0_result_40 = com_80[SBit-1:0] > com_81[SBit-1:0] ? com_80 : com_81;
assign stage0_result_41 = com_82[SBit-1:0] > com_83[SBit-1:0] ? com_82 : com_83;
assign stage0_result_42 = com_84[SBit-1:0] > com_85[SBit-1:0] ? com_84 : com_85;
assign stage0_result_43 = com_86[SBit-1:0] > com_87[SBit-1:0] ? com_86 : com_87;
assign stage0_result_44 = com_88[SBit-1:0] > com_89[SBit-1:0] ? com_88 : com_89;
assign stage0_result_45 = com_90[SBit-1:0] > com_91[SBit-1:0] ? com_90 : com_91;
assign stage0_result_46 = com_92[SBit-1:0] > com_93[SBit-1:0] ? com_92 : com_93;
assign stage0_result_47 = com_94[SBit-1:0] > com_95[SBit-1:0] ? com_94 : com_95;
assign stage0_result_48 = com_96[SBit-1:0] > com_97[SBit-1:0] ? com_96 : com_97;
assign stage0_result_49 = com_98[SBit-1:0] > com_99[SBit-1:0] ? com_98 : com_99;

assign stage1_result_0 = stage0_result_0[SBit-1:0] > stage0_result_1[SBit-1:0] ? stage0_result_0 : stage0_result_1;
assign stage1_result_1 = stage0_result_2[SBit-1:0] > stage0_result_3[SBit-1:0] ? stage0_result_2 : stage0_result_3;
assign stage1_result_2 = stage0_result_4[SBit-1:0] > stage0_result_5[SBit-1:0] ? stage0_result_4 : stage0_result_5;
assign stage1_result_3 = stage0_result_6[SBit-1:0] > stage0_result_7[SBit-1:0] ? stage0_result_6 : stage0_result_7;
assign stage1_result_4 = stage0_result_8[SBit-1:0] > stage0_result_9[SBit-1:0] ? stage0_result_8 : stage0_result_9;
assign stage1_result_5 = stage0_result_10[SBit-1:0] > stage0_result_11[SBit-1:0] ? stage0_result_10 : stage0_result_11;
assign stage1_result_6 = stage0_result_12[SBit-1:0] > stage0_result_13[SBit-1:0] ? stage0_result_12 : stage0_result_13;
assign stage1_result_7 = stage0_result_14[SBit-1:0] > stage0_result_15[SBit-1:0] ? stage0_result_14 : stage0_result_15;
assign stage1_result_8 = stage0_result_16[SBit-1:0] > stage0_result_17[SBit-1:0] ? stage0_result_16 : stage0_result_17;
assign stage1_result_9 = stage0_result_18[SBit-1:0] > stage0_result_19[SBit-1:0] ? stage0_result_18 : stage0_result_19;
assign stage1_result_10 = stage0_result_20[SBit-1:0] > stage0_result_21[SBit-1:0] ? stage0_result_20 : stage0_result_21;
assign stage1_result_11 = stage0_result_22[SBit-1:0] > stage0_result_23[SBit-1:0] ? stage0_result_22 : stage0_result_23;
assign stage1_result_12 = stage0_result_24[SBit-1:0] > stage0_result_25[SBit-1:0] ? stage0_result_24 : stage0_result_25;
assign stage1_result_13 = stage0_result_26[SBit-1:0] > stage0_result_27[SBit-1:0] ? stage0_result_26 : stage0_result_27;
assign stage1_result_14 = stage0_result_28[SBit-1:0] > stage0_result_29[SBit-1:0] ? stage0_result_28 : stage0_result_29;
assign stage1_result_15 = stage0_result_30[SBit-1:0] > stage0_result_31[SBit-1:0] ? stage0_result_30 : stage0_result_31;
assign stage1_result_16 = stage0_result_32[SBit-1:0] > stage0_result_33[SBit-1:0] ? stage0_result_32 : stage0_result_33;
assign stage1_result_17 = stage0_result_34[SBit-1:0] > stage0_result_35[SBit-1:0] ? stage0_result_34 : stage0_result_35;
assign stage1_result_18 = stage0_result_36[SBit-1:0] > stage0_result_37[SBit-1:0] ? stage0_result_36 : stage0_result_37;
assign stage1_result_19 = stage0_result_38[SBit-1:0] > stage0_result_39[SBit-1:0] ? stage0_result_38 : stage0_result_39;
assign stage1_result_20 = stage0_result_40[SBit-1:0] > stage0_result_41[SBit-1:0] ? stage0_result_40 : stage0_result_41;
assign stage1_result_21 = stage0_result_42[SBit-1:0] > stage0_result_43[SBit-1:0] ? stage0_result_42 : stage0_result_43;
assign stage1_result_22 = stage0_result_44[SBit-1:0] > stage0_result_45[SBit-1:0] ? stage0_result_44 : stage0_result_45;
assign stage1_result_23 = stage0_result_46[SBit-1:0] > stage0_result_47[SBit-1:0] ? stage0_result_46 : stage0_result_47;
assign stage1_result_24 = stage0_result_48[SBit-1:0] > stage0_result_49[SBit-1:0] ? stage0_result_48 : stage0_result_49;

assign stage2_result_0 = stage1_result_0[SBit-1:0] > stage1_result_1[SBit-1:0] ? stage1_result_0 : stage1_result_1;
assign stage2_result_1 = stage1_result_2[SBit-1:0] > stage1_result_3[SBit-1:0] ? stage1_result_2 : stage1_result_3;
assign stage2_result_2 = stage1_result_4[SBit-1:0] > stage1_result_5[SBit-1:0] ? stage1_result_4 : stage1_result_5;
assign stage2_result_3 = stage1_result_6[SBit-1:0] > stage1_result_7[SBit-1:0] ? stage1_result_6 : stage1_result_7;
assign stage2_result_4 = stage1_result_8[SBit-1:0] > stage1_result_9[SBit-1:0] ? stage1_result_8 : stage1_result_9;
assign stage2_result_5 = stage1_result_10[SBit-1:0] > stage1_result_11[SBit-1:0] ? stage1_result_10 : stage1_result_11;
assign stage2_result_6 = stage1_result_12[SBit-1:0] > stage1_result_13[SBit-1:0] ? stage1_result_12 : stage1_result_13;
assign stage2_result_7 = stage1_result_14[SBit-1:0] > stage1_result_15[SBit-1:0] ? stage1_result_14 : stage1_result_15;
assign stage2_result_8 = stage1_result_16[SBit-1:0] > stage1_result_17[SBit-1:0] ? stage1_result_16 : stage1_result_17;
assign stage2_result_9 = stage1_result_18[SBit-1:0] > stage1_result_19[SBit-1:0] ? stage1_result_18 : stage1_result_19;
assign stage2_result_10 = stage1_result_20[SBit-1:0] > stage1_result_21[SBit-1:0] ? stage1_result_20 : stage1_result_21;
assign stage2_result_11 = stage1_result_22[SBit-1:0] > stage1_result_23[SBit-1:0] ? stage1_result_22 : stage1_result_23;
assign stage2_result_12 = stage1_result_24;

assign stage3_result_0 = stage2_result_0[SBit-1:0] > stage2_result_1[SBit-1:0] ? stage2_result_0 : stage2_result_1;
assign stage3_result_1 = stage2_result_2[SBit-1:0] > stage2_result_3[SBit-1:0] ? stage2_result_2 : stage2_result_3;
assign stage3_result_2 = stage2_result_4[SBit-1:0] > stage2_result_5[SBit-1:0] ? stage2_result_4 : stage2_result_5;
assign stage3_result_3 = stage2_result_6[SBit-1:0] > stage2_result_7[SBit-1:0] ? stage2_result_6 : stage2_result_7;
assign stage3_result_4 = stage2_result_8[SBit-1:0] > stage2_result_9[SBit-1:0] ? stage2_result_8 : stage2_result_9;
assign stage3_result_5 = stage2_result_10[SBit-1:0] > stage2_result_11[SBit-1:0] ? stage2_result_10 : stage2_result_11;
assign stage3_result_6 = stage2_result_12;

assign stage4_result_0 = stage3_result_0[SBit-1:0] > stage3_result_1[SBit-1:0] ? stage3_result_0 : stage3_result_1;
assign stage4_result_1 = stage3_result_2[SBit-1:0] > stage3_result_3[SBit-1:0] ? stage3_result_2 : stage3_result_3;
assign stage4_result_2 = stage3_result_4[SBit-1:0] > stage3_result_5[SBit-1:0] ? stage3_result_4 : stage3_result_5;
assign stage4_result_3 = stage3_result_6;

assign stage5_result_0 = stage4_result_0[SBit-1:0] > stage4_result_1[SBit-1:0] ? stage4_result_0 : stage4_result_1;
assign stage5_result_1 = stage4_result_2[SBit-1:0] > stage4_result_3[SBit-1:0] ? stage4_result_2 : stage4_result_3;

assign max = stage5_result_0[SBit-1:0] > stage5_result_1[SBit-1:0] ? stage5_result_0 : stage5_result_1;
endmodule
