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
    output empty, full,
    output [7:0] anode, 
    output [7:0] cathode
    );
    wire [31:0] Y, memIn, memOut, aluA, aluB;
    wire [4:0] btn_db;
    wire push, pop, ld;
    reg [13:0] clkCounter;
    
    //wire stackQueue;    
    //assign stackQueue = 1'b0;

    //debounce btns
    //pulse gen
    
//assign ld = (clkCounter == 9_999)? 1'b1 : 1'b0;
    debounce db0(.clk(clk), .reset(rst), .sw(btns[0]), .db(btn_db[0]));
    debounce db1(.clk(clk), .reset(rst), .sw(btns[1]), .db(btn_db[1]));
    debounce db2(.clk(clk), .reset(rst), .sw(btns[2]), .db(btn_db[2]));
    debounce db3(.clk(clk), .reset(rst), .sw(btns[3]), .db(btn_db[3]));
    debounce db4(.clk(clk), .reset(rst), .sw(btns[4]), .db(btn_db[4]));
    
    
    //alu
    ALU alu(.A(aluA), .B(aluB), .op(btn_db[4:1]), .Y(Y), .overflow());
    
    //mem cont
    Memory_Controller mc(.clk(clk), .rst(rst), .switches(switches), .aluOut(Y), 
                         .memOut(memOut), .btns(btn_db), .memIn(memIn), .push(push), 
                         .pop(pop), .aluA(aluA), .aluB(aluB));
    //mem unit
    memory2 mem(.clk(clk), .reset(rst), .data_in(memIn), .push_queue(push), .pop_dequeue(pop), .sel(stackQueue), 
               .data_out(memOut), .empty(empty), .full(full));

    //sseg
    SSEG sseg1(.clk(clk), .rst(rst), .in(memOut), .anode(anode), .cathode(cathode));
    
    /*
    //count clock cycles
    always@(posedge clk, negedge rst)
    begin
        if(~rst)
            clkCounter <= 14'b0;
        else
            if(ld)
                //reset clk count on load
                clkCounter <= 14'b0;
            else
                //increment clk counter
                clkCounter <= clkCounter + 1'b1;
    end
    */
endmodule
