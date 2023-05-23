`include "coverage.sv"

class scoreboard;

	mailbox apbmon2scb;
	mailbox ahbmon2scb;
	coverage cov = new();

	int no_transactions;
  	int error_count = 0;
	bit [2:0] select;

	function new(mailbox apbmon2scb, mailbox ahbmon2scb);
		this.apbmon2scb = apbmon2scb;
		this.ahbmon2scb = ahbmon2scb;
	endfunction

  	task main();
		apb_trans trans_apb;
		ahb_trans trans_ahb;

		forever
		begin

			apbmon2scb.get(trans_apb);
			ahbmon2scb.get(trans_ahb);
			
			if(trans_apb.PADDR != trans_ahb.HADDR)
				ahbmon2scb.get(trans_ahb);
			begin
				$display("\n\n%0t\t\t\t[SCOREBOARD] %0d",$time ,no_transactions);
				if(trans_apb.PADDR == trans_ahb.HADDR)						//Error Checking for Address
				begin
					$display("[SCB-PASS]");
				end
				else
				begin
					$display("[SCB-FAIL]");
					error_count++;
				end
				$display("HADDR = 0x%0h, PADDR = 0x%0h",trans_ahb.HADDR ,trans_apb.PADDR);
				
				if(trans_apb.PWRITE == trans_ahb.HWRITE)					//Error Checking for HWRITE
				begin
					$display("[SCB-PASS]");
				end
				else
				begin
					$display("[SCB-FAIL]");
					error_count++;
				end
				$display("HWRITE = %0d, PWRITE = %0d",trans_ahb.HWRITE ,trans_apb.PWRITE);

				//Finding Slave number from PSEL
				foreach(trans_apb.PSEL[i])
					if(trans_apb.PSEL[i]==1)
						select = i;

				if(trans_apb.PWRITE == 0)											//Checking for Write/Read
				begin
					if(trans_apb.PRDATA[select] == trans_ahb.HRDATA)				//Error Checking for HDATA
						$display("[SCB-PASS]");
					else
					begin
						$display("[SCB-FAIL]");
						error_count++;
					end
					$display("HRDATA = 0x%0h, PRDATA = 0x%0h select = %0d",trans_ahb.HRDATA ,trans_apb.PRDATA[select],select);
				end
				else
				begin
					if(trans_apb.PWDATA == trans_ahb.HWDATA)						//Error Checking for HDATA
						$display("[SCB-PASS]");
					else
					begin
						$display("[SCB-FAIL]");
						error_count++;
					end
				$display("HWDATA = 0x%0h, PWDATA = 0x%0h select = %0d",trans_ahb.HWDATA ,trans_apb.PWDATA,select);
				end
				$display("%0t\t\t\t[SCOREBOARD] %0d\n\n",$time ,no_transactions);	//End of Scoreboard
				select = 0;															//Assigning select to 0, for it to assign in next cycle
				cov.sample(trans_apb,trans_ahb);
				no_transactions++;
			end
		end
	endtask

endclass
