interface ahb_bridge_intf (input clock, reset);
    
    //Signals from AHB to bridge
    logic           HCLK;               // Host Clock (AHB Side)
    logic           HRESETn;            // Reset
    logic [31:0]    HADDR;              // Host address
    logic [1:0]     HTRANS;             // Host Transmission mode
    logic           HWRITE;             // Host indicating Write or Read
    logic [2:0]     HSIZE;              // Host indicating the size of transfer
    logic [2:0]     HBURST;             // Host indicating BURST transfer protocol
    logic [3:0]     HPROT;              // Protection signal to have secure/non-secure signal transfer
    logic [31:0]    HWDATA;             // Write data sent to the bridge
    logic           HSEL;               // Subordinate Select line 
    
    //Signals from bridge to AHB
    logic [31:0]    HRDATA;             // Data given out
    logic           HREADY;             // Ready signal
    logic [1:0]     HRESP;              // Response signal

  clocking ahb_drv_cb @(posedge clock);
        default input #1 output #1;                 //No idea Why its done
        input HRDATA;
        input HREADY;
        input HRESP;

        output HADDR;  
        output HTRANS; 
        output HWRITE; 
        output HSIZE;  
        output HBURST; 
        output HPROT;  
        output HWDATA; 
        output HSEL;
    endclocking: ahb_drv_cb

    clocking ahb_mon_cb @(posedge clock);
        default input #1 output #1;                 //No idea Why its done
        input HADDR;                                //taking all the Values as input because we want to view all the
        input HTRANS;                               //signals as data
        input HWRITE; 
        input HSIZE;  
        input HBURST; 
        input HPROT;  
        input HWDATA; 
        input HSEL;
        input HRDATA;
        input HREADY;
        input HRESP; 
    endclocking: ahb_mon_cb

    modport AHB_DRIVER  (clocking ahb_drv_cb, input clock, reset);
    modport AHB_MONITOR (clocking ahb_mon_cb, input clock, reset);
endinterface:ahb_bridge_intf
