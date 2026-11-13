import SystemVerilogCSP::*;
module spike_router #(
    parameter int ROW_BASE = 0,
    parameter int COL_BASE = 0
)(
    Channel spike_in[9],
    Channel spike_out
);
    // mailbox for constant/infinite output space
    mailbox #(logic [7:0]) output_queue = new(9);
    for(genvar i = 0; i < 9; i++) begin
        localparam int ROW = ROW_BASE + i / 3;
        localparam int COL = COL_BASE + i % 3;
        logic [7:0] token;
        initial begin
            forever begin
                spike_in[i].Receive(token);
                output_queue.put({ROW[3:0], COL[3:0]});
            end
        end
    end
    logic [7:0] packet;
    initial begin
        forever begin
            output_queue.get(packet);
            spike_out.Send(packet);
        end
    end
endmodule