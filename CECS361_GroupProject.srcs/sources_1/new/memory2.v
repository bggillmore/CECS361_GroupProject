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



module memory2(
    input clk, reset, push_queue, pop_dequeue, sel, //clock and button variables
    input [31:0] data_in,
    output empty, full, //Flags
    output reg [31:0] data_out
    );
// bits per memory || number of memory spaces (AKA slots)
    reg [31:0] memory [0:31];           //32x32 bit memory space
    reg [31:0] next_out;                //will work like an FSM
    reg [5:0] slot, next_slot,          // write pointer (push/queue)
              front, next_front,        // pointer to locate Front element (FIFO) (or Bottom element(LIFO))
              top, next_top,            // pointer to locate Top element(LIFO)
              writecount, next_write;   // write counter
    
    integer i;
    assign full = (next_write === 32); //all slots filled
    assign empty = (next_write === 0); //all slots 'blank' (it won't be able to see the memory anyway if empty is high)

    //Sequential Block
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            for (i=0; i<32; i=i+1) begin //Set all memory slots to 32-bit 0.
                memory[i] <= 32'b0;
            end
            data_out <= 0; slot <= 0; //Display data of 0 (to show empty) and start at slot 0.
            front <= 0; //Reset FIFO pointer
            top <= 0;   //Reset LIFO pointer
            writecount <= 0; //Reset counter
            //full <= 0; empty <= 0; //Reset flags
            next_front <= 0;
        end
        
        else begin
            //data_out   <= next_out; //for some reason, I can't make the 'slot' and 'front' variables 5-bit b/c if so, the data in front/top gets "skipped".
            slot       <= next_slot;
            front      <= (next_front == 32)? 0 : next_front; 
            top        <= next_top;   //top does not update if the next data input is NOT YET PRESENT.
            writecount <= next_write; //number of data slots written to board.
        end
    end
    
    //Combinational Block
    always @(*) begin
        if (sel) begin // sel = 1, FIFO
            if (push_queue) begin //Queue
                if(~full)
                    next_write = writecount+1;//Add to counter. If full, stop counting up.
                //next_write = (full)? writecount : writecount + 1; //Add to counter. If full, stop counting up.
                memory[slot] = (full)? memory[slot] : data_in; //if full, do not take in any new data input
                next_slot = (full)? slot : (slot == 31)? 0 : slot + 1; //if full, stay on same slot, else go to next higher slot
                //next_out = memory[front]; //display first inputted data (front in line)
                data_out = (full)? data_out : memory[slot]; //display inputted data. If full, show last data inputted.
                //next_out = (full)? data_out : memory[slot]; //display inputted data. If full, show last data inputted.
                
            end
            
            else if (pop_dequeue) begin //Dequeue Data in front of line
                next_write = (empty)? writecount : writecount - 1; //Subtract from counter. If empty, stop counting down.
                next_front = (empty)? front : front + 1; //update FIFO pointer to next data in front of line
                //next_out = (empty || writecount==1)? 32'b0 : (front==31)? memory[0] : memory[front+1];//if empty=1 OR next_write=0(therefore, if writecount=1), display 0. Else, display next data in front of line.
                //next_out = (empty)? 32'b0 : memory[front]; // expose popped data for one clock
                data_out = (empty)? 32'b0 : memory[front]; // expose popped data for one clock
            end
            
            else begin //Hold all data
                next_write = writecount;
                next_front = front;
                next_slot = slot;
                //next_out = data_out; //display & hold last data inputted.
                //next_out = (empty)? 32'b0:memory[slot]; //display rear of queue so we can see what is added
                data_out = (empty)? 32'b0:memory[slot]; //display rear of queue so we can see what is added
            end
        end
        
        
        else begin // sel = 0, LIFO
            if (push_queue) begin //Push
                if(~full)
                begin
                    next_write = writecount+1;
                    memory[slot] = data_in;
                    next_slot = (slot == 31)? 0 : slot + 1;
                    data_out = memory[slot];
                    next_top = slot;
                end
                //next_write = (full)? writecount : writecount + 1; //Add to counter. If full, stop counting up.
                //memory[slot] = (full) ? memory[slot] : data_in; //if full, do not take in any new data input
                //next_slot = (full)? slot : (slot == 31)? 0 : slot + 1; //if full, stay on same slot, else go to next higher slot
                //next_out = (full)? data_out : memory[slot]; //display inputted data. If full, show last data inputted.
                //data_out = (full)? data_out : memory[slot]; //display inputted data. If full, show last data inputted.
                //next_top = (full)? top : slot; //go up to next top block of data that is present.
            end
            
            else if (pop_dequeue) begin //Pop data off top of stack
                if(~empty)
                begin
                    next_write = writecount - 1;
                    next_slot = (slot == 0)? 31 : slot - 1;
                    data_out = (top == 0)? memory[31] : memory[top]; 
                    next_top =  top - 1;
                end
                //next_write = (empty)? writecount : writecount - 1; //Subtract from counter. If empty, stop counting down.
                //next_slot = (empty)? slot : (slot == 0)? 31 : slot - 1;
                //data_out = (empty || writecount==1)? 32'b0 : (top == 0)? memory[31] : memory[top]; //if empty=1 OR next_write=0(therefore, if writecount=1), display 0. Else, display next top data stacked.
                //next_out = (empty || writecount==1)? 32'b0 : (top == 0)? memory[31] : memory[top-1]; //if empty=1 OR next_write=0(therefore, if writecount=1), display 0. Else, display next top data stacked.
                //next_top = (empty)? top : top - 1; //go down to next top block of data that is present.
            end
            
            else begin //Hold all data
                next_write = writecount;
                next_slot = slot;
                next_out = data_out; //display & hold last data inputted.
                next_top = top;
            end
        end
        if(empty)
            data_out = 32'b0;
    end
    
endmodule
