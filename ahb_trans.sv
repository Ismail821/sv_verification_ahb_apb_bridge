
class ahb_trans;

    logic            HCLK;
    logic            HRESETn;
    rand bit [31:0]  HADDR;
    rand bit [ 1:0]  HTRANS;
    rand bit         HWRITE;
    randc bit [ 2:0] HSIZE;
    randc bit [ 2:0] HBURST;
    randc bit [ 3:0] HPROT;
    rand bit [31:0]  HWDATA;
    rand bit         HSEL;
         bit [31:0]  HRDATA;     // o/p signal received from bridge
         bit         HREADY;
         bit [ 1:0]  HRESP;
   

    constraint valid_size       {HSIZE inside {0,1,2};}
    constraint address_overflow {HADDR inside {[32'h000 :32'h7FF]};}
    constraint select_line_off  {HSEL  dist{1:=95, 0:=5};}

    function post_randomize();

      $display("\n%0t\t\t\t[AHB TRANS] Post randomization",$time);
      $display("%0t \tHADDR\t HWRITE\t HWDATA\t HRDATA\t\t HREADY\t HRESP\t",$time);
      $display("%0t   %h\t %d  %h\t %h\t %b\t\t %b\t\t\n",$time ,HADDR ,HWRITE ,HWDATA ,HRDATA  ,HREADY  ,HRESP);
	endfunction: post_randomize

    function ahb_trans do_copy;
    
        ahb_trans trans_ahb;
        trans_ahb = new();
        trans_ahb.HCLK      =this.HCLK;
        trans_ahb.HRESETn   =this.HRESETn;
        trans_ahb.HADDR     =this.HADDR;
        trans_ahb.HTRANS    =this.HTRANS;
        trans_ahb.HWRITE    =this.HWRITE;
        trans_ahb.HSIZE     =this.HSIZE;
        trans_ahb.HBURST    =this.HBURST;
        trans_ahb.HPROT     =this.HPROT;
        trans_ahb.HWDATA    =this.HWDATA;
        trans_ahb.HSEL      =this.HSEL;
        trans_ahb.HRDATA    =this.HRDATA;
        trans_ahb.HREADY    =this.HREADY;
        trans_ahb.HRESP     =this.HRESP;
        return trans_ahb;
    endfunction
endclass: ahb_trans
