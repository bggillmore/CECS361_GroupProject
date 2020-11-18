`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 11:35:14 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
wire [31:0] A, B;
reg [3:0] op;
wire [31:0] Y;
wire of;
reg [32:0] placeHolderA, placeHolderB;
integer i;

ALU alu(.A(A),.B(B), .op(op), .Y(Y), .overflow(of));
assign A = placeHolderA;
assign B = placeHolderB;

initial begin
    placeHolderA = 33'b0;
    placeHolderB = 33'b0;
    op = 4'b1;
    for(i = 0; i < 4; i = i+1)
    begin
        #5
        while(placeHolderA != 33'h1FFFFFFFF)
        begin
            #5
            while(placeHolderB != 33'h1FFFFFFFF)
            begin
                #5
                case(op)
                    4'b0001:
                    begin
                        if({1'b0,A}+{1'b0,B} != {of,Y})
                            $display("Addition Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                    4'b0010:
                    begin
                        if({1'b0,A}-{1'b0,B} != {of,Y})
                            $display("Subtraction Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                    4'b0100:
                    begin
                        if(A*B != Y)
                            $display("Multiplication Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                        if( |(64'hFFFFFFFF00000000 &({32'b0, A}*{32'b0, B})) != of)
                        begin
                            $display("%h", (({32'b0, A}*{32'b0, B}) & 64'hFFFFFFFF00000000));
                            $display("Multiplication o/f error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of);
                        end 
                    end
                    4'b1000:
                    begin
                        if({1'b0,A}/{1'b0,B} != {of,Y})
                            $display("Division Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                endcase
                //in stead of testing 5*(2^32)^2 we are only testing points at given subspace (2^n -1)
                //subspace is: {0001, 0011, 0111, ...}
                //bigOlTest = {bigOlTest[63:0], 1'b1};
                placeHolderB = {placeHolderB[31:0], 1'b1};
            end
            placeHolderA = {placeHolderA[31:0], 1'b1};
            placeHolderB = 33'b0;
        end
        placeHolderA = 33'b0;
        placeHolderB = 33'b0;
        op = op << 1;
    end
    $display("DONE");
end
endmodule










