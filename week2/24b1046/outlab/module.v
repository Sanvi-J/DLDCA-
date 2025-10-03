module getNextState (
    input [2:0] currentState,
    output [2:0] nextState
);
    assign nextState[0] = ~currentState[0]; 
    assign nextState[1] = currentState[1] ^ (currentState[0]);
    assign nextState[2] = currentState[2] ^ (currentState[1] & currentState[0]);  
endmodule


module threeBitCounter (
    input clk,
    input reset,
    output reg [2:0] count   
);
wire [2:0] next_count;

    getNextState inst (
        .currentState(count),
        .nextState(next_count)
    );
always @(posedge clk) begin
    if(reset)begin
        count<=3'b000;
    end
    else begin
        count <= next_count;
    end
    
end

endmodule

module counterToLights (
    input [2:0] count,
    output [2:0] rgb
);

assign rgb[2]=(~count[0]&~count[1]&~count[2])|(~count[2]&count[1]&count[0])|(count[2]&~count[1]);
assign rgb[1]=(~count[2]&~count[1])|(~count[2]&count[1]&~count[0])|(count[2]&~count[1]&~count[0]);
assign rgb[0]=(~count[2]&~count[1]&~count[0])|(count[2]&~count[1]&count[0])|(count[1]&~count[0]);

endmodule

module rgbLighter (
    input clk,
    input reset,
    output [2:0] rgb
);
wire [2:0] count;
threeBitCounter inst1 (
        .reset(reset),
        .clk(clk),
        .count(count)
    );

counterToLights inst2 (
        .count(count),
        .rgb(rgb)
    );

endmodule
