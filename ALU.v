`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2020 09:51:09 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A, B,
    input [3:0] op,
    output reg [31:0] Y
    );
    
    always @(*)
    begin
        case(op)
            //add overflow flags
            4'b0001: Y = A+B;
            4'b0010: Y = A-B;
            4'b0100: Y = A*B;
            4'b1000: Y = A/B;
            default: Y = 32'b0;
        endcase 
    end
endmodule
