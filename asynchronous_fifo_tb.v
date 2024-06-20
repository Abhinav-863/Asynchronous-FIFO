`timescale 1ns/1ps
`include "asynchronous_fifo.v"
module asynchronous_fifo_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter DEPTH = 128;
    parameter PTR = 8;

    // Testbench signals
    reg clk_w, clk_r, rst, wr_en, rd_en;
    reg [DATA_WIDTH-1:0] buff_in;
    wire [DATA_WIDTH-1:0] buff_out;
    wire [DEPTH-1:0] fifo_counter;

    // Instantiate the FIFO module
    asynchronous_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .PTR(PTR)
    ) uut (
        .clk_w(clk_w),
        .clk_r(clk_r),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .buff_in(buff_in),
        .buff_out(buff_out),
        .fifo_counter(fifo_counter)
    );

    // Generate clocks
    always #5 clk_w = ~clk_w;
    always #10 clk_r = ~clk_r;

    initial begin
        // Initialize signals
        clk_w = 0;
        clk_r = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        buff_in = 0;

        // Reset the FIFO
        #10 rst = 0;
        
        // Write some data
        #10 wr_en = 1; buff_in = 32'hA5A5A5A5;
        #10 wr_en = 0;
        
        #20 wr_en = 1; buff_in = 32'hB784C3A8;
        #10 wr_en = 0;
        
        // Read some data
        #30 rd_en = 1;
        #10 rd_en = 0;
        
        #30 rd_en = 1;
        #10 rd_en = 0;
        
        // Finish the simulation
        #100 $finish;
    end

    initial begin
        // Monitor signals
        $monitor("Time=%0t, rst=%b, wr_en=%b, rd_en=%b, buff_in=%h, buff_out=%h, fifo_counter=%d", $time, rst, wr_en, rd_en, buff_in, buff_out, fifo_counter);
    end

    initial begin
        // VCD dump
        $dumpfile("asynchronous_fifo_tb.vcd"); // Name of the VCD file
        $dumpvars(0, asynchronous_fifo_tb);    // Dump all variables
    end

endmodule
