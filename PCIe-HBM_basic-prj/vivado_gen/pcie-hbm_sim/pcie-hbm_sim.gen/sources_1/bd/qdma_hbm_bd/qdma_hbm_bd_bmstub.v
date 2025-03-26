// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module qdma_hbm_bd (
  hbm_clk_n,
  hbm_clk_p,
  aresetn,
  aclk_0,
  aresetn_0,
  S00_AXI_awid_0,
  S00_AXI_awaddr_0,
  S00_AXI_awlen_0,
  S00_AXI_awsize_0,
  S00_AXI_awburst_0,
  S00_AXI_awlock_0,
  S00_AXI_awcache_0,
  S00_AXI_awprot_0,
  S00_AXI_awqos_0,
  S00_AXI_awuser_0,
  S00_AXI_awvalid_0,
  S00_AXI_awready_0,
  S00_AXI_wdata_0,
  S00_AXI_wstrb_0,
  S00_AXI_wlast_0,
  S00_AXI_wuser_0,
  S00_AXI_wvalid_0,
  S00_AXI_wready_0,
  S00_AXI_bid_0,
  S00_AXI_bresp_0,
  S00_AXI_bvalid_0,
  S00_AXI_bready_0,
  S00_AXI_arid_0,
  S00_AXI_araddr_0,
  S00_AXI_arlen_0,
  S00_AXI_arsize_0,
  S00_AXI_arburst_0,
  S00_AXI_arlock_0,
  S00_AXI_arcache_0,
  S00_AXI_arprot_0,
  S00_AXI_arqos_0,
  S00_AXI_aruser_0,
  S00_AXI_arvalid_0,
  S00_AXI_arready_0,
  S00_AXI_rid_0,
  S00_AXI_rdata_0,
  S00_AXI_rresp_0,
  S00_AXI_rlast_0,
  S00_AXI_rvalid_0,
  S00_AXI_rready_0
);

  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HBM_CLK_N CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.HBM_CLK_N" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HBM_CLK_N, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_hbm_clk_n, INSERT_VIP 0" *)
  input hbm_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HBM_CLK_P CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.HBM_CLK_P" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HBM_CLK_P, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_hbm_clk_p, INSERT_VIP 0" *)
  input hbm_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *)
  (* X_INTERFACE_MODE = "slave RST.ARESETN" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
  input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK_0 CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.ACLK_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK_0, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_aclk_0, INSERT_VIP 0" *)
  input aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN_0 RST" *)
  (* X_INTERFACE_MODE = "slave RST.ARESETN_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN_0, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
  input aresetn_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_awid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]S00_AXI_awaddr_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [7:0]S00_AXI_awlen_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [2:0]S00_AXI_awsize_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [1:0]S00_AXI_awburst_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]S00_AXI_awlock_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_awcache_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [2:0]S00_AXI_awprot_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_awqos_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [31:0]S00_AXI_awuser_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_awvalid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_awready_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [511:0]S00_AXI_wdata_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]S00_AXI_wstrb_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_wlast_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]S00_AXI_wuser_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_wvalid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_wready_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [3:0]S00_AXI_bid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [1:0]S00_AXI_bresp_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_bvalid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_bready_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_arid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]S00_AXI_araddr_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [7:0]S00_AXI_arlen_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [2:0]S00_AXI_arsize_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [1:0]S00_AXI_arburst_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [0:0]S00_AXI_arlock_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_arcache_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [2:0]S00_AXI_arprot_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [3:0]S00_AXI_arqos_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [31:0]S00_AXI_aruser_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_arvalid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_arready_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [3:0]S00_AXI_rid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [511:0]S00_AXI_rdata_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [1:0]S00_AXI_rresp_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_rlast_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output S00_AXI_rvalid_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input S00_AXI_rready_0;

  // stub module has no contents

endmodule
