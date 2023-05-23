`define AHB_DRIV_IF ahb_vif.AHB_DRIVER.ahb_drv_cb
                //interface->modport-> clocking block

class ahb_driver;

  int no_transactions;
  
  virtual ahb_bridge_intf ahb_vif;

  mailbox gen2ahbdriv;

  ahb_trans trans_ahb;


  static bit [31:0] prev_HWDATA;
  static bit prev_trans;

  function new(virtual ahb_bridge_intf ahb_vif, mailbox gen2ahbdriv);

    this.ahb_vif = ahb_vif;
    this.gen2ahbdriv    = gen2ahbdriv;
  endfunction:new

  task reset();                               // Reset task to assign 
  
    wait(!ahb_vif.reset)                      // ! used because the AHB2APB Bridge acts on a negative logic
    
    $display("%0t\t\t\t[AHB DRIVER] \tReset Started",$time);
    `AHB_DRIV_IF.HADDR  <= 32'b0;
    `AHB_DRIV_IF.HTRANS <= 02'b0;
    `AHB_DRIV_IF.HWRITE <= 32'b0;
    `AHB_DRIV_IF.HSIZE  <= 03'b0;
    `AHB_DRIV_IF.HBURST <= 03'b0;
    `AHB_DRIV_IF.HPROT  <= 01'b0;
    `AHB_DRIV_IF.HWDATA <= 32'b0;
    `AHB_DRIV_IF.HSEL   <= 01'b0;

    wait(ahb_vif.reset)

    $display("%0t\t\t\t[AHB DRIVER] \tReset Ended",$time);
  endtask: reset

  task drive();
    
    if(!`AHB_DRIV_IF.HRESP)                     //Checking for HRESP, which tell the status of the bridge
    begin
      `AHB_DRIV_IF.HADDR   <= trans_ahb.HTRANS!=2'b00 ? (`AHB_DRIV_IF.HTRANS== 2'b01 ? `AHB_DRIV_IF.HADDR : trans_ahb.HADDR)  : 32'b0;
      `AHB_DRIV_IF.HTRANS  <= trans_ahb.HTRANS!=2'b00 ? trans_ahb.HTRANS : 02'b0;
      `AHB_DRIV_IF.HWRITE  <=                           trans_ahb.HWRITE;
      `AHB_DRIV_IF.HSIZE   <= trans_ahb.HTRANS!=2'b00 ? trans_ahb.HSIZE  : 03'b0;
      `AHB_DRIV_IF.HBURST  <= trans_ahb.HTRANS!=2'b00 ? trans_ahb.HBURST : 03'b0;
      `AHB_DRIV_IF.HPROT   <= trans_ahb.HTRANS!=2'b00 ? trans_ahb.HPROT  : 01'b0;
      `AHB_DRIV_IF.HSEL    <= trans_ahb.HTRANS!=2'b00 ? trans_ahb.HSEL   : 32'b0;
      `AHB_DRIV_IF.HWDATA  <= trans_ahb.HWRITE        ? trans_ahb.HWDATA : 32'b0;
      prev_trans           <= `AHB_DRIV_IF.HTRANS[1];

      @(posedge ahb_vif.AHB_DRIVER.clock);
      if(trans_ahb.HWRITE == 0)                           //Wait for 3 cycles for data arrival from APB
        repeat(3)
          @(posedge ahb_vif.AHB_DRIVER.clock);
      $display("\n%0t\t\t\t[AHB DRIVER] Driven Values are",$time);
      $display("%0t \tHADDR\t HWRITE\t HWDATA\t HRDATA\t\t HREADY\t HRESP\t",$time);
      $display("%0t   %h\t %0h  0x%0h\t %h\t %b\t\t %b\t\t\n",$time ,trans_ahb.HADDR ,trans_ahb.HWRITE ,trans_ahb.HWDATA ,trans_ahb.HRDATA  ,trans_ahb.HREADY  ,trans_ahb.HRESP);
    end

    else                                                //Allowing to change Address if Error statement
    begin
      $display("%0t\t\t\t[AHB_DRIVER] %0d ERROR: HRESP = 1. Waiting for Address change",$time ,no_transactions);
      if(!`AHB_DRIV_IF.HREADY)
        `AHB_DRIV_IF.HADDR   <= trans_ahb.HADDR;
    end
  endtask: drive


  task main();
    forever
    begin
      gen2ahbdriv.get(trans_ahb);
      @(posedge ahb_vif.AHB_MONITOR.clock);	            //To sample at every pos edge clock
      drive();
      no_transactions++;
    end
  endtask: main
endclass: ahb_driver
