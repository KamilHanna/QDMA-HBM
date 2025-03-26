//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Wed Mar 26 16:44:57 2025
//Host        : ogreOptiPlex running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target qdma_hbm_bd.bd
//Design      : qdma_hbm_bd
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "qdma_hbm_bd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=qdma_hbm_bd,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "qdma_hbm_bd.hwdef" *) 
module qdma_hbm_bd
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK_0, CLK_DOMAIN qdma_hbm_bd_aclk_0, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input aresetn_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HBM_CLK_N CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HBM_CLK_N, CLK_DOMAIN qdma_hbm_bd_hbm_clk_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input hbm_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HBM_CLK_P CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HBM_CLK_P, CLK_DOMAIN qdma_hbm_bd_hbm_clk_p, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input hbm_clk_p;

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
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_locked;
  wire hbm_clk_n;
  wire hbm_clk_p;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire [33:0]smartconnect_0_M00_AXI_ARADDR;
  wire [1:0]smartconnect_0_M00_AXI_ARBURST;
  wire [3:0]smartconnect_0_M00_AXI_ARLEN;
  wire smartconnect_0_M00_AXI_ARREADY;
  wire [2:0]smartconnect_0_M00_AXI_ARSIZE;
  wire smartconnect_0_M00_AXI_ARVALID;
  wire [33:0]smartconnect_0_M00_AXI_AWADDR;
  wire [1:0]smartconnect_0_M00_AXI_AWBURST;
  wire [3:0]smartconnect_0_M00_AXI_AWLEN;
  wire smartconnect_0_M00_AXI_AWREADY;
  wire [2:0]smartconnect_0_M00_AXI_AWSIZE;
  wire smartconnect_0_M00_AXI_AWVALID;
  wire smartconnect_0_M00_AXI_BREADY;
  wire [1:0]smartconnect_0_M00_AXI_BRESP;
  wire smartconnect_0_M00_AXI_BVALID;
  wire [255:0]smartconnect_0_M00_AXI_RDATA;
  wire smartconnect_0_M00_AXI_RLAST;
  wire smartconnect_0_M00_AXI_RREADY;
  wire [1:0]smartconnect_0_M00_AXI_RRESP;
  wire smartconnect_0_M00_AXI_RVALID;
  wire [255:0]smartconnect_0_M00_AXI_WDATA;
  wire smartconnect_0_M00_AXI_WLAST;
  wire smartconnect_0_M00_AXI_WREADY;
  wire [31:0]smartconnect_0_M00_AXI_WSTRB;
  wire smartconnect_0_M00_AXI_WVALID;
  wire [33:0]smartconnect_0_M01_AXI_ARADDR;
  wire [1:0]smartconnect_0_M01_AXI_ARBURST;
  wire [3:0]smartconnect_0_M01_AXI_ARLEN;
  wire smartconnect_0_M01_AXI_ARREADY;
  wire [2:0]smartconnect_0_M01_AXI_ARSIZE;
  wire smartconnect_0_M01_AXI_ARVALID;
  wire [33:0]smartconnect_0_M01_AXI_AWADDR;
  wire [1:0]smartconnect_0_M01_AXI_AWBURST;
  wire [3:0]smartconnect_0_M01_AXI_AWLEN;
  wire smartconnect_0_M01_AXI_AWREADY;
  wire [2:0]smartconnect_0_M01_AXI_AWSIZE;
  wire smartconnect_0_M01_AXI_AWVALID;
  wire smartconnect_0_M01_AXI_BREADY;
  wire [1:0]smartconnect_0_M01_AXI_BRESP;
  wire smartconnect_0_M01_AXI_BVALID;
  wire [255:0]smartconnect_0_M01_AXI_RDATA;
  wire smartconnect_0_M01_AXI_RLAST;
  wire smartconnect_0_M01_AXI_RREADY;
  wire [1:0]smartconnect_0_M01_AXI_RRESP;
  wire smartconnect_0_M01_AXI_RVALID;
  wire [255:0]smartconnect_0_M01_AXI_WDATA;
  wire smartconnect_0_M01_AXI_WLAST;
  wire smartconnect_0_M01_AXI_WREADY;
  wire [31:0]smartconnect_0_M01_AXI_WSTRB;
  wire smartconnect_0_M01_AXI_WVALID;
  wire NLW_hbm_0_DRAM_0_STAT_CATTRIP_UNCONNECTED;
  wire NLW_hbm_0_DRAM_1_STAT_CATTRIP_UNCONNECTED;
  wire NLW_hbm_0_apb_complete_0_UNCONNECTED;
  wire NLW_hbm_0_apb_complete_1_UNCONNECTED;
  wire [5:0]NLW_hbm_0_AXI_15_BID_UNCONNECTED;
  wire [31:0]NLW_hbm_0_AXI_15_RDATA_PARITY_UNCONNECTED;
  wire [5:0]NLW_hbm_0_AXI_15_RID_UNCONNECTED;
  wire [5:0]NLW_hbm_0_AXI_16_BID_UNCONNECTED;
  wire [31:0]NLW_hbm_0_AXI_16_RDATA_PARITY_UNCONNECTED;
  wire [5:0]NLW_hbm_0_AXI_16_RID_UNCONNECTED;
  wire [6:0]NLW_hbm_0_DRAM_0_STAT_TEMP_UNCONNECTED;
  wire [6:0]NLW_hbm_0_DRAM_1_STAT_TEMP_UNCONNECTED;
  wire NLW_proc_sys_reset_0_mb_reset_UNCONNECTED;
  wire [0:0]NLW_proc_sys_reset_0_bus_struct_reset_UNCONNECTED;
  wire [0:0]NLW_proc_sys_reset_0_interconnect_aresetn_UNCONNECTED;
  wire [0:0]NLW_proc_sys_reset_0_peripheral_reset_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M00_AXI_arcache_UNCONNECTED;
  wire [1:0]NLW_smartconnect_0_M00_AXI_arlock_UNCONNECTED;
  wire [2:0]NLW_smartconnect_0_M00_AXI_arprot_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M00_AXI_arqos_UNCONNECTED;
  wire [31:0]NLW_smartconnect_0_M00_AXI_aruser_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M00_AXI_awcache_UNCONNECTED;
  wire [1:0]NLW_smartconnect_0_M00_AXI_awlock_UNCONNECTED;
  wire [2:0]NLW_smartconnect_0_M00_AXI_awprot_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M00_AXI_awqos_UNCONNECTED;
  wire [31:0]NLW_smartconnect_0_M00_AXI_awuser_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M01_AXI_arcache_UNCONNECTED;
  wire [1:0]NLW_smartconnect_0_M01_AXI_arlock_UNCONNECTED;
  wire [2:0]NLW_smartconnect_0_M01_AXI_arprot_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M01_AXI_arqos_UNCONNECTED;
  wire [31:0]NLW_smartconnect_0_M01_AXI_aruser_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M01_AXI_awcache_UNCONNECTED;
  wire [1:0]NLW_smartconnect_0_M01_AXI_awlock_UNCONNECTED;
  wire [2:0]NLW_smartconnect_0_M01_AXI_awprot_UNCONNECTED;
  wire [3:0]NLW_smartconnect_0_M01_AXI_awqos_UNCONNECTED;
  wire [31:0]NLW_smartconnect_0_M01_AXI_awuser_UNCONNECTED;

  qdma_hbm_bd_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(hbm_clk_n),
        .clk_in1_p(hbm_clk_p),
        .clk_out1(clk_wiz_0_clk_out1),
        .locked(clk_wiz_0_locked),
        .resetn(aresetn));
  qdma_hbm_bd_hbm_0_0 hbm_0
       (.APB_0_PCLK(clk_wiz_0_clk_out1),
        .APB_0_PRESET_N(proc_sys_reset_0_peripheral_aresetn),
        .APB_1_PCLK(clk_wiz_0_clk_out1),
        .APB_1_PRESET_N(proc_sys_reset_0_peripheral_aresetn),
        .AXI_15_ACLK(aclk_0),
        .AXI_15_ARADDR(smartconnect_0_M00_AXI_ARADDR),
        .AXI_15_ARBURST(smartconnect_0_M00_AXI_ARBURST),
        .AXI_15_ARESET_N(aresetn_0),
        .AXI_15_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_15_ARLEN(smartconnect_0_M00_AXI_ARLEN),
        .AXI_15_ARREADY(smartconnect_0_M00_AXI_ARREADY),
        .AXI_15_ARSIZE(smartconnect_0_M00_AXI_ARSIZE),
        .AXI_15_ARVALID(smartconnect_0_M00_AXI_ARVALID),
        .AXI_15_AWADDR(smartconnect_0_M00_AXI_AWADDR),
        .AXI_15_AWBURST(smartconnect_0_M00_AXI_AWBURST),
        .AXI_15_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_15_AWLEN(smartconnect_0_M00_AXI_AWLEN),
        .AXI_15_AWREADY(smartconnect_0_M00_AXI_AWREADY),
        .AXI_15_AWSIZE(smartconnect_0_M00_AXI_AWSIZE),
        .AXI_15_AWVALID(smartconnect_0_M00_AXI_AWVALID),
        .AXI_15_BREADY(smartconnect_0_M00_AXI_BREADY),
        .AXI_15_BRESP(smartconnect_0_M00_AXI_BRESP),
        .AXI_15_BVALID(smartconnect_0_M00_AXI_BVALID),
        .AXI_15_RDATA(smartconnect_0_M00_AXI_RDATA),
        .AXI_15_RLAST(smartconnect_0_M00_AXI_RLAST),
        .AXI_15_RREADY(smartconnect_0_M00_AXI_RREADY),
        .AXI_15_RRESP(smartconnect_0_M00_AXI_RRESP),
        .AXI_15_RVALID(smartconnect_0_M00_AXI_RVALID),
        .AXI_15_WDATA(smartconnect_0_M00_AXI_WDATA),
        .AXI_15_WDATA_PARITY({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_15_WLAST(smartconnect_0_M00_AXI_WLAST),
        .AXI_15_WREADY(smartconnect_0_M00_AXI_WREADY),
        .AXI_15_WSTRB(smartconnect_0_M00_AXI_WSTRB),
        .AXI_15_WVALID(smartconnect_0_M00_AXI_WVALID),
        .AXI_16_ACLK(aclk_0),
        .AXI_16_ARADDR(smartconnect_0_M01_AXI_ARADDR),
        .AXI_16_ARBURST(smartconnect_0_M01_AXI_ARBURST),
        .AXI_16_ARESET_N(aresetn_0),
        .AXI_16_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_16_ARLEN(smartconnect_0_M01_AXI_ARLEN),
        .AXI_16_ARREADY(smartconnect_0_M01_AXI_ARREADY),
        .AXI_16_ARSIZE(smartconnect_0_M01_AXI_ARSIZE),
        .AXI_16_ARVALID(smartconnect_0_M01_AXI_ARVALID),
        .AXI_16_AWADDR(smartconnect_0_M01_AXI_AWADDR),
        .AXI_16_AWBURST(smartconnect_0_M01_AXI_AWBURST),
        .AXI_16_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_16_AWLEN(smartconnect_0_M01_AXI_AWLEN),
        .AXI_16_AWREADY(smartconnect_0_M01_AXI_AWREADY),
        .AXI_16_AWSIZE(smartconnect_0_M01_AXI_AWSIZE),
        .AXI_16_AWVALID(smartconnect_0_M01_AXI_AWVALID),
        .AXI_16_BREADY(smartconnect_0_M01_AXI_BREADY),
        .AXI_16_BRESP(smartconnect_0_M01_AXI_BRESP),
        .AXI_16_BVALID(smartconnect_0_M01_AXI_BVALID),
        .AXI_16_RDATA(smartconnect_0_M01_AXI_RDATA),
        .AXI_16_RLAST(smartconnect_0_M01_AXI_RLAST),
        .AXI_16_RREADY(smartconnect_0_M01_AXI_RREADY),
        .AXI_16_RRESP(smartconnect_0_M01_AXI_RRESP),
        .AXI_16_RVALID(smartconnect_0_M01_AXI_RVALID),
        .AXI_16_WDATA(smartconnect_0_M01_AXI_WDATA),
        .AXI_16_WDATA_PARITY({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .AXI_16_WLAST(smartconnect_0_M01_AXI_WLAST),
        .AXI_16_WREADY(smartconnect_0_M01_AXI_WREADY),
        .AXI_16_WSTRB(smartconnect_0_M01_AXI_WSTRB),
        .AXI_16_WVALID(smartconnect_0_M01_AXI_WVALID),
        .HBM_REF_CLK_0(clk_wiz_0_clk_out1),
        .HBM_REF_CLK_1(clk_wiz_0_clk_out1));
  qdma_hbm_bd_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_0_clk_out1));
  qdma_hbm_bd_smartconnect_0_0 smartconnect_0
       (.M00_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arburst(smartconnect_0_M00_AXI_ARBURST),
        .M00_AXI_arlen(smartconnect_0_M00_AXI_ARLEN),
        .M00_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awburst(smartconnect_0_M00_AXI_AWBURST),
        .M00_AXI_awlen(smartconnect_0_M00_AXI_AWLEN),
        .M00_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .M00_AXI_bready(smartconnect_0_M00_AXI_BREADY),
        .M00_AXI_bresp(smartconnect_0_M00_AXI_BRESP),
        .M00_AXI_bvalid(smartconnect_0_M00_AXI_BVALID),
        .M00_AXI_rdata(smartconnect_0_M00_AXI_RDATA),
        .M00_AXI_rlast(smartconnect_0_M00_AXI_RLAST),
        .M00_AXI_rready(smartconnect_0_M00_AXI_RREADY),
        .M00_AXI_rresp(smartconnect_0_M00_AXI_RRESP),
        .M00_AXI_rvalid(smartconnect_0_M00_AXI_RVALID),
        .M00_AXI_wdata(smartconnect_0_M00_AXI_WDATA),
        .M00_AXI_wlast(smartconnect_0_M00_AXI_WLAST),
        .M00_AXI_wready(smartconnect_0_M00_AXI_WREADY),
        .M00_AXI_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(smartconnect_0_M00_AXI_WVALID),
        .M01_AXI_araddr(smartconnect_0_M01_AXI_ARADDR),
        .M01_AXI_arburst(smartconnect_0_M01_AXI_ARBURST),
        .M01_AXI_arlen(smartconnect_0_M01_AXI_ARLEN),
        .M01_AXI_arready(smartconnect_0_M01_AXI_ARREADY),
        .M01_AXI_arsize(smartconnect_0_M01_AXI_ARSIZE),
        .M01_AXI_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .M01_AXI_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .M01_AXI_awburst(smartconnect_0_M01_AXI_AWBURST),
        .M01_AXI_awlen(smartconnect_0_M01_AXI_AWLEN),
        .M01_AXI_awready(smartconnect_0_M01_AXI_AWREADY),
        .M01_AXI_awsize(smartconnect_0_M01_AXI_AWSIZE),
        .M01_AXI_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .M01_AXI_bready(smartconnect_0_M01_AXI_BREADY),
        .M01_AXI_bresp(smartconnect_0_M01_AXI_BRESP),
        .M01_AXI_bvalid(smartconnect_0_M01_AXI_BVALID),
        .M01_AXI_rdata(smartconnect_0_M01_AXI_RDATA),
        .M01_AXI_rlast(smartconnect_0_M01_AXI_RLAST),
        .M01_AXI_rready(smartconnect_0_M01_AXI_RREADY),
        .M01_AXI_rresp(smartconnect_0_M01_AXI_RRESP),
        .M01_AXI_rvalid(smartconnect_0_M01_AXI_RVALID),
        .M01_AXI_wdata(smartconnect_0_M01_AXI_WDATA),
        .M01_AXI_wlast(smartconnect_0_M01_AXI_WLAST),
        .M01_AXI_wready(smartconnect_0_M01_AXI_WREADY),
        .M01_AXI_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .M01_AXI_wvalid(smartconnect_0_M01_AXI_WVALID),
        .S00_AXI_araddr(S00_AXI_araddr_0),
        .S00_AXI_arburst(S00_AXI_arburst_0),
        .S00_AXI_arcache(S00_AXI_arcache_0),
        .S00_AXI_arid(S00_AXI_arid_0),
        .S00_AXI_arlen(S00_AXI_arlen_0),
        .S00_AXI_arlock(S00_AXI_arlock_0),
        .S00_AXI_arprot(S00_AXI_arprot_0),
        .S00_AXI_arqos(S00_AXI_arqos_0),
        .S00_AXI_arready(S00_AXI_arready_0),
        .S00_AXI_arsize(S00_AXI_arsize_0),
        .S00_AXI_aruser(S00_AXI_aruser_0),
        .S00_AXI_arvalid(S00_AXI_arvalid_0),
        .S00_AXI_awaddr(S00_AXI_awaddr_0),
        .S00_AXI_awburst(S00_AXI_awburst_0),
        .S00_AXI_awcache(S00_AXI_awcache_0),
        .S00_AXI_awid(S00_AXI_awid_0),
        .S00_AXI_awlen(S00_AXI_awlen_0),
        .S00_AXI_awlock(S00_AXI_awlock_0),
        .S00_AXI_awprot(S00_AXI_awprot_0),
        .S00_AXI_awqos(S00_AXI_awqos_0),
        .S00_AXI_awready(S00_AXI_awready_0),
        .S00_AXI_awsize(S00_AXI_awsize_0),
        .S00_AXI_awuser(S00_AXI_awuser_0),
        .S00_AXI_awvalid(S00_AXI_awvalid_0),
        .S00_AXI_bid(S00_AXI_bid_0),
        .S00_AXI_bready(S00_AXI_bready_0),
        .S00_AXI_bresp(S00_AXI_bresp_0),
        .S00_AXI_bvalid(S00_AXI_bvalid_0),
        .S00_AXI_rdata(S00_AXI_rdata_0),
        .S00_AXI_rid(S00_AXI_rid_0),
        .S00_AXI_rlast(S00_AXI_rlast_0),
        .S00_AXI_rready(S00_AXI_rready_0),
        .S00_AXI_rresp(S00_AXI_rresp_0),
        .S00_AXI_rvalid(S00_AXI_rvalid_0),
        .S00_AXI_wdata(S00_AXI_wdata_0),
        .S00_AXI_wlast(S00_AXI_wlast_0),
        .S00_AXI_wready(S00_AXI_wready_0),
        .S00_AXI_wstrb(S00_AXI_wstrb_0),
        .S00_AXI_wuser(S00_AXI_wuser_0),
        .S00_AXI_wvalid(S00_AXI_wvalid_0),
        .aclk(aclk_0),
        .aresetn(aresetn_0));
endmodule
