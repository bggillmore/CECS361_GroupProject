`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB CECS 361
// Engineer: Kristella Jackson
// 
// Create Date: 11/02/2020 12:35:41 AM
// Design Name: Test Bench of 32x32 FIFO/LIFO Memory
// Module Name: FIFO_LIFO_TB
// Project Name: Final Lab Group Project: Dual Stacker/Queue Calculator
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


module FIFO_LIFO_TB();
    
    reg clk, reset, push_queue, pop_dequeue, sel;
    reg [31:0] data_in;
    wire empty, full;
    wire [31:0] data_out;
    
    memory2 uut2(
        .clk(clk), .reset(reset), .push_queue(push_queue), .pop_dequeue(pop_dequeue), .sel(sel),
        .data_in(data_in), .empty(empty), .full(full), .data_out(data_out)
        );
    
    always #5 clk = ~clk;
    
    integer i;
    
    initial begin
        clk = 0; reset = 0; push_queue = 0; pop_dequeue = 0; sel = 0;
        #10;
        
        reset = 1; #10;
        
        for (i=0; i<33; i=i+1) begin // Sel = 0 Stacker/LIFO Push
            data_in = $urandom(); push_queue = 1; #10; push_queue = 0; #20;
        end
        #10;
        for (i=0; i<10; i=i+1) begin // Sel = 0 Stacker/LIFO Pop
            pop_dequeue = 1; #10; pop_dequeue = 0; #20;
            end
        #10;
        for (i=0; i<10; i=i+1) begin // Sel = 0 Stacker/LIFO Push
            data_in = $urandom(); push_queue = 1; #10; push_queue = 0; #20;
        end
        #10;
        for (i=0; i<33; i=i+1) begin // Sel = 0 Stacker/LIFO Pop
            pop_dequeue = 1; #10; pop_dequeue = 0; #20;
        end
        
        reset = 0; #10;
        sel = 1; #10;
        reset = 1; #10;
        
        for (i=0; i<33; i=i+1) begin // Sel = 1 Queue/FIFO queue
            data_in = $urandom(); push_queue = 1; #10; push_queue = 0; #20;
        end
        #10;
        for (i=0; i<10; i=i+1) begin // Sel = 1 Queue/FIFO dequeue
            pop_dequeue = 1; #10; pop_dequeue = 0; #20;
        end
        #10;
        for (i=0; i<10; i=i+1) begin // Sel = 1 Queue/FIFO queue
            data_in = $urandom(); push_queue = 1; #10; push_queue = 0; #20;
        end
        #10;
        for (i=0; i<33; i=i+1) begin // Sel = 1 Queue/FIFO dequeue
            pop_dequeue = 1; #10; pop_dequeue = 0; #20;
        end
        
    end
    
endmodule
