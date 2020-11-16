`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2020 11:08:09 PM
// Design Name: 
// Module Name: Memory_Controller
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


module Memory_Controller(
    input clk, rst, 
    input [15:0] switches, 
    input [31:0] aluOut, memOut,
    input [4:0] btns,
    output reg push, pop, 
    output reg [31:0] aluA, aluB, memIn
    );
    reg [1:0] cycleCount;
    
    always @(posedge clk, negedge rst)
    begin
        if(~rst)
        begin
            cycleCount <= 2'b0;
            aluA <= 32'b0;
            aluB <= 32'b0;
            memIn <= 32'b0;
            push <= 1'b0;
            pop <= 1'b0;
        end
        else
        begin
            if(^btns[4:1] & ~btns[0]) //only one operation btn is pressed
            begin
                //pop twice hold values and push
                //this is a possible edge case in that the buttons changes mid cycle
                //ie: count1:btn=00001   count2: btn=00001   count3:btn=01000
                //if you are not careful you will screw yourself in a sim loop dummy
                casex(cycleCount)
                    2'b0?:
                    begin
                        //is this a race condition?
                        aluB <= aluA;   //if i expose memOut - 1
                        aluA <= memOut; //can i save a clock cycle here?
                        push <= 1'b0;
                        pop <= 1'b1;
                        cycleCount <= cycleCount +1;
                    end 
                    2'b10: 
                    begin
                        pop <= 1'b0;
                        push <= 1'b1;
                        memIn <= aluOut;
                        cycleCount <= cycleCount +1;
                    end
                    2'b11: //do nothing wait for all btns to be 0
                    begin
                        push <= 1'b0;
                        cycleCount <= cycleCount; 
                    end
                    default: 
                    begin
                        pop <= 1'b0;
                        push <= 1'b0;
                        aluA <= 32'b0;
                        aluB <= 32'b0;
                    end
                endcase
            end
            else if(btns[0] & ~|btns[4:1]) //only push btn is pressed
            begin
                //push
                if(cycleCount == 2'b0) //only push once
                begin
                    pop <= 1'b0;
                    push <= 1'b1;
                    memIn <= {16'b0, switches};
                    cycleCount <= cycleCount + 1'b1;
                end
                else
                    push <= 1'b0;
            end
            else if(btns == 5'b0) //btns released, wait for btn input
            begin
                push <= 1'b0;
                pop <= 1'b0;
                cycleCount <= 2'b0;
            end
        end
    end
endmodule
