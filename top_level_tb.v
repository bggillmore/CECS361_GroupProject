`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 12:47:06 AM
// Design Name: 
// Module Name: top_level_tb
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


module top_level_tb();
reg clk, rst, sq;
reg [15:0] sw;
reg [4:0] btns;
wire [31:0] sseg;
wire empty, full;
 
Top_level tl(.clk(clk), .rst(rst), .stackQueue(sq), .switches(sw), .btns(btns), 
             .toSSEG(sseg), .empty(empty), .full(full));
integer i, j, seriesSum;
always #5 clk = ~clk;
initial begin
    rst = 0;
    clk = 0;
    btns = 5'b0;
    sw = 16'b0;
    sq = 1'b0;
    i=0;
    #10
    rst = 1;
    #100
    
    //fill memory as stack
    for(i = 0; i < 32; i= i+1)
    begin
        #20
        sw = sw + 1;
        btns = 5'b1;
        #20
        btns = 5'b0;
    end
    if(~full)
        $display("Error: should be full");
    $display("Memory Filled!");
    
    //add together values as stack
    for(i = 0; i < 31; i = i+1)
    begin
        #20
        btns = 5'b00010;
        #60
        btns = 5'b0;
        seriesSum = 0;
        for(j = 32; j > (30-i); j = j-1)
        begin
            seriesSum = seriesSum + j;
        end
        if(seriesSum !== sseg)
        begin
            $display("sum: %h    sseg: %h ", seriesSum, sseg);
            $display("Error!");
        end
    end
    $display("DONE!");
end

always@(posedge clk)
    #1
    if(~full && btns == 5'b01)
    begin
        if(sseg != {16'b0, sw})
            $display("push error, sseg not displaying pushed value");
    end
endmodule
