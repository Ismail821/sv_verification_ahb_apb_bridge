`define NO_OF_SLAVES 8

interface apb_bridge_intf (input clock, reset);
    
  //Signals from Bridge to APB
  logic [31:0]    		PADDR;              // Address for the APB Slave
  logic [31:0]    		PWDATA;             // Write Data. write acces when pwdata is high and apb read access low
  logic           		PENABLE;            // indicates second and subsequent cycles of an APB transfer
  logic           		PWRITE;
  logic[`NO_OF_SLAVES-1:0] 	PSEL;

  //Signals from APB to Bridge
  logic [31:0]                PRDATA [`NO_OF_SLAVES-1:0];	//
  logic [`NO_OF_SLAVES-1:0]    PREADY;           		// A ready signal to indicate a completetion
  logic [`NO_OF_SLAVES-1:0]    PSLVERR;         		// A error signal to indicate a Failiure

  clocking apb_drv_cb @(posedge clock);

  default input #1 output #1;

    output PRDATA; 
    output PREADY;
    output PSLVERR;

    input PADDR;  
    input PWDATA; 
    input PENABLE;
    input PWRITE;
    input PSEL;
  endclocking: apb_drv_cb


  clocking apb_mon_cb @(posedge clock);

    default input #1 output #1;
      
    input PRDATA; 
    input PREADY;
    input PSLVERR;

    input PADDR;  
    input PWDATA; 
    input PENABLE;
    input PWRITE;
    input PSEL;
  endclocking: apb_mon_cb

  modport APB_DRIVER (clocking apb_drv_cb, input clock, reset);
  modport APB_MONITOR (clocking apb_mon_cb, input clock, reset);
endinterface: apb_bridge_intf