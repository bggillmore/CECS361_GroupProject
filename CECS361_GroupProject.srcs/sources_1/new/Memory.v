`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2020 03:34:59 PM
// Design Name: 
// Module Name: Memory
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


module Memory(
input clk, reset, push_queue, pop_dequeue, sel,
    input [31:0] data_in,
    output empty, full,
    output reg [31:0] data_out
    );
// bits per memory || number of memory spaces (AKA slots)
    reg [31:0] memory [0:31];
    reg [31:0] next_out;                //will work like an FSM
    reg [5:0] head, next_head,          // head pointer
              base, next_base;          // base counter
    
    integer i;
    
    assign full  = (next_head == next_base);
    assign empty = (head == base);
    //assign memory[slot] = data_in;
    
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            for (i=0; i<32; i=i+1) begin 
                memory[i] <= 32'b0;
            end
            data_out    <= 32'b0;
            head        <= 6'b0;
            base        <= 6'b0;
        end
        else begin
            data_out    <= next_out;
            head        <= next_head;
            base        <= next_base;
        end
    end
    
    always @(*) begin
        if (sel) begin // sel = 1, FIFO
            if (push_queue)
            begin //enQueue
                memory[head+1'b1] = data_in;
                next_head = head + 1'b1;
            end
            else 
            begin
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