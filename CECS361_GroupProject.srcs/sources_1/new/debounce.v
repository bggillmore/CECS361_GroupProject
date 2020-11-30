`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2020 07:22:19 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk, rst, btn, ld,
    output reg posedgeDetected
    );
    reg [9:0] shiftReg;
    reg btnStable;
    reg Q, nQ;
    always@(*)
    begin
        //10 bit and
        btnStable = &shiftReg;
        //posedge detect
        posedgeDetected = (Q && ~nQ)? 1'b1 : 1'b0;
    end
    
    always@(posedge clk, negedge rst)
    begin
        if(~rst)
        begin
            shiftReg = 10'b0;
            Q = 0;
            nQ = 0;
        end
        else
        begin
            //pulse gen
            if(ld)
            begin
                //shift btn into shift register
                shiftReg <= {btn, shiftReg[9:1]};
            end
            //posedge detect
            {nQ, Q} <= {btnStable, nQ};
        end
    end
endmodule