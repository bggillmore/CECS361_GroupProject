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

integer error, i, j;
integer memCheck [31:0];

always #5 clk = ~clk;

initial begin
    rst = 0;
    clk = 0;
    btns = 5'b0;
    sw = 16'b0;
    sq = 1;
    #10
    rst = 1;
    #10
    
    //STACK
    //fill
    for(i = 0; i < 35; i = i+1)
    begin
        #20
        btns = 5'b1;
        memCheck[i] = {16'b0, sw};
        #10
        btns = 5'b0;
        for(j = i; j < 32 && j >=0; j = j-1)
        begin
            if(memCheck[j] != tl.mem.memory[j])
            begin
                $display("Error code 1 memcheck = %h, mem_j = %h", memCheck[j], tl.mem.memory[j]);
                error = 1;
            end
        end
        if(sseg != tl.mem.data_out)
        begin
            $display("Error code 2");
            error = 1;
        end
    end
    
    //test each operation type
    
    
    //QUEUE
    //fill
    
    //empty
    
    //test each operation type
    
    //MIXING IT UP
    
    
end

always @(posedge clk)
begin
    sw <= $urandom();
end
endmodule
