`timescale 1ns / 1ps

module top
   (input logic aresetn, // clk wiz, proc_sys_reset_0
    input logic aresetn_0, // hbm, smart connect
    input logic aclk_0,
    input logic hbm_clk_n,
    input logic hbm_clk_p,
    input logic [3:0] S00_AXI_awid_0,
    input logic [63:0] S00_AXI_awaddr_0,
    input logic [7:0] S00_AXI_awlen_0,
    input logic [2:0]S00_AXI_awsize_0,
    input logic [1:0]S00_AXI_awburst_0,
    input logic S00_AXI_awlock_0,
    input logic [3:0]S00_AXI_awcache_0,
    input logic [2:0]S00_AXI_awprot_0,
    input logic [3:0]S00_AXI_awqos_0,
    input logic [31:0] S00_AXI_awuser_0,
    input logic S00_AXI_awvalid_0,
    input logic [511:0] S00_AXI_wdata_0,
    input logic [63:0] S00_AXI_wstrb_0,
    input logic S00_AXI_wlast_0,
    input logic [63:0] S00_AXI_wuser_0,
    input logic S00_AXI_wvalid_0,
    input logic S00_AXI_bready_0,
    input logic [3:0] S00_AXI_arid_0,
    input logic [63:0] S00_AXI_araddr_0,
    input logic [7:0] S00_AXI_arlen_0,
    input logic [2:0]S00_AXI_arsize_0,
    input logic [1:0]S00_AXI_arburst_0,
    input logic S00_AXI_arlock_0,
    input logic [3:0]S00_AXI_arcache_0,
    input logic [2:0]S00_AXI_arprot_0,
    input logic [3:0]S00_AXI_arqos_0,
    input logic [31:0] S00_AXI_aruser_0,
    input logic S00_AXI_arvalid_0,
    input logic S00_AXI_rready_0,
    output logic S00_AXI_awready_0,
    output logic S00_AXI_wready_0,
    output logic [3:0] S00_AXI_bid_0,
    output logic [1:0]S00_AXI_bresp_0,
    output logic S00_AXI_bvalid_0,
    output logic S00_AXI_arready_0,
    output logic [3:0] S00_AXI_rid_0,
    output logic [511:0] S00_AXI_rdata_0,
    output logic [1:0]S00_AXI_rresp_0,
    output logic S00_AXI_rlast_0,
    output logic S00_AXI_rvalid_0
);
  

  logic aresetn_buf;
  // Reset buffer
  //IBUF: This buffers the aresetn signal, improving signal quality. (Strength, filtering, standardization).
  IBUF   sys_reset_n_ibuf (.O(aresetn_buf), .I(aresetn));

 //Instantiating the qdma_hbm_bd module as i_hbm_interface
  qdma_hbm_bd i_hbm_interface
       (.aresetn(aresetn),
        .aresetn_0(aresetn_0),
        .aclk_0(aclk_0),
        .hbm_clk_n(hbm_clk_n),
        .hbm_clk_p(hbm_clk_p),
        .S00_AXI_awid_0(S00_AXI_awid_0),
        .S00_AXI_awaddr_0(S00_AXI_awaddr_0),
        .S00_AXI_awlen_0(S00_AXI_awlen_0),
        .S00_AXI_awsize_0(S00_AXI_awsize_0),
        .S00_AXI_awburst_0(S00_AXI_awburst_0),
        .S00_AXI_awlock_0(S00_AXI_awlock_0),
        .S00_AXI_awcache_0(S00_AXI_awcache_0),
        .S00_AXI_awprot_0(S00_AXI_awprot_0),
        .S00_AXI_awqos_0(S00_AXI_awqos_0),
        .S00_AXI_awuser_0(S00_AXI_awuser_0),
        .S00_AXI_awvalid_0(S00_AXI_awvalid_0),
        .S00_AXI_wdata_0(S00_AXI_wdata_0),
        .S00_AXI_wstrb_0(S00_AXI_wstrb_0),
        .S00_AXI_wlast_0(S00_AXI_wlast_0),
        .S00_AXI_wuser_0(S00_AXI_wuser_0),
        .S00_AXI_wvalid_0(S00_AXI_wvalid_0),
        .S00_AXI_bready_0(S00_AXI_bready_0),
        .S00_AXI_arid_0(S00_AXI_arid_0),
        .S00_AXI_araddr_0(S00_AXI_araddr_0),
        .S00_AXI_arlen_0(S00_AXI_arlen_0),
        .S00_AXI_arsize_0(S00_AXI_arsize_0),
        .S00_AXI_arburst_0(S00_AXI_arburst_0),
        .S00_AXI_arlock_0(S00_AXI_arlock_0),
        .S00_AXI_arcache_0(S00_AXI_arcache_0),
        .S00_AXI_arprot_0(S00_AXI_arprot_0),
        .S00_AXI_arqos_0(S00_AXI_arqos_0),
        .S00_AXI_aruser_0(S00_AXI_aruser_0),
        .S00_AXI_arvalid_0(S00_AXI_arvalid_0),
        .S00_AXI_rready_0(S00_AXI_rready_0),
        .S00_AXI_awready_0(S00_AXI_awready_0),
        .S00_AXI_wready_0(S00_AXI_wready_0),
        .S00_AXI_bid_0(S00_AXI_bid_0),
        .S00_AXI_bresp_0(S00_AXI_bresp_0),
        .S00_AXI_bvalid_0(S00_AXI_bvalid_0),
        .S00_AXI_arready_0(S00_AXI_arready_0),
        .S00_AXI_rid_0(S00_AXI_rid_0),
        .S00_AXI_rdata_0(S00_AXI_rdata_0),
        .S00_AXI_rresp_0(S00_AXI_rresp_0),
        .S00_AXI_rlast_0(S00_AXI_rlast_0),
        .S00_AXI_rvalid_0(S00_AXI_rvalid_0)
      );
endmodule






