module tb_tFlipFlop;
    reg clk;
    reg t;
    wire q_ff;

    // Instantiate the T flip-flop
    tFlipFlop uut (
        .clk(clk),
        .t(t),
        .q(q_ff)
    );

    // Clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Simulation sequence
    initial begin
        uut.q = 0;
        $dumpfile("tff_wave.vcd");
        $dumpvars(0, tb_tFlipFlop);
        $display("Time | clk t | q_ff");
        $monitor("%4t |  %b   %b |  %b", $time, clk, t, q_ff);

        t = 0; #10;   // Should hold value
        t = 1; #10;   // Toggle
        t = 1; #10;   // Toggle
        t = 0; #10;   // Hold
        t = 1; #20;   // Toggle twice
        t = 0; #10;   // Hold

        $finish;
    end
endmodule
