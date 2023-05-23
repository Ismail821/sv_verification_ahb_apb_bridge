`define NO_OF_SLAVES 8

class apb_trans;

			bit [31:0]				PADDR;
			bit [31:0]				PWDATA;
			bit 					PENABLE;
			bit						PWRITE;
  			bit [`NO_OF_SLAVES-1:0]	PSEL;
  	rand	bit [31:0]				PRDATA[`NO_OF_SLAVES-1:0];
 	rand	bit [`NO_OF_SLAVES-1:0]	PREADY;
  	rand 	bit [`NO_OF_SLAVES-1:0]	PSLVERR;

  	constraint error_signal 	{PSLVERR dist {0:=90, 1:=10};}

	function post_randomize();
	
		$display("\n%0t\t\t\t[APB TRANS] post randomization",$time);
		$display("%0t\t PADDR\t PWDATA\t PENABLE\t PWRITE\t PSEL\t PREADY\t PSLVERR\t",$time);
		$display("%0t\t\t %0h\t\t %0h\t\t %0b\t\t %0b\t\t %0d\t\t %0d\t\t %0d\t\t \n",$time, PADDR, PWDATA, PENABLE, PWRITE, PSEL, PREADY, PSLVERR);
	endfunction: post_randomize

	function apb_trans do_copy();

		apb_trans trans_apb;
		trans_apb = new();
		trans_apb.PADDR 	= this.PADDR;
		trans_apb.PWDATA 	= this.PWDATA;
		trans_apb.PENABLE 	= this.PENABLE;
		trans_apb.PWRITE 	= this.PWRITE;
		trans_apb.PSEL 		= this.PSEL;
		trans_apb.PRDATA 	= this.PRDATA;
		trans_apb.PREADY 	= this.PREADY;
		trans_apb.PSLVERR 	= this.PSLVERR;
		return trans_apb;
	endfunction
endclass: apb_trans
