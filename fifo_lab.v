module fifo_lab
#(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 64,
    parameter PTR = 4
)
(
    input clk_w,clk_r,rst,wr_en,rd_en,
    input [DATA_WIDTH-1:0] buff_in,
    output reg [DATA_WIDTH-1:0] buff_out,
    output reg [6:0] fifo_counter
);

    reg buff_empty,buff_full;
    reg [PTR-1:0]  rd_pointer, wr_pointer;
    reg [DATA_WIDTH-1:0] buff_mem [DEPTH-1:0];

    always @ (fifo_counter) begin
        buff_empty =(fifo_counter==0);
        buff_full=(fifo_counter==(DEPTH-1));
    end

    always@(posedge clk_w or posedge rst) begin
        if(rst)begin
            fifo_counter<=0;
        end
        else if(!buff_full && wr_en)begin
            fifo_counter <= fifo_counter+1;
        end
        else begin
            fifo_counter <= fifo_counter;
        end
    end

    always@(posedge clk_r or  posedge rst) begin
        if(!buff_empty && rd_en) begin
            fifo_counter<= fifo_counter-1;
        end
        else begin
            fifo_counter <= fifo_counter;
        end
    end

    always@(posedge clk_r or posedge rst) begin
        if(rst)begin
            buff_out<=0;
        end
        else begin
            if(rd_en && !buff_empty)begin
                buff_out<=buff_mem[rd_pointer];
            end
            else begin
                buff_out<=buff_out;
            end
        end
    end

    always@(posedge clk_w or posedge rst) begin
        if(wr_en && !buff_full)begin
            buff_mem[wr_pointer]<=buff_in;
        end
        else begin
            buff_mem[wr_pointer]<=buff_mem[wr_pointer];
        end
    end

    always@(posedge clk_w or posedge rst) begin
        if(rst)begin
            wr_pointer<=0;
        end
        else if(!buff_full && wr_en) begin
            wr_pointer<=wr_pointer+1;
        end
        else begin
            wr_pointer<=wr_pointer;
        end
    end

    always @(posedge clk_r or posedge rst) begin
        if(rst) begin
            rd_pointer <= 0;
        end
        else if(!buff_empty && rd_en) begin
            rd_pointer <= rd_pointer+1;
        end
        else begin
            rd_pointer <= rd_pointer;
        end
    end

    
endmodule
