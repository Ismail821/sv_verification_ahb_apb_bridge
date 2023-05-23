class generator;

	rand apb_trans trans_apb, tr_apb;
	rand ahb_trans trans_ahb, tr_ahb;

	int repeat_count;

	mailbox gen2apbdriv;
	mailbox gen2ahbdriv;

	event ended;

	function new(mailbox gen2apbdriv, mailbox gen2ahbdriv, event ended);
		
		this.gen2apbdriv = gen2apbdriv;
		this.gen2ahbdriv = gen2ahbdriv;
		this.ended = ended;
		trans_apb = new();
		trans_ahb = new();
	endfunction

	task main();

		repeat(repeat_count)
		begin

			if(!trans_apb.randomize() || !trans_ahb.randomize())
				$fatal("%0t \t\t [GENERATOR] \n Transaction randomization failed",$time);
          	
			tr_apb = trans_apb.do_copy();
			tr_ahb = trans_ahb.do_copy();
			gen2apbdriv.put(tr_apb);
			gen2ahbdriv.put(tr_ahb);
		end
		-> ended;
	endtask: main
endclass: generator
