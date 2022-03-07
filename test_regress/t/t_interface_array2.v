// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2015 by Johan Bjork.
// SPDX-License-Identifier: CC0-1.0

interface intf;
    logic logic_in_intf;
    modport source(output logic_in_intf);
    modport sink(input logic_in_intf);
endinterface

module modify_interface
(
input logic value,
intf.source intf_inst
);
assign intf_inst.logic_in_intf = value;
endmodule

module t
#(
    parameter N = 2
)();
    intf ifs[N-1:0] ();
    logic [N-1:0] data;
    assign data = {1'b0, 1'b1};

    modify_interface m0 (
        .value(data[0]),
        .intf_inst(ifs[0]));

    generate
        genvar j;
        for (j = 0;j < N-1; j++) begin
            initial begin
                if (ifs[j].logic_in_intf != data[j]) begin
                    $display("!!!ERROR!!! ifs[%0d].logic_in_intf (%0d) != data[%0d] (%0d)",
                       j, ifs[j].logic_in_intf, j, data[j]);
                    $stop();
                end
            end
        end
    endgenerate

    initial begin
       $write("*-* All Finished *-*\n");
       $finish;
    end
endmodule
