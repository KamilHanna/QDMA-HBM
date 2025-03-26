//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Wed Mar 26 16:44:57 2025
//Host        : ogreOptiPlex running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target qdma_hbm_bd_wrapper.bd
//Design      : qdma_hbm_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module qdma_hbm_bd_wrapper
   (S00_AXI_araddr_0,
    S00_AXI_arburst_0,
    S00_AXI_arcache_0,
    S00_AXI_arid_0,
    S00_AXI_arlen_0,
    S00_AXI_arlock_0,
    S00_AXI_arprot_0,
    S00_AXI_arqos_0,
    S00_AXI_arready_0,
    S00_AXI_arsize_0,
    S00_AXI_aruser_0,
    S00_AXI_arvalid_0,
    S00_AXI_awaddr_0,
    S00_AXI_awburst_0,
    S00_AXI_awcache_0,
    S00_AXI_awid_0,
    S00_AXI_awlen_0,
    S00_AXI_awlock_0,
    S00_AXI_awprot_0,
    S00_AXI_awqos_0,
    S00_AXI_awready_0,
    S00_AXI_awsize_0,
    S00_AXI_awuser_0,
    S00_AXI_awvalid_0,
    S00_AXI_bid_0,
    S00_AXI_bready_0,
    S00_AXI_bresp_0,
    S00_AXI_bvalid_0,
    S00_AXI_rdata_0,
    S00_AXI_rid_0,
    S00_AXI_rlast_0,
    S00_AXI_rready_0,
    S00_AXI_rresp_0,
    S00_AXI_rvalid_0,
    S00_AXI_wdata_0,
    S00_AXI_wlast_0,
    S00_AXI_wready_0,
    S00_AXI_wstrb_0,
    S00_AXI_wuser_0,
    S00_AXI_wvalid_0,
    aclk_0,
    aresetn,
    aresetn_0,
    hbm_clk_n,
    hbm_clk_p);
  input [63:0]S00_AXI_araddr_0;
  input [1:0]S00_AXI_arburst_0;
  input [3:0]S00_AXI_arcache_0;
  input [3:0]S00_AXI_arid_0;
  input [7:0]S00_AXI_arlen_0;
  input [0:0]S00_AXI_arlock_0;
  input [2:0]S00_AXI_arprot_0;
  input [3:0]S00_AXI_arqos_0;
  output S00_AXI_arready_0;
  input [2:0]S00_AXI_arsize_0;
  input [31:0]S00_AXI_aruser_0;
  input S00_AXI_arvalid_0;
  input [63:0]S00_AXI_awaddr_0;
  input [1:0]S00_AXI_awburst_0;
  input [3:0]S00_AXI_awcache_0;
  input [3:0]S00_AXI_awid_0;
  input [7:0]S00_AXI_awlen_0;
  input [0:0]S00_AXI_awlock_0;
  input [2:0]S00_AXI_awprot_0;
  input [3:0]S00_AXI_awqos_0;
  output S00_AXI_awready_0;
  input [2:0]S00_AXI_awsize_0;
  input [31:0]S00_AXI_awuser_0;
  input S00_AXI_awvalid_0;
  output [3:0]S00_AXI_bid_0;
  input S00_AXI_bready_0;
  output [1:0]S00_AXI_bresp_0;
  output S00_AXI_bvalid_0;
  output [511:0]S00_AXI_rdata_0;
  output [3:0]S00_AXI_rid_0;
  output S00_AXI_rlast_0;
  input S00_AXI_rready_0;
  output [1:0]S00_AXI_rresp_0;
  output S00_AXI_rvalid_0;
  input [511:0]S00_AXI_wdata_0;
  input S00_AXI_wlast_0;
  output S00_AXI_wready_0;
  input [63:0]S00_AXI_wstrb_0;
  input [63:0]S00_AXI_wuser_0;
  input S00_AXI_wvalid_0;
  input aclk_0;
  input aresetn;
  input aresetn_0;
  input hbm_clk_n;
  input hbm_clk_p;

  wire [63:0]S00_AXI_araddr_0;
  wire [1:0]S00_AXI_arburst_0;
  wire [3:0]S00_AXI_arcache_0;
  wire [3:0]S00_AXI_arid_0;
  wire [7:0]S00_AXI_arlen_0;
  wire [0:0]S00_AXI_arlock_0;
  wire [2:0]S00_AXI_arprot_0;
  wire [3:0]S00_AXI_arqos_0;
  wire S00_AXI_arready_0;
  wire [2:0]S00_AXI_arsize_0;
  wire [31:0]S00_AXI_aruser_0;
  wire S00_AXI_arvalid_0;
  wire [63:0]S00_AXI_awaddr_0;
  wire [1:0]S00_AXI_awburst_0;
  wire [3:0]S00_AXI_awcache_0;
  wire [3:0]S00_AXI_awid_0;
  wire [7:0]S00_AXI_awlen_0;
  wire [0:0]S00_AXI_awlock_0;
  wire [2:0]S00_AXI_awprot_0;
  wire [3:0]S00_AXI_awqos_0;
  wire S00_AXI_awready_0;
  wire [2:0]S00_AXI_awsize_0;
  wire [31:0]S00_AXI_awuser_0;
  wire S00_AXI_awvalid_0;
  wire [3:0]S00_AXI_bid_0;
  wire S00_AXI_bready_0;
  wire [1:0]S00_AXI_bresp_0;
  wire S00_AXI_bvalid_0;
  wire [511:0]S00_AXI_rdata_0;
  wire [3:0]S00_AXI_rid_0;
  wire S00_AXI_rlast_0;
  wire S00_AXI_rready_0;
  wire [1:0]S00_AXI_rresp_0;
  wire S00_AXI_rvalid_0;
  wire [511:0]S00_AXI_wdata_0;
  wire S00_AXI_wlast_0;
  wire S00_AXI_wready_0;
  wire [63:0]S00_AXI_wstrb_0;
  wire [63:0]S00_AXI_wuser_0;
  wire S00_AXI_wvalid_0;
  wire aclk_0;
  wire aresetn;
  wire aresetn_0;
  wire hbm_clk_n;
  wire hbm_clk_p;

  qdma_hbm_bd qdma_hbm_bd_i
       (.S00_AXI_araddr_0(S00_AXI_araddr_0),
        .S00_AXI_arburst_0(S00_AXI_arburst_0),
        .S00_AXI_arcache_0(S00_AXI_arcache_0),
        .S00_AXI_arid_0(S00_AXI_arid_0),
        .S00_AXI_arlen_0(S00_AXI_arlen_0),
        .S00_AXI_arlock_0(S00_AXI_arlock_0),
        .S00_AXI_arprot_0(S00_AXI_arprot_0),
        .S00_AXI_arqos_0(S00_AXI_arqos_0),
        .S00_AXI_arready_0(S00_AXI_arready_0),
        .S00_AXI_arsize_0(S00_AXI_arsize_0),
        .S00_AXI_aruser_0(S00_AXI_aruser_0),
        .S00_AXI_arvalid_0(S00_AXI_arvalid_0),
        .S00_AXI_awaddr_0(S00_AXI_awaddr_0),
        .S00_AXI_awburst_0(S00_AXI_awburst_0),
        .S00_AXI_awcache_0(S00_AXI_awcache_0),
        .S00_AXI_awid_0(S00_AXI_awid_0),
        .S00_AXI_awlen_0(S00_AXI_awlen_0),
        .S00_AXI_awlock_0(S00_AXI_awlock_0),
        .S00_AXI_awprot_0(S00_AXI_awprot_0),
        .S00_AXI_awqos_0(S00_AXI_awqos_0),
        .S00_AXI_awready_0(S00_AXI_awready_0),
        .S00_AXI_awsize_0(S00_AXI_awsize_0),
        .S00_AXI_awuser_0(S00_AXI_awuser_0),
        .S00_AXI_awvalid_0(S00_AXI_awvalid_0),
        .S00_AXI_bid_0(S00_AXI_bid_0),
        .S00_AXI_bready_0(S00_AXI_bready_0),
        .S00_AXI_bresp_0(S00_AXI_bresp_0),
        .S00_AXI_bvalid_0(S00_AXI_bvalid_0),
        .S00_AXI_rdata_0(S00_AXI_rdata_0),
        .S00_AXI_rid_0(S00_AXI_rid_0),
        .S00_AXI_rlast_0(S00_AXI_rlast_0),
        .S00_AXI_rready_0(S00_AXI_rready_0),
        .S00_AXI_rresp_0(S00_AXI_rresp_0),
        .S00_AXI_rvalid_0(S00_AXI_rvalid_0),
        .S00_AXI_wdata_0(S00_AXI_wdata_0),
        .S00_AXI_wlast_0(S00_AXI_wlast_0),
        .S00_AXI_wready_0(S00_AXI_wready_0),
        .S00_AXI_wstrb_0(S00_AXI_wstrb_0),
        .S00_AXI_wuser_0(S00_AXI_wuser_0),
        .S00_AXI_wvalid_0(S00_AXI_wvalid_0),
        .aclk_0(aclk_0),
        .aresetn(aresetn),
        .aresetn_0(aresetn_0),
        .hbm_clk_n(hbm_clk_n),
        .hbm_clk_p(hbm_clk_p));
endmodule
