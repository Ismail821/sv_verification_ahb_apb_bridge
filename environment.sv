`include "apb_trans.sv"
`include "ahb_trans.sv"
`include "generator.sv"
`include "apb_driver.sv"
`include "ahb_driver.sv"
`include "apb_monitor.sv"
`include "ahb_monitor.sv"
`include "scoreboard.sv"


class environment;
	
	generator 	gen;
	apb_driver 	apb_driv;
	ahb_driver 	ahb_driv;
	apb_monitor apb_mon;
	ahb_monitor ahb_mon;
	scoreboard 	scb;

	//mailbox
	mailbox gen2apbdriv;
	mailbox gen2ahbdriv;
	mailbox apbmon2scb;
	mailbox ahbmon2scb;

	event gen_ended;

	virtual apb_bridge_intf apb_vif;
	virtual ahb_bridge_intf ahb_vif;

  function new(virtual apb_bridge_intf apb_vif, virtual ahb_bridge_intf ahb_vif);
	
		this.apb_vif = apb_vif;
		this.ahb_vif = ahb_vif;

		gen2apbdriv	=new();
		gen2ahbdriv	=new();
		apbmon2scb	=new();
		ahbmon2scb	=new();

		gen 	 = new(gen2apbdriv, gen2ahbdriv, gen_ended);		//generator needs two class to generate
		apb_driv = new(apb_vif, 	gen2apbdriv);					//driver needs the interface and mailbox to comm
		ahb_driv = new(ahb_vif, 	gen2ahbdriv);
		apb_mon  = new(apb_vif, 	apbmon2scb);
		ahb_mon  = new(ahb_vif, 	ahbmon2scb);
		scb		 = new(apbmon2scb, 	ahbmon2scb);
	endfunction

	task pre_test();
		fork
			apb_driv.reset();
			ahb_driv.reset();
        join
	endtask

	task test();

		fork
			gen.main();
			apb_driv.main();
			ahb_driv.main();
			apb_mon.main();
			ahb_mon.main();
			scb.main();
		join_none
	endtask: test

	task post_test();

		wait(gen_ended.triggered);
		wait(gen.repeat_count == apb_driv.no_transactions);
		wait(gen.repeat_count == ahb_driv.no_transactions);
 		wait(gen.repeat_count == scb.no_transactions);
		$display("\n%0t\t\t\t[ENVIRONMENT]\n post Test",$time);
		if(scb.error_count == 0)
			$display("%0t\t\t\t***TEST_PASS***",$time);
		else
			$display("%0t\t\t\t***TEST_FAILED with %0d errors***",$time,scb.error_count);
	endtask: post_test

	task run();

		pre_test();
		test();
		post_test();
		$finish;
	endtask: run

endclass: environment

