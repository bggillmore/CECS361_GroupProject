`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 03:13:21 PM
// Design Name: 
// Module Name: sanity_check
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


module sanity_check();
    
reg clk, rst, sq;
reg [15:0] sw;
reg [4:0] btns;
wire empty, full;
 
Top_level tl(.clk(clk), .rst(rst), .stackQueue(sq), .switches(sw), .btns(btns), 
             .empty(empty), .full(full));

always #5 clk = ~clk;
initial begin
    rst = 0;
    clk = 0;
    btns = 5'b0;
    sw = 16'b0;
    sq = 1'b0;
    #10
    rst = 1;
    #100
    
    
    
    sw = 16'hFFFF0F0F0;
    #30000000
    btns = 5'b1;
    #30000000
    btns = 5'b0;
    
    
    sw = 16'h1111E4E4;
    #30000000
    btns = 5'b1;
    #30000000
    btns = 5'b0;
    
    
    #30000000
    btns = 5'b00010;
    #30000000
    btns = 5'b0;
    
    $display("done");
    
end
endmodule
