`timescale 1ns/1fs
import SystemVerilogCSP::*;
module lif_neuron #(
    parameter int THRESHOLD = 10,
    parameter int RESET_VAL = 0,
    parameter real LEAK_RATE = 1,
    parameter int FL = 0,
    parameter int BL = 0
)(
    Channel weight_in,
    Channel spike_out
);
    logic signed [7:0] input_weight;
    int membrane_potential;
    real leaked_potential;
    logic [7:0] spike;
    realtime last_update, elapsed, delta;
    initial begin
        // initialize values
        input_weight = 0;
        membrane_potential = 0;
        spike = 0;
        last_update = $realtime;
        forever begin
            spike = 0;
            // recieve input weight
            weight_in.Receive(input_weight);
            // capture current time
            elapsed = $realtime;
            delta = elapsed - last_update;
            last_update = elapsed;
            #FL;
            // if V > 0, Vleaked = V - lambda(delta)
            // if V < 0, Vleaked = V + lambda(delta)
            // else 0
            // also clamps to zero
            if(membrane_potential > 0) begin
                leaked_potential = membrane_potential - (LEAK_RATE * delta);
                if (leaked_potential < 0) leaked_potential = 0;
            end else if(membrane_potential < 0) begin
                leaked_potential = membrane_potential + (LEAK_RATE * delta);
                if (leaked_potential > 0) leaked_potential = 0;
            end else begin
                leaked_potential = 0;
            end
            // real to integer to truncate towards 0 + input weight to get final potential
            membrane_potential = $rtoi(leaked_potential) + int'(input_weight);
            // if above threshold, spike and reset; send spike
            if(membrane_potential >= THRESHOLD) begin
                spike = 1;
                membrane_potential = RESET_VAL;
                spike_out.Send(spike);
            end
            #BL;
        end
    end

endmodule