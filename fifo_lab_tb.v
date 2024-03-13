`timescale 1ns / 1ps  // Define simulation timescale

module fifo_lab_tb;

    parameter DATA_WIDTH = 8,     // Width of data stored in the FIFO
    parameter DEPTH = 64,         // Depth or size of the FIFO
    parameter PTR = 4             // Number of bits required to address FIFO memory locations
    reg clk_w;          // Define write clock signal
    reg clk_r;          // Define read clock signal
    reg rst;            // Define reset signal
    reg wr_en;          // Define write enable signal
    reg rd_en;          // Define read enable signal
    reg [DATA_WIDTH-1:0] buff_in;  // Define input data to the FIFO
    wire [DATA_WIDTH-1:0] buff_out;  // Define output data read from the FIFO
    wire [DEPTH-1:0] fifo_counter;  // Define current occupancy of the FIFO

    fifo_lab uut (      // Instantiate the FIFO     module
        .clk_w(clk_w),  // Connect write clock signal
        .clk_r(clk_r),  // Connect read clock signal
        .rst(rst),      // Connect reset signal
        .wr_en(wr_en),  // Connect write enable signal
        .rd_en(rd_en),  // Connect read enable signal
        .buff_in(buff_in),  // Connect input data
        .buff_out(buff_out),  // Connect output data
        .fifo_counter(fifo_counter)  // Connect FIFO counter
    );

    // Initialize signals
    initial begin
        clk_w = 0;     // Initialize write clock to 0
        clk_r = 0;     // Initialize read clock to 0
        rst = 1;       // Assert reset
        rd_en = 0;     // Disable read operation
        wr_en = 0;     // Disable write operation
        buff_in = 8'h00;  // Initialize input data to 0
        #10 rst = 0;    // Release reset after 10 time units
    end

    // Test vectors
    initial begin
        // Write some data
        wr_en = 1;           // Enable write operation
        buff_in = 8'b10101011;  // Set input data
        #20;                 // Wait for 20 time units
        buff_in = 8'b10101111;  // Set new input data
        #20;                 // Wait for 20 time units
        wr_en = 0;           // Disable write operation

        // Read data
        rd_en = 1;           // Enable read operation
        #20;                 // Wait for 20 time units
        rd_en = 0;           // Disable read operation
        $finish;             // End simulation
    end

    // Toggle clocks
    always #5 clk_w = ~clk_w;  // Toggle write clock every 5 time units
    always #10 clk_r = ~clk_r;  // Toggle read clock every 10 time units

endmodule
