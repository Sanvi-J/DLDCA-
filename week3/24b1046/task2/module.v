module ShiftRows(
    input  [63:0] currentState ,
    output [63:0] nextState    
);
    // Fill shift row logic here 
 assign nextState[15:0]=currentState[16:0];

 assign nextState[31:28]=currentState[19:16];
 assign nextState[27:16]=currentState[31:20];

 assign nextState[39:32]=currentState[47:40];
 assign nextState[47:40]=currentState[39:32];

 assign nextState[51:48]=currentState[63:60];
 assign nextState[63:52]=currentState[59:48];
 

endmodule