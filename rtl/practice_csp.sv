
import SystemVerilogCSP::*;
module producer(Channel ch_out);
    initial begin
        ch_out.Send(8'd42);
        ch_out.Send(8'd3);
    end
endmodule
module consumer(Channel ch_in);
    logic [7:0] value;
    always begin
        ch_in.Receive(value);
        $display("Received: %0d", value);
        ch_in.Receive(value);
        $display("Received: %0d", value);
        $finish;
    end
endmodule
module chan;
    Channel #(
        .WIDTH(8),
        .USE_SHADOW_DRIVERS(1'b0),
        .hsProtocol(P4PhaseBD)
    ) link();
    producer p(.ch_out(link));
    consumer c(.ch_in(link));
endmodule
