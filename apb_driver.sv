`define APB_DRIV_IF apb_vif.APB_DRIVER.apb_drv_cb
                    //interface  ->modport -> clocking block
class apb_driver;

  int no_transactions;
  
  virtual apb_bridge_intf apb_vif;

  mailbox gen2apbdriv;

  apb_trans trans_apb;

  static bit [31:0] prev_PRDATA;

  function new(virtual apb_bridge_intf apb_vif, mailbox gen2apbdriv);

    this.apb_vif = apb_vif;
    this.gen2apbdriv    = gen2apbdriv;

  endfunction:new

  task reset();

    wait(!apb_vif.reset)             //!used because the AHB2APB Bridge acts on a negative logic
    $display("\n%0t\t\t\t[APB_DRIVER] \tReset Started ",$time);
    `APB_DRIV_IF.PRDATA  <= {0,0,0,0,0,0,0,0};
    `APB_DRIV_IF.PREADY  <= 0;
    `APB_DRIV_IF.PSLVERR <= 0;
      
    wait(apb_vif.reset)
      $display("%0t\t\t\t[APB_DRIVER] \tReset Ended",$time);
  endtask: reset

  task drive();
    
    @(posedge apb_vif.APB_DRIVER.clock)
    if(|(`APB_DRIV_IF.PSEL))
    begin
      gen2apbdriv.get(trans_apb);
      `APB_DRIV_IF.PRDATA     <= `APB_DRIV_IF.PWRITE ? {32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0,32'b0} : trans_apb.PRDATA; //Assigning 0 during Write Condition.
      `APB_DRIV_IF.PSLVERR    <= trans_apb.PSLVERR;
      `APB_DRIV_IF.PREADY 	  <= trans_apb.PREADY;	
      no_transactions++;

      $display("%0t\t\t\t[APB DRIVER] %0d Driven Values are",$time,no_transactions);
      $display("%0t\t PADDR\t PWDATA\t PENABLE\t PWRITE\t PSEL\t PREADY\t PSLVERR\t",$time);
      $display("%0t\t\t 0x%0h\t\t %0h\t\t %0b\t\t %0b\t\t %0d\t\t %0d\t\t %0d\t\t \n",$time, trans_apb.PADDR, trans_apb.PWDATA, trans_apb.PENABLE, trans_apb.PWRITE, trans_apb.PSEL, trans_apb.PREADY, trans_apb.PSLVERR);  

      end
  endtask: drive

  task main();
    $display("APB Driver:main");
    `APB_DRIV_IF.PREADY <= 8'hFF;
    forever
    begin
      drive();
    end
  endtask: main
endclass: apb_driver
