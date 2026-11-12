import SystemVerilogCSP::*;
module lif_neuron #(
    parameter int THRESHOLD = 10,
    parameter int RESET_VAL = 0
)(
    Channel spike_in,
    Channel spike_out
);
    logic signed [7:0] input_weight;
    int membrane_potential;
    logic spike;
    initial begin
        // initialize values
        input_weight = 0;
        membrane_potential = 0;
        spike = 0;
        // simple if_neuron behavior, recieve input, add to potential, if exceeds threshold send spike and reset
        forever begin
            spike = 0;
            spike_in.Receive(input_weight);
            membrane_potential += input_weight;
            if(membrane_potential >= THRESHOLD) begin
                spike = 1;
                membrane_potential = RESET_VAL;
                spike_out.Send(spike);
            end
        end
    end

endmodule