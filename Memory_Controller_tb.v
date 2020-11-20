`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2020 11:22:24 AM
// Design Name: 
// Module Name: Memory_Controller_tb
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


module Memory_Controller_tb();
reg clk, rst;
reg [15:0] sw;
wire [31:0] aluOut;
reg [31:0] memOut;
reg [4:0] btns;
wire push, pop;
wire [31:0] A, B, memIn;

Memory_Controller MC(.clk(clk), .rst(rst), .switches(sw), .aluOut(aluOut), 
    .memOut(memOut), .btns(btns), .push(push), .pop(pop), .aluA(A), .aluB(B), 
    .memIn(memIn));

reg [31:0] oldA;
assign aluOut = A+B;
integer i;
always #5 clk = ~clk;
initial begin
    clk = 1'b0;
    rst = 1'b0;
    sw = 16'b0;
    i = 0;
    memOut = 32'b0;
    #5
    rst = 1'b1;
    #100
    //push
    for(i = 0; i < 100; i = i+1)
    begin
        #25
        btns = 5'b00001;
        sw = sw + 1;
        #25
        btns = 5'b0;
    end
    #105
    
    //pop
    for(i = 0; i < 100; i = i+1)
    begin
        #25
        btns = 5'b00010;
        oldA = A;
        #50
        btns = 5'b0;
    end
    $display("done");
end

always @(posedge push)
begin
    if(btns == 5'b1)
    begin
        if(memIn != {16'b0, sw})
            $display("Error in pushing sw vals, memIn = %h", memIn);
    end
    else
    begin
        if(aluOut != memIn)
            $display("Error in pushing alu out, memIn = %h", memIn);
    end
end

always @(posedge clk)
begin
    memOut <= $urandom;
end
endmodule
