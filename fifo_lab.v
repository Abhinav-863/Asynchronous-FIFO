module fifo_lab
#(
    parameter DATA_WIDTH = 8,     // Width of data stored in the FIFO
    parameter DEPTH = 64,         // Depth or size of the FIFO
    parameter PTR = 4             // Number of bits required to address FIFO memory locations
)
(
    input clk_w, clk_r, rst, wr_en, rd_en,         // Clock, reset, write enable, and read enable signals
    input [DATA_WIDTH-1:0] buff_in,                // Input data to be written into the FIFO
    output reg [DATA_WIDTH-1:0] buff_out,          // Output data read from the FIFO
    output reg [6:0] fifo_counter                   // Current occupancy of the FIFO
);

    reg buff_empty, buff_full;                      // Flags indicating FIFO empty and full status
    reg [PTR-1:0] rd_pointer, wr_pointer;           // Pointers to track read and write positions
    reg [DATA_WIDTH-1:0] buff_mem [DEPTH-1:0];      // Array representing FIFO memory

    // Check if FIFO is empty or full based on fifo_counter
    always @ (fifo_counter) begin
        buff_empty = (fifo_counter == 0);
        buff_full = (fifo_counter == (DEPTH-1));
    end

    // Write operation: Increment fifo_counter when writing to the FIFO
    always @(posedge clk_w or posedge rst) begin
        if (rst) begin
            fifo_counter <= 0;
        end
        else if (!buff_full && wr_en) begin
            fifo_counter <= fifo_counter + 1;
        end
        else begin
            fifo_counter <= fifo_counter;   // No change to fifo_counter
        end
    end

    // Read operation: Decrement fifo_counter when reading from the FIFO
    always @(posedge clk_r or posedge rst) begin
        if (!buff_empty && rd_en) begin
            fifo_counter <= fifo_counter - 1;
        end
        else begin
            fifo_counter <= fifo_counter;   // No change to fifo_counter
        end
    end

    // Output data read from the FIFO
    always @(posedge clk_r or posedge rst) begin
        if (rst) begin
            buff_out <= 0;
        end
        else begin
            if (rd_en && !buff_empty) begin
                buff_out <= buff_mem[rd_pointer];
            end
            else begin
                buff_out <= buff_out;       // No change to buff_out
            end
        end
    end

    // Write data into the FIFO
    always @(posedge clk_w or posedge rst) begin
        if (wr_en && !buff_full) begin
            buff_mem[wr_pointer] <= buff_in;
        end
        else begin
            buff_mem[wr_pointer] <= buff_mem[wr_pointer];   // No change to FIFO memory
        end
    end

    // Update write pointer
    always @(posedge clk_w or posedge rst) begin
        if (rst) begin
            wr_pointer <= 0;
        end
        else if (!buff_full && wr_en) begin
            wr_pointer <= wr_pointer + 1;
        end
        else begin
            wr_pointer <= wr_pointer;   // No change to wr_pointer
        end
    end

    // Update read pointer
    always @(posedge clk_r or posedge rst) begin
        if (rst) begin
            rd_pointer <= 0;
        end
        else if (!buff_empty && rd_en) begin
            rd_pointer <= rd_pointer + 1;
        end
        else begin
            rd_pointer <= rd_pointer;   // No change to rd_pointer
        end
    end

endmodule
