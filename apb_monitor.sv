`define APB_MON_IF apb_vif.APB_MONITOR.apb_mon_cb

class apb_monitor;

	virtual apb_bridge_intf apb_vif;
	mailbox apbmon2scb;

	int no_transactions;

  	function new(virtual apb_bridge_intf apb_vif, mailbox apbmon2scb);
		this.apb_vif = apb_vif;
		this.apbmon2scb = apbmon2scb;
	endfunction

  	task main();
		apb_trans trans_apb;
		forever
		begin
			trans_apb = new();
			
			@(posedge apb_vif.APB_MONITOR.clock);						//At every posedge clock
			wait(`APB_MON_IF.PSEL);										//wait for any of the PSEL to be high

			@(posedge apb_vif.APB_MONITOR.clock);						//wait one more posedge clock for data transfer
			if(!`APB_MON_IF.PWRITE)										//If Read command
			repeat(3) @(posedge apb_vif.APB_MONITOR.clock);				//Wait for 3 cycles for the bridge to get the data

			trans_apb.PADDR 	= `APB_MON_IF.PADDR;					//Assigning data from the Interface to 
			trans_apb.PWDATA 	= `APB_MON_IF.PWDATA;					//the a transaction handle to send through mailbox
			trans_apb.PENABLE 	= `APB_MON_IF.PENABLE;
			trans_apb.PWRITE 	= `APB_MON_IF.PWRITE;
			trans_apb.PSEL 		= `APB_MON_IF.PSEL;
			trans_apb.PRDATA 	= `APB_MON_IF.PRDATA;
			trans_apb.PREADY	= `APB_MON_IF.PREADY;
			trans_apb.PSLVERR	= `APB_MON_IF.PSLVERR;
				
			apbmon2scb.put(trans_apb);									//Data sent to scoreboard through mailbox

			$display("%0t\t\t\t[APB MONITOR] %0d All Transactions sent to Scoreboard",$time,no_transactions);
			$display("Time PADDR PWDATA PSEL");
			$display("%0t   %0h    %0d  \t\t%0h",$time ,trans_apb.PADDR ,trans_apb.PWDATA ,trans_apb.PSEL);
			
			no_transactions++;
		end
	endtask: main
endclass: apb_monitor
