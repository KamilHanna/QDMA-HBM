`timescale 1ns / 1ps

module top
   (aresetn,
    hbm_clk_n,
    hbm_clk_p,
    pci_express_x16_rxn,
    pci_express_x16_rxp,
    pci_express_x16_txn,
    pci_express_x16_txp,
    qdma_clk_p,
    qdma_clk_n);
  
  input  logic aresetn; // active-low asynchronous reset signal (n : negative logic)
  
  //differential clocking for HBM (noise resistance, single integrity, improved performance)
  //HBM can transfer/read data on both rising and falling edges of a clock, similar to how a DDR works.
  // (maximizes bandwidth)
  input  logic hbm_clk_n; // clock signal for HBM _n for negative
  input  logic hbm_clk_p; // clock signal for HBM _p for positive
  
  //PCI Express input signals (Receiver lines; 16 pairs for the 16 lanes of PCIe BUS)
  input  logic [15:0]pci_express_x16_rxn;
  input  logic [15:0]pci_express_x16_rxp;
  
  //PCI Express output signals (Transmitter lines; 16 pairs for the 16 lanes of the PCIe BUS)
  output logic  [15:0]pci_express_x16_txn;
  output logic  [15:0]pci_express_x16_txp;
  
  //differential clocking for QDMA (Also uses double data rate DDR, similar to HBM).
  input  logic qdma_clk_p;
  input  logic qdma_clk_n;
  
  //-----------------------------
  //Internal signals.
  //-----------------------------
  // Processed clock signals derived from qdma_clk_p and qdma_clk_n inputs.
  /* The IBUFDS_GTE4 instance creates the clock signals qdma_clk and qdma_clk_gt
     by buffering and dividing the incoming differential clock. */ 
  // These signals are used in the qdma_hbm_qd instance
   
  logic qdma_clk; // primary clock output maintains same frequency as input differential clock
  logic qdma_clk_gt; // divided-by-2 version of the clock (halves clock frequency).
  
  //aresetn_buf: This is the buffered version of the aresetn signal.
  //It is generated using the IBUF (Input Buffer) to ensure signal integrity.
  logic aresetn_buf;

  // QDMA does not work without these. User guide does not say why.
  // You can find these instantiations in the QDMA example project.
  // Use also the relative constraints.

  // Generating QDMA clock signals
  /*IBUFDS_GTE4: This is a differential clock buffer that takes the differential 
    QDMA clock input (qdma_clk_p and qdma_clk_n) and generates two output clock signals:
    qdma_clk_gt and qdma_clk (divided clock).*/
  // Ref clock buffer
  IBUFDS_GTE4 # (.REFCLK_HROW_CK_SEL(2'b00)) refclk_ibuf (.O(qdma_clk_gt), .ODIV2(qdma_clk), .I(qdma_clk_p), .CEB(1'b0), .IB(qdma_clk_n));
  
  // Reset buffer
  //IBUF: This buffers the aresetn signal, improving signal quality. (Strength, filtering, standardization).
  IBUF   sys_reset_n_ibuf (.O(aresetn_buf), .I(aresetn));

 //Instantiating the qdma_hbm_bd module as i_hbm_interface
  qdma_hbm_bd i_hbm_interface
       (.aresetn(aresetn),
        .hbm_clk_n(hbm_clk_n),
        .hbm_clk_p(hbm_clk_p),
        .pci_express_x16_rxn(pci_express_x16_rxn),
        .pci_express_x16_rxp(pci_express_x16_rxp),
        .pci_express_x16_txn(pci_express_x16_txn),
        .pci_express_x16_txp(pci_express_x16_txp),
        .qdma_clk(qdma_clk),
        .qdma_clk_gt(qdma_clk_gt));
endmodule




