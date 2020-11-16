`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2020 09:51:49 PM
// Design Name: 
// Module Name: Top_level
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


module Top_level(
    input clk, rst, stackQueue,
    input [15:0] switches,
    input [4:0] btns,
    output [31:0] toSSEG,
    output empty, full
    );
    wire [31:0] Y, memIn, memOut, aluA, aluB;
    wire push, pop;
    
    assign toSSEG = memOut;
    
    //debounce btns
    //alu
    ALU alu(.A(aluA), .B(aluB), .op(btns[4:1]), .Y(Y), .overflow());
    //mem cont
    Memory_Controller mc(.clk(clk), .rst(rst), .switches(switches), .aluOut(Y), 
                         .memOut(memOut), .btns(btns), .memIn(memIn), .push(push), 
                         .pop(pop), .aluA(aluA), .aluB(aluB));
    //mem unit
    memory2 mem(.clk(clk), .reset(rst), .data_in(memIn), .push_queue(push), .pop_dequeue(pop), .sel(stackQueue), 
               .data_out(memOut), .empty(empty), .full(full));
               
    //sseg
endmodule
