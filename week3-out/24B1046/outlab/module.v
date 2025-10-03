module Encrypt(
    input [63:0]  plaintext  ,
    input [63:0]  secretKey  ,
    output [63:0] ciphertext 
);
wire [63:0] round_keys [0:10];
    assign round_keys[0] = secretKey;
    
    genvar k;
    generate
        for (k = 0; k < 10; k = k + 1) begin : key_schedule
            NextKey next_key(
                .currentKey(round_keys[k]),
                .nextKey(round_keys[k+1])
            );
        end
    endgenerate

wire [63:0] round_states [0:10];
    AddRoundKey init_ark(
        .currentState(plaintext),
        .roundKey(round_keys[0]),
        .nextState(round_states[0])
    );

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : main_rounds
            Round round(
                .currentState(round_states[i]),
                .roundKey(round_keys[i+1]),
                .nextState(round_states[i+1])
            );
        end
    endgenerate
        assign ciphertext=round_states[10];


endmodule

module Round(
    input  [63:0] currentState ,
    input  [63:0] roundKey     ,
    output [63:0] nextState    
);
wire [63:0] Sbox_next;
wire [63:0] shift_next;

genvar i;
generate
        for (i = 0; i < 16; i = i + 1) begin : subbytes
            SBox sbox_final(
                .in(currentState[4*i+3:4*i]),
                .out(Sbox_next[4*i+3:4*i])
            );
        end
endgenerate

ShiftRows shiting(
    .currentState(Sbox_next),
    .nextState(shift_next)
);
AddRoundKey keyadd(
    .currentState(shift_next),
    .roundKey(roundKey),
    .nextState(nextState)
);

endmodule

module SBox(
    input [3:0]in ,
    output [3:0]out
);

 assign out[0]=(~in[1]&in[0]&~in[3]) | (~in[1]&~in[0]&in[2]) | (~in[0]&in[1]&in[2]) | (~in[0]&in[1]&in[3]) | (in[1]&in[2]&in[3]);
 assign out[1]=(~in[1]&in[0]) | (~in[0]&in[3]&~in[2]) | (~in[1]&~in[2]&~in[3]) | (~in[0]&in[1]&in[2]&~in[3]);
 assign out[2] = (~in[1]&~in[0]&~in[3]) | (~in[1]&in[2]&in[3]) | (~in[2]&in[1]&in[3]) | (~in[0]&in[2]&~in[3]) | (in[1]&in[0]&~in[2]);
 assign out[3] = (~in[1]&in[0]&~in[3]&~in[2]) | (~in[1]&~in[0]&~in[2]&in[3]) | (in[2]&in[0]&in[3]) | (in[1]&in[0]&in[2]) | (in[2]&~in[0]&~in[3]) | (in[1]&in[0]&in[3]);
endmodule


module NextKey(
    input  [63:0] currentKey,
    output [63:0] nextKey
);

 assign nextKey[63:4]=currentKey[59:0];
 assign nextKey[3:0]=currentKey[63:60];

endmodule

module ShiftRows(
    input  [63:0] currentState ,
    output [63:0] nextState    
);
 assign nextState[15:0]=currentState[15:0];

 assign nextState[31:28]=currentState[19:16];
 assign nextState[27:16]=currentState[31:20];

 assign nextState[39:32]=currentState[47:40];
 assign nextState[47:40]=currentState[39:32];

 assign nextState[51:48]=currentState[63:60];
 assign nextState[63:52]=currentState[59:48];
 
endmodule

module AddRoundKey(
    input  [63:0] currentState ,
    input  [63:0] roundKey     ,
    output [63:0] nextState    
);

assign nextState = currentState ^ roundKey;

endmodule
