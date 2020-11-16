`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2020 10:07:22 AM
// Design Name: 
// Module Name: Memory_tb
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


module Memory_tb();
reg clk, rst, push, pop, sel;
reg [31:0] in;
wire empty, full;
wire [31:0] out;

integer i,j;
integer memCheck [31:0];
reg error;

memory2 m(.clk(clk), .reset(rst), .push_queue(push), .pop_dequeue(pop), .sel(sel), .data_in(in),
    .empty(empty), .full(full), .data_out(out));

always #5 clk = ~clk;
initial begin
    rst = 1'b0;
    clk = 1'b0;
    push = 1'b0;
    pop = 1'b0;
    sel = 0; //stack
    in = 32'b0;
    #10
    rst = 1'b1;
    
    //Section 1: stack mode, test pushing
    for(i = 0; i < 32; i= i+1)
    begin
        #10
        push = 1'b1;
        memCheck[i] = in;
        #10
        push = 1'b0;
        for(j = i; j>=0; j=j-1)
            if(m.memory[j] !== memCheck[j])
            begin
                $display("Stack push error, IN = %h, Memory at space %f is ", in, i, m.memory[j]);
                error = 1'b1;
            end
        if(out !== memCheck[i])
        begin
            $display("Stack push display error, IN = %h, OUT = %h ", in, out);
            error = 1'b1;
        end
    end
    if(~full)
    begin
        $display("No 'Full' flag after 32 stack pushes");
        error = 1'b1;
    end
    if(error)
    begin
        error = 1'b0;
        $display("Section 1, Stack Push Failure"); 
    end
    else
        $display("Section 1, Stack Push Success"); 
        
    //Section 2: stack mode, test popping
    for(i = 31; i >=0; i= i-1)
    begin
        #10
        pop = 1'b1;
        #10
        pop = 1'b0;
        if(i == 0)
        begin
            if(out != 32'b0)
            begin
                error = 1'b1;
                $display("Stack pop display error at empty, OUT = %h", out);
            end
        end
        else if(out != memCheck[i-1])
        begin
            error = 1'b1;
            $display("Stack pop display error, OUT = %h, memCheck = %h ", out, memCheck[i-1]);
        end
    end
    if(~empty)
    begin
        error = 1'b1;
        $display("No 'Empty' flag after 32 stack pops");
    end
    
    if(error)
    begin
        error = 1'b0;
        $display("Section 2, Stack Pop Failure"); 
    end
    else
        $display("Section 2, Stack Pop Success"); 
    
    
    //Section 3: queue mode, test enqueue
    sel = 1'b1;
    for(i = 0; i < 32; i= i+1)
    begin
        #10
        push = 1'b1;
        memCheck[i] = in;
        #10
        push = 1'b0;
        for(j = i; j>=0; j=j-1)
            if(m.memory[j] !== memCheck[j])
            begin
                $display("Enqueue error, IN = %h, Memory at space %f is ", in, i, m.memory[j]);
                error = 1'b1;
            end
        if(out !== memCheck[i])
        begin
            $display("Enqueue display error, IN = %h, OUT = %h ", in, out);
            error = 1'b1;
        end
    end
    if(~full)
    begin
        $display("No 'Full' flag after 32 enqueues");
        error = 1'b1;
    end
    if(error)
    begin
        error = 1'b0;
        $display("Section 3, Enqueue Failure"); 
    end
    else
        $display("Section 3, Enqueue Success");
        
        
        
    //Section 4: queue mode, test dequeue
    for(i = 0; i < 32; i= i+1)
    begin
        #10
        pop = 1'b1;
        #10
        pop = 1'b0;
        if(out !== memCheck[i])
        begin
            error = 1'b1;
            $display("Dequeue display error, OUT = %h, memCheck = %h ", out, memCheck[i]);
        end
    end
    if(~empty)
    begin
        $display("No 'Empty' flag after 32 dequeues");
        error = 1'b1;
    end
    #10
    if(out !== 32'b0)
    begin
        error = 1'b1;
        $display("Dequeue display error at empty (past exposing popped data), OUT = %h", out);
    end
    if(error)
    begin
        error = 1'b0;
        $display("Section 4, Dequeue Failure"); 
    end
    else
        $display("Section 4, Dequeue Success");
        
    //section 5
    //wrap around test 21 enqueue -> 5 dequeue -> 16 enqueue should result in full flag
    //verifying enqueue writes to previously free'd memory
  
    
    //section 6
    //wrap around test 21 stack push -> 5 dequeue -> 16 stack push should result in full flag
    //verifying stack push writes to previously free'd memory
    
    
    //section 7
    //consistancy test 16 stack push -> 16 enqueue should result in full flag
    //verifying enqueue can write to next value of a stack (transforming stack to a queue) 
    
    
    //section 8
    //consistancy test 16 enqueue -> 16 stack push should result in full flag
    //verifying stack push can write to next value of a queue (transforming queue to a stack)
    
    //section 9
    //consistancy test 8 enqueue -> 8 stack push -> 8 dequeue -> 8 stack pop
    //should result in empty flag
    
    //section 10
    //consistancy test  8 stack push -> 8 enqueue  -> 8 stack pop -> 8 dequeue
    //should result in empty flag

    //section 11
    //trying to force an error
    //35 stack push -> 35 dequeue -> 16 stack push -> 16 dequeue -> 8 enqueue -> 
    //32 stack push -> 35 stack pop -> 35 enqueue -> rotate until empty -> rotate until full
    
    
    
    
end

always @(posedge clk)
begin
    in <= $urandom();
end

endmodule
