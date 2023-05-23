//	Testbench

`include "apb_interface.sv"			        // APB interface module
`include "ahb_interface.sv"			        // AHB interface module

//Tests                                     //include any one of the files at a time

// `include "directed_test_write.sv"        // Directed Testcase for Write commands: See `NO_OF_TESTCASES in the file
// `include "directed_test_read.sv"            // Directed Testcase for Write commands: See `NO_OF_TESTCASES in the file
`include "directed_test_cont.sv"

module top;

    bit clock;
    bit reset;

    always #1 clock = ~clock;

    initial                                             //initial for reset generation for start
    begin
        reset = 0;
        #5 reset = 1;
    end

    apb_bridge_intf apb_intf (clock, reset);            // APB Interface is called and clock and reset are passed to it
    ahb_bridge_intf ahb_intf (clock, reset);            // AHB Interface is called and clock and reset are passed to it

    test testcase (apb_intf,ahb_intf);                  // "test" is the program defined in the Testcase file, and both interface are passed to it

    ahb_apb_bridge DUT (
        .HCLK   (clock),
        .HRESETn(reset),
        .HADDR  (ahb_intf.HADDR),
        .HTRANS (ahb_intf.HTRANS),
        .HWRITE (ahb_intf.HWRITE),
        .HSIZE  (ahb_intf.HSIZE),
        .HBURST (ahb_intf.HBURST),
        .HPROT  (ahb_intf.HPROT),
        .HWDATA (ahb_intf.HWDATA),
        .HSEL   (ahb_intf.HSEL),
        .HRDATA (ahb_intf.HRDATA),
        .HREADY (ahb_intf.HREADY),
        .HRESP  (ahb_intf.HRESP),

        .PADDR  (apb_intf.PADDR),
        .PWDATA (apb_intf.PWDATA),
        .PENABLE(apb_intf.PENABLE),
        .PWRITE (apb_intf.PWRITE),
        .PSEL   (apb_intf.PSEL),
        .PRDATA (apb_intf.PRDATA),
        .PREADY (apb_intf.PREADY),
        .PSLVERR(apb_intf.PSLVERR)
    );                                                  // Module call for the DUT and the appropriate interface signals are passed to it 

    initial                                             // Initial for output waveform generation
    begin
        $dumpfile("Output.vcd");
        $dumpvars;
    end
endmodule: top
