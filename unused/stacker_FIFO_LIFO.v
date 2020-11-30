`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB CECS 361
// Engineer: Kristella Jackson
// 
// Create Date: 10/24/2020 02:49:09 PM
// Design Name: 32x32 FIFO/LIFO Memory
// Module Name: stacker_FIFO_LIFO
// Project Name: Final Lab Group Project: Dual Stacker/Queue Calculator
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Finished 11/14/2020
// 
//////////////////////////////////////////////////////////////////////////////////


module stacker_FIFO_LIFO(
    input clk, reset, push_queue, pop_dequeue, sel,
    input [31:0] data_in,
    output reg empty, full,
    output reg [31:0] data_out
    );
// bits per memory || number of memory spaces (AKA slots)
    reg [31:0] memory [0:31];
    reg [31:0] next_out;                //will work like an FSM
    reg [5:0] slot, next_slot,          // write pointer
              //front, next_front,        // pointer to locate front (FIFO) or bottom (LIFO) element
              //readcount, next_read,     // read counter
              writecount, next_write;   // write counter
    
    integer i;
    
    //assign full  = (!reset)? 0: (next_write == 32) ? 1 : 0;
    //assign empty = (!reset)? 0: (next_write == 0) ? 1 : 0;
    //assign memory[slot] = data_in;
    
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            for (i=0; i<32; i=i+1) begin 
                memory[i] <= 32'b0;
            end
            data_out   <= 0;
            slot       <= 0;
            //front      <= 0;
            //readcount  <= 32;
            writecount <= 0;
            full       <= 0;
            empty      <= 0;
        end
        else begin
            data_out   <= next_out;
            slot       <= next_slot;
            //front      <= (next_front == 32)? 0 : next_front;
            //readcount  <=  next_read; //pop/remover data and it is read on board.
            writecount <=  next_write; //number of data written to board.
            full       <= (next_write == 32) ? 1 : 0;
            empty      <= (next_write == 0) ? 1 : 0;
        end
    end
    
    always @(*) begin
        if (sel) begin // sel = 1, FIFO
            if (push_queue) begin //Queue
                next_write = (full)? writecount : writecount + 1;
                if (slot == 32) begin
                    memory[0] = (full) ? memory[0] : data_in; //if full, do not take in any new data input
                    next_slot = (full) ? slot : 1; //if full, hold slot location. Else, next slot.
                end
                else begin
                    memory[slot] = (full) ? memory[slot] : data_in; //if full, do not take in any new data input
                    next_slot = (full)? slot : slot + 1; //(full)? slot : (next_slot == 32)? 0 : slot + 1
                end
                //next_read = (full)? readcount : readcount - 1;
            end
            else if (pop_dequeue) begin //Dequeue
                next_write = (empty)? writecount : writecount - 1;
                //next_out = (empty)? 32'b0 : memory[front]; //if empty, display 0
                //next_front = (empty)? front : front + 1;
                //next_read = (empty)? readcount : readcount + 1;
            end
            else begin //Hold data
                next_out = data_out;
                next_slot = slot;
                //next_front = front;
                next_write = writecount;
                //next_read = readcount;
            end
        end
        else begin // sel = 0, LIFO
            if (push_queue) begin //Push
                next_write = (full)? writecount : writecount + 1;
                if (slot == 32) begin
                    memory[0] = (full) ? memory[0] : data_in; //if full, do not take in any new data input
                    next_slot = (full) ? slot : 1; //if full, hold slot location. Else, next slot.
                end
                else begin
                    memory[slot] = (full) ? memory[slot] : data_in; //if full, do not take in any new data input
                    next_slot = (full)? slot : slot + 1; //(full)? slot : (next_slot == 32)? 0 : slot + 1
                end
                //next_read = (full)? readcount : readcount - 1;
            end
            else if (pop_dequeue) begin //Pop
                next_write = (empty)? writecount : writecount - 1;
                next_out = (empty)? 32'b0 : memory[slot-1]; // if empty, display 0
                //next_read = (empty)? readcount : readcount + 1;
                next_slot = (empty)? slot : (next_slot == 0)? 31 : slot - 1;
            end
            else begin //Hold data
                next_out = data_out;
                next_slot = slot;
                next_write = writecount;
                //next_read = readcount;
            end
        end
    end
    
endmodule

