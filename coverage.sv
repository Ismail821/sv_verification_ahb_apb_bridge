//`include "apb_trans.sv"
//`include "ahb_trans.sv"


class coverage;

    apb_trans trans_apb_cov;
    ahb_trans trans_ahb_cov;


    covergroup apb_coverage;
        address: coverpoint trans_apb_cov.PADDR{bins first      = {[32'h000:32'h0FF]}; 
                                            bins second     = {[32'h000:32'h0FF]};
                                            bins third      = {[32'h000:32'h0FF]};
                                            bins forth      = {[32'h000:32'h0FF]};
                                            bins fifth      = {[32'h000:32'h0FF]};
                                            bins sixth      = {[32'h000:32'h0FF]};
                                            bins seventh    = {[32'h000:32'h0FF]};
                                            bins eighth     = {[32'h000:32'h0FF]};
                                                }

        select: coverpoint trans_apb_cov.PSEL { bins first      = {8'b00000001};
                                            bins second     = {8'b00000010};
                                            bins third      = {8'b00000100};
                                            bins forth      = {8'b00001000};
                                            bins fifth      = {8'b00010000};
                                            bins sixth      = {8'b00100000};
                                            bins seventh    = {8'b01000000};
                                            bins eighth     = {8'b10000000};
                                            }

        write: coverpoint trans_apb_cov.PWRITE;

        all_cross: cross address,write;
    endgroup: apb_coverage

    covergroup ahb_coverage;

    address: coverpoint trans_ahb_cov.HADDR{bins first      = {[32'h000:32'h0FF]}; 
                                        bins second     = {[32'h000:32'h0FF]};
                                        bins third      = {[32'h000:32'h0FF]};
                                        bins forth      = {[32'h000:32'h0FF]};
                                        bins fifth      = {[32'h000:32'h0FF]};
                                        bins sixth      = {[32'h000:32'h0FF]};
                                        bins seventh    = {[32'h000:32'h0FF]};
                                        bins eighth     = {[32'h000:32'h0FF]};
                                            }
    
    write: coverpoint trans_ahb_cov.HWRITE;

    all_cross: cross address,write;

    endgroup: ahb_coverage


    function new();
        apb_coverage = new();
        ahb_coverage = new();
    endfunction

    task sample(apb_trans trans_apb_cov, ahb_trans trans_ahb_cov);
        this.trans_apb_cov = trans_apb_cov;
        this.trans_ahb_cov = trans_ahb_cov;
        apb_coverage.sample();
        ahb_coverage.sample();
    endtask



endclass: coverage
