`define AHB_MON_IF ahb_vif.AHB_MONITOR.ahb_mon_cb

class ahb_monitor;

  virtual ahb_bridge_intf ahb_vif;
  mailbox ahbmon2scb;
  int no_transactions=0;
    

  function new( virtual ahb_bridge_intf ahb_vif, mailbox ahbmon2scb);

    this.ahb_vif    = ahb_vif;
    this.ahbmon2scb = ahbmon2scb; 
  endfunction

  task main();
    
    ahb_trans trans_ahb;

    forever
    begin

      @(posedge ahb_vif.AHB_MONITOR.clock);
      
      if(`AHB_MON_IF.HTRANS[1])
      begin
        trans_ahb = new();
        wait(`AHB_MON_IF.HREADY);
        trans_ahb.HADDR    = `AHB_MON_IF.HADDR;  
        trans_ahb.HTRANS   = `AHB_MON_IF.HTRANS; 
        trans_ahb.HWRITE    = `AHB_MON_IF.HWRITE; 
        trans_ahb.HSIZE     = `AHB_MON_IF.HSIZE;  
        trans_ahb.HBURST    = `AHB_MON_IF.HBURST; 
        trans_ahb.HPROT     = `AHB_MON_IF.HPROT;  
        trans_ahb.HSEL      = `AHB_MON_IF.HSEL;   
        trans_ahb.HREADY    = `AHB_MON_IF.HREADY;    
        trans_ahb.HRESP     = `AHB_MON_IF.HRESP;
        trans_ahb.HWDATA    = `AHB_MON_IF.HWDATA; 
        if(~`AHB_MON_IF.HWRITE)
        begin
            @(`AHB_MON_IF.HRDATA)
          trans_ahb.HRDATA    = `AHB_MON_IF.HRDATA;    
        end
        else
          @(posedge ahb_vif.AHB_MONITOR.clock);
        ahbmon2scb.put(trans_ahb);
        
        $display("%0t\t\t\t[AHB MONITOR] %0d All Transactions sent to Scoreboard",$time,no_transactions);
        $display("Time HADDR HTRANS HWRITE HSIZE HBURST HPROT HWDATA \tHSEL HRDATA HREADY HRESP");
        $display("%0t   %0h  \t %0d  \t  %0d   \t%0d  \t\t%0d    %0d  %0d   %0d   \t%0h    %0d    %0d",$time ,trans_ahb.HADDR ,trans_ahb.HTRANS ,trans_ahb.HWRITE ,trans_ahb.HSIZE ,trans_ahb.HBURST ,trans_ahb.HPROT ,trans_ahb.HWDATA ,trans_ahb.HSEL ,trans_ahb.HRDATA ,trans_ahb.HREADY ,trans_ahb.HRESP);
        
        no_transactions++;
      end
    end
  endtask: main
endclass: ahb_monitor
