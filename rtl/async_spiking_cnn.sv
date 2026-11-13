import SystemVerilogCSP::*;
module async_spiking_cnn #(
    parameter int THRESHOLD = 10,
    parameter int RESET_VAL = 0,
    parameter real LEAK_RATE = 1,
    parameter int FL = 0,
    parameter int BL = 0,
    parameter int ROW_BASE = 0,
    parameter int COL_BASE = 0
)(
    Channel spike_in,
    Channel spike_out
);
    // 9 intermediate channels, connect PE's 9 outputs to Router's 9 inputs
    Channel #(
        .WIDTH(8),
        .USE_SHADOW_DRIVERS(1'b0),
        .hsProtocol(P4PhaseBD)
    ) inter_ch[9]();

    // PE Inst
    conv_pe #(
            .THRESHOLD(THRESHOLD),
            .RESET_VAL(RESET_VAL),
            .LEAK_RATE(LEAK_RATE),
            .FL(FL),
            .BL(BL),
            .ROW_BASE(ROW_BASE),
            .COL_BASE(COL_BASE)
        ) processing_element ( 
            .spike_in(spike_in),
            .spike_out(inter_ch)
        );

    // Router inst
    spike_router #(
            .ROW_BASE(ROW_BASE),
            .COL_BASE(COL_BASE)
        ) router ( 
            .spike_in(inter_ch),
            .spike_out(spike_out)
        );

    
endmodule