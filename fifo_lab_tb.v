`timescale 1ns / 1ps

module fifo_lab_tb;
    reg clk_w;
    reg clk_r;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] buff_in;
    wire [7:0] buff_out;
    wire [6:0] fifo_counter;

    fifo_lab uut (
        .clk_w(clk_w),
        .clk_r(clk_r),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .buff_in(buff_in),
        .buff_out(buff_out),
        .fifo_counter(fifo_counter)
    );

  // Initialize signals
    initial begin
        clk_w = 0;
        clk_r = 0;
        rst = 1;
        rd_en = 0;
        wr_en = 0;
        buff_in = 8'h00;
        #10 rst = 0; // Release reset
    end

  // Test vectors
    initial begin
        // Write some data
        wr_en = 1;
        buff_in = 8'b10101011;
        #20;
        buff_in = 8'b10101111;
        #20;
        wr_en = 0;

        // Read data
        rd_en = 1;
        #20;
        rd_en = 0;
        $finish;
    end

    // Toggle clock
    always #5 clk_w = ~clk_w;
    always #10 clk_r = ~clk_r;

endmodule
