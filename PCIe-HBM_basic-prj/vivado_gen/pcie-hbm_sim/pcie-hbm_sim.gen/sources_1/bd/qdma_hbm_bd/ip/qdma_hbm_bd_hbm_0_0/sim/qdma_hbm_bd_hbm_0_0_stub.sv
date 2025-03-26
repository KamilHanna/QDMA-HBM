// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


//------------------------------------------------------------------------------------
// Filename:    qdma_hbm_bd_hbm_0_0_stub.sv
// Description: This HDL file is intended to be used with following simulators only:
//
//   Vivado Simulator (XSim)
//   Cadence Xcelium Simulator
//
//------------------------------------------------------------------------------------
`timescale 1ps/1ps

`ifdef XILINX_SIMULATOR

`ifndef XILINX_SIMULATOR_BITASBOOL
`define XILINX_SIMULATOR_BITASBOOL
typedef bit bit_as_bool;
`endif

(* SC_MODULE_EXPORT *)
module qdma_hbm_bd_hbm_0_0 (
  input bit_as_bool HBM_REF_CLK_0,
  input bit_as_bool HBM_REF_CLK_1,
  input bit_as_bool AXI_15_ACLK,
  input bit_as_bool AXI_15_ARESET_N,
  input bit [33 : 0] AXI_15_ARADDR,
  input bit [1 : 0] AXI_15_ARBURST,
  input bit [5 : 0] AXI_15_ARID,
  input bit [3 : 0] AXI_15_ARLEN,
  input bit [2 : 0] AXI_15_ARSIZE,
  input bit_as_bool AXI_15_ARVALID,
  input bit [33 : 0] AXI_15_AWADDR,
  input bit [1 : 0] AXI_15_AWBURST,
  input bit [5 : 0] AXI_15_AWID,
  input bit [3 : 0] AXI_15_AWLEN,
  input bit [2 : 0] AXI_15_AWSIZE,
  input bit_as_bool AXI_15_AWVALID,
  input bit_as_bool AXI_15_RREADY,
  input bit_as_bool AXI_15_BREADY,
  input bit [255 : 0] AXI_15_WDATA,
  input bit_as_bool AXI_15_WLAST,
  input bit [31 : 0] AXI_15_WSTRB,
  input bit [31 : 0] AXI_15_WDATA_PARITY,
  input bit_as_bool AXI_15_WVALID,
  input bit_as_bool AXI_16_ACLK,
  input bit_as_bool AXI_16_ARESET_N,
  input bit [33 : 0] AXI_16_ARADDR,
  input bit [1 : 0] AXI_16_ARBURST,
  input bit [5 : 0] AXI_16_ARID,
  input bit [3 : 0] AXI_16_ARLEN,
  input bit [2 : 0] AXI_16_ARSIZE,
  input bit_as_bool AXI_16_ARVALID,
  input bit [33 : 0] AXI_16_AWADDR,
  input bit [1 : 0] AXI_16_AWBURST,
  input bit [5 : 0] AXI_16_AWID,
  input bit [3 : 0] AXI_16_AWLEN,
  input bit [2 : 0] AXI_16_AWSIZE,
  input bit_as_bool AXI_16_AWVALID,
  input bit_as_bool AXI_16_RREADY,
  input bit_as_bool AXI_16_BREADY,
  input bit [255 : 0] AXI_16_WDATA,
  input bit_as_bool AXI_16_WLAST,
  input bit [31 : 0] AXI_16_WSTRB,
  input bit [31 : 0] AXI_16_WDATA_PARITY,
  input bit_as_bool AXI_16_WVALID,
  input bit_as_bool APB_0_PCLK,
  input bit_as_bool APB_0_PRESET_N,
  input bit_as_bool APB_1_PCLK,
  input bit_as_bool APB_1_PRESET_N,
  output bit_as_bool AXI_15_ARREADY,
  output bit_as_bool AXI_15_AWREADY,
  output bit [31 : 0] AXI_15_RDATA_PARITY,
  output bit [255 : 0] AXI_15_RDATA,
  output bit [5 : 0] AXI_15_RID,
  output bit_as_bool AXI_15_RLAST,
  output bit [1 : 0] AXI_15_RRESP,
  output bit_as_bool AXI_15_RVALID,
  output bit_as_bool AXI_15_WREADY,
  output bit [5 : 0] AXI_15_BID,
  output bit [1 : 0] AXI_15_BRESP,
  output bit_as_bool AXI_15_BVALID,
  output bit_as_bool AXI_16_ARREADY,
  output bit_as_bool AXI_16_AWREADY,
  output bit [31 : 0] AXI_16_RDATA_PARITY,
  output bit [255 : 0] AXI_16_RDATA,
  output bit [5 : 0] AXI_16_RID,
  output bit_as_bool AXI_16_RLAST,
  output bit [1 : 0] AXI_16_RRESP,
  output bit_as_bool AXI_16_RVALID,
  output bit_as_bool AXI_16_WREADY,
  output bit [5 : 0] AXI_16_BID,
  output bit [1 : 0] AXI_16_BRESP,
  output bit_as_bool AXI_16_BVALID,
  output bit_as_bool apb_complete_0,
  output bit_as_bool apb_complete_1,
  output bit_as_bool DRAM_0_STAT_CATTRIP,
  output bit [6 : 0] DRAM_0_STAT_TEMP,
  output bit_as_bool DRAM_1_STAT_CATTRIP,
  output bit [6 : 0] DRAM_1_STAT_TEMP
);
endmodule
`endif

`ifdef XCELIUM
(* XMSC_MODULE_EXPORT *)
module qdma_hbm_bd_hbm_0_0 (HBM_REF_CLK_0,HBM_REF_CLK_1,AXI_15_ACLK,AXI_15_ARESET_N,AXI_15_ARADDR,AXI_15_ARBURST,AXI_15_ARID,AXI_15_ARLEN,AXI_15_ARSIZE,AXI_15_ARVALID,AXI_15_AWADDR,AXI_15_AWBURST,AXI_15_AWID,AXI_15_AWLEN,AXI_15_AWSIZE,AXI_15_AWVALID,AXI_15_RREADY,AXI_15_BREADY,AXI_15_WDATA,AXI_15_WLAST,AXI_15_WSTRB,AXI_15_WDATA_PARITY,AXI_15_WVALID,AXI_16_ACLK,AXI_16_ARESET_N,AXI_16_ARADDR,AXI_16_ARBURST,AXI_16_ARID,AXI_16_ARLEN,AXI_16_ARSIZE,AXI_16_ARVALID,AXI_16_AWADDR,AXI_16_AWBURST,AXI_16_AWID,AXI_16_AWLEN,AXI_16_AWSIZE,AXI_16_AWVALID,AXI_16_RREADY,AXI_16_BREADY,AXI_16_WDATA,AXI_16_WLAST,AXI_16_WSTRB,AXI_16_WDATA_PARITY,AXI_16_WVALID,APB_0_PCLK,APB_0_PRESET_N,APB_1_PCLK,APB_1_PRESET_N,AXI_15_ARREADY,AXI_15_AWREADY,AXI_15_RDATA_PARITY,AXI_15_RDATA,AXI_15_RID,AXI_15_RLAST,AXI_15_RRESP,AXI_15_RVALID,AXI_15_WREADY,AXI_15_BID,AXI_15_BRESP,AXI_15_BVALID,AXI_16_ARREADY,AXI_16_AWREADY,AXI_16_RDATA_PARITY,AXI_16_RDATA,AXI_16_RID,AXI_16_RLAST,AXI_16_RRESP,AXI_16_RVALID,AXI_16_WREADY,AXI_16_BID,AXI_16_BRESP,AXI_16_BVALID,apb_complete_0,apb_complete_1,DRAM_0_STAT_CATTRIP,DRAM_0_STAT_TEMP,DRAM_1_STAT_CATTRIP,DRAM_1_STAT_TEMP)
(* integer foreign = "SystemC";
*);
  input bit HBM_REF_CLK_0;
  input bit HBM_REF_CLK_1;
  input bit AXI_15_ACLK;
  input bit AXI_15_ARESET_N;
  input bit [33 : 0] AXI_15_ARADDR;
  input bit [1 : 0] AXI_15_ARBURST;
  input bit [5 : 0] AXI_15_ARID;
  input bit [3 : 0] AXI_15_ARLEN;
  input bit [2 : 0] AXI_15_ARSIZE;
  input bit AXI_15_ARVALID;
  input bit [33 : 0] AXI_15_AWADDR;
  input bit [1 : 0] AXI_15_AWBURST;
  input bit [5 : 0] AXI_15_AWID;
  input bit [3 : 0] AXI_15_AWLEN;
  input bit [2 : 0] AXI_15_AWSIZE;
  input bit AXI_15_AWVALID;
  input bit AXI_15_RREADY;
  input bit AXI_15_BREADY;
  input bit [255 : 0] AXI_15_WDATA;
  input bit AXI_15_WLAST;
  input bit [31 : 0] AXI_15_WSTRB;
  input bit [31 : 0] AXI_15_WDATA_PARITY;
  input bit AXI_15_WVALID;
  input bit AXI_16_ACLK;
  input bit AXI_16_ARESET_N;
  input bit [33 : 0] AXI_16_ARADDR;
  input bit [1 : 0] AXI_16_ARBURST;
  input bit [5 : 0] AXI_16_ARID;
  input bit [3 : 0] AXI_16_ARLEN;
  input bit [2 : 0] AXI_16_ARSIZE;
  input bit AXI_16_ARVALID;
  input bit [33 : 0] AXI_16_AWADDR;
  input bit [1 : 0] AXI_16_AWBURST;
  input bit [5 : 0] AXI_16_AWID;
  input bit [3 : 0] AXI_16_AWLEN;
  input bit [2 : 0] AXI_16_AWSIZE;
  input bit AXI_16_AWVALID;
  input bit AXI_16_RREADY;
  input bit AXI_16_BREADY;
  input bit [255 : 0] AXI_16_WDATA;
  input bit AXI_16_WLAST;
  input bit [31 : 0] AXI_16_WSTRB;
  input bit [31 : 0] AXI_16_WDATA_PARITY;
  input bit AXI_16_WVALID;
  input bit APB_0_PCLK;
  input bit APB_0_PRESET_N;
  input bit APB_1_PCLK;
  input bit APB_1_PRESET_N;
  output wire AXI_15_ARREADY;
  output wire AXI_15_AWREADY;
  output wire [31 : 0] AXI_15_RDATA_PARITY;
  output wire [255 : 0] AXI_15_RDATA;
  output wire [5 : 0] AXI_15_RID;
  output wire AXI_15_RLAST;
  output wire [1 : 0] AXI_15_RRESP;
  output wire AXI_15_RVALID;
  output wire AXI_15_WREADY;
  output wire [5 : 0] AXI_15_BID;
  output wire [1 : 0] AXI_15_BRESP;
  output wire AXI_15_BVALID;
  output wire AXI_16_ARREADY;
  output wire AXI_16_AWREADY;
  output wire [31 : 0] AXI_16_RDATA_PARITY;
  output wire [255 : 0] AXI_16_RDATA;
  output wire [5 : 0] AXI_16_RID;
  output wire AXI_16_RLAST;
  output wire [1 : 0] AXI_16_RRESP;
  output wire AXI_16_RVALID;
  output wire AXI_16_WREADY;
  output wire [5 : 0] AXI_16_BID;
  output wire [1 : 0] AXI_16_BRESP;
  output wire AXI_16_BVALID;
  output wire apb_complete_0;
  output wire apb_complete_1;
  output wire DRAM_0_STAT_CATTRIP;
  output wire [6 : 0] DRAM_0_STAT_TEMP;
  output wire DRAM_1_STAT_CATTRIP;
  output wire [6 : 0] DRAM_1_STAT_TEMP;
endmodule
`endif
