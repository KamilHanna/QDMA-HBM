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
  
  input  logic aresetn;
  input  logic hbm_clk_n;
  input  logic hbm_clk_p;
  input  logic [15:0]pci_express_x16_rxn;
  input  logic [15:0]pci_express_x16_rxp;
  output logic  [15:0]pci_express_x16_txn;
  output logic  [15:0]pci_express_x16_txp;
  input  logic qdma_clk_p;
  input  logic qdma_clk_n;
  
  logic qdma_clk;
  logic qdma_clk_gt;
  logic aresetn_buf;

  // QDMA does not work without these. User guide does not say why.
  // You can find these instantiations in the QDMA example project.
  // Use also the relative constraints.

  // Ref clock buffer
  IBUFDS_GTE4 # (.REFCLK_HROW_CK_SEL(2'b00)) refclk_ibuf (.O(qdma_clk_gt), .ODIV2(qdma_clk), .I(qdma_clk_p), .CEB(1'b0), .IB(qdma_clk_n));
  // Reset buffer
  IBUF   sys_reset_n_ibuf (.O(aresetn_buf), .I(aresetn));

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




