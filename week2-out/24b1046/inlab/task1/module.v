module tFlipFlop (
    input clk,
    input t,
    output reg q
);
    // Register logic must be written in an always block
    // This block is triggered on the rising edge of the clock
always @(posedge clk) begin
    if(t) begin
    q <=  ! q;
    end
end

endmodule

module buffer (
    input d,
    output wire q
);

    // Combinational logic can be written using assign statements
    // The output changes immediately with the input
    assign q=d;
    
endmodule
