#ifndef IP_QDMA_HBM_BD_HBM_0_0_H_
#define IP_QDMA_HBM_BD_HBM_0_0_H_

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


#ifndef XTLM
#include "xtlm.h"
#endif
#ifndef SYSTEMC_INCLUDED
#include <systemc>
#endif

#if defined(_MSC_VER)
#define DllExport __declspec(dllexport)
#elif defined(__GNUC__)
#define DllExport __attribute__ ((visibility("default")))
#else
#define DllExport
#endif

#include "qdma_hbm_bd_hbm_0_0_sc.h"




#ifdef XILINX_SIMULATOR
class DllExport qdma_hbm_bd_hbm_0_0 : public qdma_hbm_bd_hbm_0_0_sc
{
public:

  qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm);
  virtual ~qdma_hbm_bd_hbm_0_0();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > HBM_REF_CLK_0;
  sc_core::sc_in< bool > HBM_REF_CLK_1;
  sc_core::sc_in< bool > AXI_15_ACLK;
  sc_core::sc_in< bool > AXI_15_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_ARSIZE;
  sc_core::sc_in< bool > AXI_15_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_AWSIZE;
  sc_core::sc_in< bool > AXI_15_AWVALID;
  sc_core::sc_in< bool > AXI_15_RREADY;
  sc_core::sc_in< bool > AXI_15_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_15_WDATA;
  sc_core::sc_in< bool > AXI_15_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_15_WVALID;
  sc_core::sc_in< bool > AXI_16_ACLK;
  sc_core::sc_in< bool > AXI_16_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_ARSIZE;
  sc_core::sc_in< bool > AXI_16_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_AWSIZE;
  sc_core::sc_in< bool > AXI_16_AWVALID;
  sc_core::sc_in< bool > AXI_16_RREADY;
  sc_core::sc_in< bool > AXI_16_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_16_WDATA;
  sc_core::sc_in< bool > AXI_16_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_16_WVALID;
  sc_core::sc_in< bool > APB_0_PCLK;
  sc_core::sc_in< bool > APB_0_PRESET_N;
  sc_core::sc_in< bool > APB_1_PCLK;
  sc_core::sc_in< bool > APB_1_PRESET_N;
  sc_core::sc_out< bool > AXI_15_ARREADY;
  sc_core::sc_out< bool > AXI_15_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_15_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_15_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_RID;
  sc_core::sc_out< bool > AXI_15_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_RRESP;
  sc_core::sc_out< bool > AXI_15_RVALID;
  sc_core::sc_out< bool > AXI_15_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_BRESP;
  sc_core::sc_out< bool > AXI_15_BVALID;
  sc_core::sc_out< bool > AXI_16_ARREADY;
  sc_core::sc_out< bool > AXI_16_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_16_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_16_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_RID;
  sc_core::sc_out< bool > AXI_16_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_RRESP;
  sc_core::sc_out< bool > AXI_16_RVALID;
  sc_core::sc_out< bool > AXI_16_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_BRESP;
  sc_core::sc_out< bool > AXI_16_BVALID;
  sc_core::sc_out< bool > apb_complete_0;
  sc_core::sc_out< bool > apb_complete_1;
  sc_core::sc_out< bool > DRAM_0_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_0_STAT_TEMP;
  sc_core::sc_out< bool > DRAM_1_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_1_STAT_TEMP;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_15_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_15_8HI_transactor_rst_signal;
  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_16_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_16_8HI_transactor_rst_signal;

};
#endif // XILINX_SIMULATOR




#ifdef XM_SYSTEMC
class DllExport qdma_hbm_bd_hbm_0_0 : public qdma_hbm_bd_hbm_0_0_sc
{
public:

  qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm);
  virtual ~qdma_hbm_bd_hbm_0_0();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > HBM_REF_CLK_0;
  sc_core::sc_in< bool > HBM_REF_CLK_1;
  sc_core::sc_in< bool > AXI_15_ACLK;
  sc_core::sc_in< bool > AXI_15_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_ARSIZE;
  sc_core::sc_in< bool > AXI_15_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_AWSIZE;
  sc_core::sc_in< bool > AXI_15_AWVALID;
  sc_core::sc_in< bool > AXI_15_RREADY;
  sc_core::sc_in< bool > AXI_15_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_15_WDATA;
  sc_core::sc_in< bool > AXI_15_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_15_WVALID;
  sc_core::sc_in< bool > AXI_16_ACLK;
  sc_core::sc_in< bool > AXI_16_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_ARSIZE;
  sc_core::sc_in< bool > AXI_16_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_AWSIZE;
  sc_core::sc_in< bool > AXI_16_AWVALID;
  sc_core::sc_in< bool > AXI_16_RREADY;
  sc_core::sc_in< bool > AXI_16_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_16_WDATA;
  sc_core::sc_in< bool > AXI_16_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_16_WVALID;
  sc_core::sc_in< bool > APB_0_PCLK;
  sc_core::sc_in< bool > APB_0_PRESET_N;
  sc_core::sc_in< bool > APB_1_PCLK;
  sc_core::sc_in< bool > APB_1_PRESET_N;
  sc_core::sc_out< bool > AXI_15_ARREADY;
  sc_core::sc_out< bool > AXI_15_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_15_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_15_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_RID;
  sc_core::sc_out< bool > AXI_15_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_RRESP;
  sc_core::sc_out< bool > AXI_15_RVALID;
  sc_core::sc_out< bool > AXI_15_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_BRESP;
  sc_core::sc_out< bool > AXI_15_BVALID;
  sc_core::sc_out< bool > AXI_16_ARREADY;
  sc_core::sc_out< bool > AXI_16_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_16_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_16_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_RID;
  sc_core::sc_out< bool > AXI_16_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_RRESP;
  sc_core::sc_out< bool > AXI_16_RVALID;
  sc_core::sc_out< bool > AXI_16_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_BRESP;
  sc_core::sc_out< bool > AXI_16_BVALID;
  sc_core::sc_out< bool > apb_complete_0;
  sc_core::sc_out< bool > apb_complete_1;
  sc_core::sc_out< bool > DRAM_0_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_0_STAT_TEMP;
  sc_core::sc_out< bool > DRAM_1_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_1_STAT_TEMP;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_15_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_15_8HI_transactor_rst_signal;
  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_16_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_16_8HI_transactor_rst_signal;

};
#endif // XM_SYSTEMC




#ifdef RIVIERA
class DllExport qdma_hbm_bd_hbm_0_0 : public qdma_hbm_bd_hbm_0_0_sc
{
public:

  qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm);
  virtual ~qdma_hbm_bd_hbm_0_0();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > HBM_REF_CLK_0;
  sc_core::sc_in< bool > HBM_REF_CLK_1;
  sc_core::sc_in< bool > AXI_15_ACLK;
  sc_core::sc_in< bool > AXI_15_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_ARSIZE;
  sc_core::sc_in< bool > AXI_15_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_AWSIZE;
  sc_core::sc_in< bool > AXI_15_AWVALID;
  sc_core::sc_in< bool > AXI_15_RREADY;
  sc_core::sc_in< bool > AXI_15_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_15_WDATA;
  sc_core::sc_in< bool > AXI_15_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_15_WVALID;
  sc_core::sc_in< bool > AXI_16_ACLK;
  sc_core::sc_in< bool > AXI_16_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_ARSIZE;
  sc_core::sc_in< bool > AXI_16_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_AWSIZE;
  sc_core::sc_in< bool > AXI_16_AWVALID;
  sc_core::sc_in< bool > AXI_16_RREADY;
  sc_core::sc_in< bool > AXI_16_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_16_WDATA;
  sc_core::sc_in< bool > AXI_16_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_16_WVALID;
  sc_core::sc_in< bool > APB_0_PCLK;
  sc_core::sc_in< bool > APB_0_PRESET_N;
  sc_core::sc_in< bool > APB_1_PCLK;
  sc_core::sc_in< bool > APB_1_PRESET_N;
  sc_core::sc_out< bool > AXI_15_ARREADY;
  sc_core::sc_out< bool > AXI_15_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_15_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_15_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_RID;
  sc_core::sc_out< bool > AXI_15_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_RRESP;
  sc_core::sc_out< bool > AXI_15_RVALID;
  sc_core::sc_out< bool > AXI_15_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_BRESP;
  sc_core::sc_out< bool > AXI_15_BVALID;
  sc_core::sc_out< bool > AXI_16_ARREADY;
  sc_core::sc_out< bool > AXI_16_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_16_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_16_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_RID;
  sc_core::sc_out< bool > AXI_16_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_RRESP;
  sc_core::sc_out< bool > AXI_16_RVALID;
  sc_core::sc_out< bool > AXI_16_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_BRESP;
  sc_core::sc_out< bool > AXI_16_BVALID;
  sc_core::sc_out< bool > apb_complete_0;
  sc_core::sc_out< bool > apb_complete_1;
  sc_core::sc_out< bool > DRAM_0_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_0_STAT_TEMP;
  sc_core::sc_out< bool > DRAM_1_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_1_STAT_TEMP;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_15_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_15_8HI_transactor_rst_signal;
  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_16_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_16_8HI_transactor_rst_signal;

};
#endif // RIVIERA




#ifdef VCSSYSTEMC
#include "utils/xtlm_aximm_target_stub.h"

class DllExport qdma_hbm_bd_hbm_0_0 : public qdma_hbm_bd_hbm_0_0_sc
{
public:

  qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm);
  virtual ~qdma_hbm_bd_hbm_0_0();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > HBM_REF_CLK_0;
  sc_core::sc_in< bool > HBM_REF_CLK_1;
  sc_core::sc_in< bool > AXI_15_ACLK;
  sc_core::sc_in< bool > AXI_15_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_ARSIZE;
  sc_core::sc_in< bool > AXI_15_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_AWSIZE;
  sc_core::sc_in< bool > AXI_15_AWVALID;
  sc_core::sc_in< bool > AXI_15_RREADY;
  sc_core::sc_in< bool > AXI_15_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_15_WDATA;
  sc_core::sc_in< bool > AXI_15_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_15_WVALID;
  sc_core::sc_in< bool > AXI_16_ACLK;
  sc_core::sc_in< bool > AXI_16_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_ARSIZE;
  sc_core::sc_in< bool > AXI_16_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_AWSIZE;
  sc_core::sc_in< bool > AXI_16_AWVALID;
  sc_core::sc_in< bool > AXI_16_RREADY;
  sc_core::sc_in< bool > AXI_16_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_16_WDATA;
  sc_core::sc_in< bool > AXI_16_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_16_WVALID;
  sc_core::sc_in< bool > APB_0_PCLK;
  sc_core::sc_in< bool > APB_0_PRESET_N;
  sc_core::sc_in< bool > APB_1_PCLK;
  sc_core::sc_in< bool > APB_1_PRESET_N;
  sc_core::sc_out< bool > AXI_15_ARREADY;
  sc_core::sc_out< bool > AXI_15_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_15_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_15_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_RID;
  sc_core::sc_out< bool > AXI_15_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_RRESP;
  sc_core::sc_out< bool > AXI_15_RVALID;
  sc_core::sc_out< bool > AXI_15_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_BRESP;
  sc_core::sc_out< bool > AXI_15_BVALID;
  sc_core::sc_out< bool > AXI_16_ARREADY;
  sc_core::sc_out< bool > AXI_16_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_16_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_16_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_RID;
  sc_core::sc_out< bool > AXI_16_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_RRESP;
  sc_core::sc_out< bool > AXI_16_RVALID;
  sc_core::sc_out< bool > AXI_16_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_BRESP;
  sc_core::sc_out< bool > AXI_16_BVALID;
  sc_core::sc_out< bool > apb_complete_0;
  sc_core::sc_out< bool > apb_complete_1;
  sc_core::sc_out< bool > DRAM_0_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_0_STAT_TEMP;
  sc_core::sc_out< bool > DRAM_1_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_1_STAT_TEMP;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_15_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_15_8HI_transactor_rst_signal;
  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_16_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_16_8HI_transactor_rst_signal;

  // Transactor stubs
  xtlm::xtlm_aximm_target_stub * SAXI_15_8HI_transactor_target_rd_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_15_8HI_transactor_target_wr_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_16_8HI_transactor_target_rd_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_16_8HI_transactor_target_wr_socket_stub;

  // Socket stubs

};
#endif // VCSSYSTEMC




#ifdef MTI_SYSTEMC
#include "utils/xtlm_aximm_target_stub.h"

class DllExport qdma_hbm_bd_hbm_0_0 : public qdma_hbm_bd_hbm_0_0_sc
{
public:

  qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm);
  virtual ~qdma_hbm_bd_hbm_0_0();

  // module pin-to-pin RTL interface

  sc_core::sc_in< bool > HBM_REF_CLK_0;
  sc_core::sc_in< bool > HBM_REF_CLK_1;
  sc_core::sc_in< bool > AXI_15_ACLK;
  sc_core::sc_in< bool > AXI_15_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_ARSIZE;
  sc_core::sc_in< bool > AXI_15_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_15_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_15_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_15_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_15_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_15_AWSIZE;
  sc_core::sc_in< bool > AXI_15_AWVALID;
  sc_core::sc_in< bool > AXI_15_RREADY;
  sc_core::sc_in< bool > AXI_15_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_15_WDATA;
  sc_core::sc_in< bool > AXI_15_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_15_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_15_WVALID;
  sc_core::sc_in< bool > AXI_16_ACLK;
  sc_core::sc_in< bool > AXI_16_ARESET_N;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_ARADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_ARBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_ARID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_ARLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_ARSIZE;
  sc_core::sc_in< bool > AXI_16_ARVALID;
  sc_core::sc_in< sc_dt::sc_bv<34> > AXI_16_AWADDR;
  sc_core::sc_in< sc_dt::sc_bv<2> > AXI_16_AWBURST;
  sc_core::sc_in< sc_dt::sc_bv<6> > AXI_16_AWID;
  sc_core::sc_in< sc_dt::sc_bv<4> > AXI_16_AWLEN;
  sc_core::sc_in< sc_dt::sc_bv<3> > AXI_16_AWSIZE;
  sc_core::sc_in< bool > AXI_16_AWVALID;
  sc_core::sc_in< bool > AXI_16_RREADY;
  sc_core::sc_in< bool > AXI_16_BREADY;
  sc_core::sc_in< sc_dt::sc_bv<256> > AXI_16_WDATA;
  sc_core::sc_in< bool > AXI_16_WLAST;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WSTRB;
  sc_core::sc_in< sc_dt::sc_bv<32> > AXI_16_WDATA_PARITY;
  sc_core::sc_in< bool > AXI_16_WVALID;
  sc_core::sc_in< bool > APB_0_PCLK;
  sc_core::sc_in< bool > APB_0_PRESET_N;
  sc_core::sc_in< bool > APB_1_PCLK;
  sc_core::sc_in< bool > APB_1_PRESET_N;
  sc_core::sc_out< bool > AXI_15_ARREADY;
  sc_core::sc_out< bool > AXI_15_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_15_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_15_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_RID;
  sc_core::sc_out< bool > AXI_15_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_RRESP;
  sc_core::sc_out< bool > AXI_15_RVALID;
  sc_core::sc_out< bool > AXI_15_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_15_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_15_BRESP;
  sc_core::sc_out< bool > AXI_15_BVALID;
  sc_core::sc_out< bool > AXI_16_ARREADY;
  sc_core::sc_out< bool > AXI_16_AWREADY;
  sc_core::sc_out< sc_dt::sc_bv<32> > AXI_16_RDATA_PARITY;
  sc_core::sc_out< sc_dt::sc_bv<256> > AXI_16_RDATA;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_RID;
  sc_core::sc_out< bool > AXI_16_RLAST;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_RRESP;
  sc_core::sc_out< bool > AXI_16_RVALID;
  sc_core::sc_out< bool > AXI_16_WREADY;
  sc_core::sc_out< sc_dt::sc_bv<6> > AXI_16_BID;
  sc_core::sc_out< sc_dt::sc_bv<2> > AXI_16_BRESP;
  sc_core::sc_out< bool > AXI_16_BVALID;
  sc_core::sc_out< bool > apb_complete_0;
  sc_core::sc_out< bool > apb_complete_1;
  sc_core::sc_out< bool > DRAM_0_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_0_STAT_TEMP;
  sc_core::sc_out< bool > DRAM_1_STAT_CATTRIP;
  sc_core::sc_out< sc_dt::sc_bv<7> > DRAM_1_STAT_TEMP;

  // Dummy Signals for IP Ports


protected:

  virtual void before_end_of_elaboration();

private:

  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_15_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_15_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_15_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_15_8HI_transactor_rst_signal;
  xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>* mp_SAXI_16_8HI_transactor;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_ARLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_ARLEN_converter_signal;
  xsc::common::vector2vector_converter<4,8>* mp_AXI_16_AWLEN_converter;
  sc_signal< sc_bv<8> > m_AXI_16_AWLEN_converter_signal;
  sc_signal< bool > m_SAXI_16_8HI_transactor_rst_signal;

  // Transactor stubs
  xtlm::xtlm_aximm_target_stub * SAXI_15_8HI_transactor_target_rd_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_15_8HI_transactor_target_wr_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_16_8HI_transactor_target_rd_socket_stub;
  xtlm::xtlm_aximm_target_stub * SAXI_16_8HI_transactor_target_wr_socket_stub;

  // Socket stubs

};
#endif // MTI_SYSTEMC
#endif // IP_QDMA_HBM_BD_HBM_0_0_H_
