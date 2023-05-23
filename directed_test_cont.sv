`define NO_OF_TESTCASES 20

// include files
`include "environment.sv"

program test(apb_bridge_intf apb_intf, ahb_bridge_intf ahb_intf);

	class apb_trans_test extends apb_trans;
		
		function void pre_randomize();
			
			// PRDATA.rand_mode(0);
			PREADY.rand_mode(0);
			PSLVERR.rand_mode(0);

			// PRDATA = {32'hFFF8, 32'hFFF9, 32'hFFFA, 32'hFFFB, 32'hFFFC, 32'hFFFD, 32'hFFFE, 32'hFFFF};
			PREADY = 8'hFF;
			PSLVERR = 0;
		endfunction

	endclass: apb_trans_test

	class ahb_trans_test extends ahb_trans;

		function void pre_randomize();

			// HADDR.rand_mode(0);
			HTRANS.rand_mode(0);
			// HSIZE.rand_mode(0);
			// HBURST.rand_mode(0);
			// HPROT.rand_mode(0);
			// HSEL.rand_mode(0);

			// HSEL = 1;
			HTRANS = 2'b10;
			// HSIZE = 3'b000;
			// HADDR = 32'h100;

		endfunction

	endclass: ahb_trans_test

	environment env;
	apb_trans_test test_apb;
	ahb_trans_test test_ahb;
	// coverage cov_bridge;

	initial
	begin
		env = new(apb_intf, ahb_intf);

		test_apb = new();
		test_ahb = new();

		env.gen.repeat_count = `NO_OF_TESTCASES;

		env.gen.trans_apb = test_apb;
		env.gen.trans_ahb = test_ahb;

		env.run();
	end

endprogram:test
