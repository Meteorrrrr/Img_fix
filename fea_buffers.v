module fea_buffers(
    input clk,
    input en,
    input [WIDTH-1:0] din,
    input in_valid,
    output [WIDTH-1:0] l_10,
    output [WIDTH-1:0] l_9,
    output [WIDTH-1:0] l_8,
    output [WIDTH-1:0] l_7,
    output [WIDTH-1:0] l_6,
    output [WIDTH-1:0] l_5,
    output [WIDTH-1:0] l_4,
    output [WIDTH-1:0] l_3,
    output [WIDTH-1:0] l_2,
    output [WIDTH-1:0] l_1,
    output [WIDTH-1:0] l_0,
    output reg [7:0] row_cnt,
    output reg [8:0] col_cnt
    );

parameter WIDTH = 8;
parameter ROW = 240;
parameter COL = 376;
reg [7:0] fea_rows;
reg [8:0] fea_cols;
reg start;
always @(posedge clk or negedge en) begin
    if (!en) begin
        fea_cols <= 1'b0;
    end
    else if(in_valid)begin
        if (fea_cols == COL - 1) begin
            fea_cols <= 1'b0;
        end
        else begin
            fea_cols <= fea_cols + 1'b1;
        end
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        fea_rows <= 1'b0;
        start <= 1'b0;
    end
    else if(in_valid)begin
        if (fea_rows == 4'd10 && fea_cols == (COL - 1'b1)) begin // 在(753, 1)停止
            start <= 1'b1;
            // fea_rows <= 1'b0;
            fea_rows <= fea_rows + 1'b1;
        end
        else begin
            if (fea_cols == COL - 1) begin
                fea_rows <= fea_rows + 1'b1;
            end
            else begin
                fea_rows <= fea_rows;
            end
        end
    end
end

always @(posedge clk or negedge en) begin
    if (!en) begin
        col_cnt <= 1'b0;
    end
    else if(start)begin
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
    else if(start)begin
        if (row_cnt == (ROW - 1'b1) && col_cnt == (COL - 1'b1)) begin // 在(753, 1)停止
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
half_buffer half_buffer_10(
    .CE(in_valid),
    .CLK(clk),
    .D(din),
    .Q(l_10)
    );

half_buffer half_buffer_9(
    .CE(in_valid),
    .CLK(clk),
    .D(l_10),
    .Q(l_9)
    );

half_buffer half_buffer_8(
    .CE(in_valid),
    .CLK(clk),
    .D(l_9),
    .Q(l_8)
    );

half_buffer half_buffer_7(
    .CE(in_valid),
    .CLK(clk),
    .D(l_8),
    .Q(l_7)
    );

half_buffer half_buffer_6(
    .CE(in_valid),
    .CLK(clk),
    .D(l_7),
    .Q(l_6)
    );

half_buffer half_buffer_5(
    .CE(in_valid),
    .CLK(clk),
    .D(l_6),
    .Q(l_5)
    );

half_buffer half_buffer_4(
    .CE(in_valid),
    .CLK(clk),
    .D(l_5),
    .Q(l_4)
    );

half_buffer half_buffer_3(
    .CE(in_valid),
    .CLK(clk),
    .D(l_4),
    .Q(l_3)
    );

half_buffer half_buffer_2(
    .CE(in_valid),
    .CLK(clk),
    .D(l_3),
    .Q(l_2)
    );

half_buffer half_buffer_1(
    .CE(in_valid),
    .CLK(clk),
    .D(l_2),
    .Q(l_1)
    );

half_buffer half_buffer_0(
    .CE(in_valid),
    .CLK(clk),
    .D(l_1),
    .Q(l_0)
    );

endmodule
