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
reg [31:0] A, B;
reg [3:0] op;
wire [31:0] Y;
wire of;
integer i;

ALU alu(.A(A),.B(B), .op(op), .Y(Y), .overflow(of));

initial begin
    A = 32'b0;
    B = 32'b0;
    op = 4'b1;
    for(i = 0; i < 4; i = i+1)
    begin
        #5
        while(A != 32'hFFFFFFFF)
        begin
            #5
            while(B != 32'hFFFFFFFF)
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
                            $display("Addition Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                    4'b0100:
                    begin
                        if({1'b0,A}*{1'b0,B} != {of,Y})
                            $display("Addition Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                    4'b1000:
                    begin
                        if({1'b0,A}/{1'b0,B} != {of,Y})
                            $display("Addition Error: A= %h, B= %h, Y= %h, O/F = %h", A, B, Y, of); 
                    end
                endcase
                //in stead of testing 5*(2^32)^2 we are only testing points at given subspace (2^n -1)
                //subspace is: {0001, 0011, 0111, ...}
                //bigOlTest = {bigOlTest[63:0], 1'b1};
                B = {B[30:0], 1'b1};
            end
            A = {A[30:0], 1'b1};
        end
    end
    op = op << 1;
    $display("DONE");
end
endmodule










