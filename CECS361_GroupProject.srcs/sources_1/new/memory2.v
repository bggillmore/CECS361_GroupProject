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
    reg [31:0] next_out;                //Kristella: **I added this variable back** data_out will display next_out on positive edge of clock
    reg [4:0] slot, next_slot,          // write pointer (push/queue)
              front, next_front,        // pointer to locate Front element (FIFO) (or Bottom element(LIFO))
              top, next_top;            // pointer to locate Top element(LIFO)
    reg [5:0] writecount, next_write;   // write counter
    
    integer i;
    assign full = (next_write === 32); //all slots filled
    assign empty = (writecount === 0); //all slots 'blank' (it won't be able to see the memory anyway if empty is high)

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
        
        else begin // Kristella: **added back the next_out variable so that the data is only displayed on posedge of clock**
            data_out   <= next_out; //for some reason, I can't make the 'slot' and 'front' variables 5-bit b/c if so, the data in front/top gets "skipped".
            slot       <= next_slot;
            front      <= (next_front == 32)? 0 : next_front; 
            top        <= next_top;   //top does not update if the next data input is NOT YET PRESENT.
            writecount <= next_write; //number of data slots written to board.
        end
    end
    
    //Combinational Block
    always @(*) begin
        if (sel) begin // sel = 1, FIFO QUEUE
            if (push_queue) begin //Queue
                if(~full)
                begin
                    next_write = writecount + 5'b1; //Add to counter. If full, stop counting up.
                    memory[slot] =  data_in;        //if full, do not take in any new data input
                    next_slot = slot + 5'b1;        //if full, stay on same slot, else go to next higher slot
                    next_out = memory[slot];        //display inputted data. If full, show last data inputted.
                end
            end
            
            else if (pop_dequeue) begin //Dequeue Data in front of line
                if(~empty)
                begin
                    next_write = writecount - 5'b1; //Subtract from counter. If empty, stop counting down.
                    next_front = front + 5'b1;      //update FIFO pointer to next data in front of line
                    next_out = memory[front];       // expose popped data for one clock
                end
                else
                    next_out = 32'b0;
            end
            
            else begin //Hold all data
                next_write = writecount;
                next_front = front;
                next_slot = slot;
                next_out = (empty)?32'b0:data_out; //display rear of queue so we can see what is added
            end
        end
        
        
        else begin // sel = 0, LIFO STACK
            if (push_queue) begin //Push
                if(~full)
                begin
                    next_write = writecount + 5'b1;
                    memory[slot] = data_in;
                    next_slot = slot + 5'b1;
                    next_out = memory[slot];
                    next_top = slot;
                end
            end
            
            else if (pop_dequeue) begin //Pop data off top of stack
                if(~empty)
                begin
                    next_write = writecount - 5'b1;
                    next_slot = slot - 5'b1;
                    next_out = memory[top-1]; //Kristella: **memory index was edited for user to see the data that is on top stack instead of the data popped off**. Do you want the user to see the next value that is still on top stack? Or do you want the user to see the data that is being popped from stack?
                    next_top =  top - 5'b1;
                end
                else
                    next_out = 32'b0;
            end
            
            else begin //Hold all data
                next_write = writecount;
                next_slot = slot;
                next_out = (empty)? 32'b0 : data_out; //display & hold last data inputted.
                next_top = top;
            end
        end
    end
endmodule
