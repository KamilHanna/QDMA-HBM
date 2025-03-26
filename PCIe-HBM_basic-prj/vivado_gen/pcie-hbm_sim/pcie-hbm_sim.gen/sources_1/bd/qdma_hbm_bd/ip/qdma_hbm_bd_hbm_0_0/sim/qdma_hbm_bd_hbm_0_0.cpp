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


#include "qdma_hbm_bd_hbm_0_0_sc.h"

#include "qdma_hbm_bd_hbm_0_0.h"

#include "hbm_sc.h"

#include <map>
#include <string>





#ifdef XILINX_SIMULATOR
qdma_hbm_bd_hbm_0_0::qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm) : qdma_hbm_bd_hbm_0_0_sc(nm), HBM_REF_CLK_0("HBM_REF_CLK_0"), HBM_REF_CLK_1("HBM_REF_CLK_1"), AXI_15_ACLK("AXI_15_ACLK"), AXI_15_ARESET_N("AXI_15_ARESET_N"), AXI_15_ARADDR("AXI_15_ARADDR"), AXI_15_ARBURST("AXI_15_ARBURST"), AXI_15_ARID("AXI_15_ARID"), AXI_15_ARLEN("AXI_15_ARLEN"), AXI_15_ARSIZE("AXI_15_ARSIZE"), AXI_15_ARVALID("AXI_15_ARVALID"), AXI_15_AWADDR("AXI_15_AWADDR"), AXI_15_AWBURST("AXI_15_AWBURST"), AXI_15_AWID("AXI_15_AWID"), AXI_15_AWLEN("AXI_15_AWLEN"), AXI_15_AWSIZE("AXI_15_AWSIZE"), AXI_15_AWVALID("AXI_15_AWVALID"), AXI_15_RREADY("AXI_15_RREADY"), AXI_15_BREADY("AXI_15_BREADY"), AXI_15_WDATA("AXI_15_WDATA"), AXI_15_WLAST("AXI_15_WLAST"), AXI_15_WSTRB("AXI_15_WSTRB"), AXI_15_WDATA_PARITY("AXI_15_WDATA_PARITY"), AXI_15_WVALID("AXI_15_WVALID"), AXI_16_ACLK("AXI_16_ACLK"), AXI_16_ARESET_N("AXI_16_ARESET_N"), AXI_16_ARADDR("AXI_16_ARADDR"), AXI_16_ARBURST("AXI_16_ARBURST"), AXI_16_ARID("AXI_16_ARID"), AXI_16_ARLEN("AXI_16_ARLEN"), AXI_16_ARSIZE("AXI_16_ARSIZE"), AXI_16_ARVALID("AXI_16_ARVALID"), AXI_16_AWADDR("AXI_16_AWADDR"), AXI_16_AWBURST("AXI_16_AWBURST"), AXI_16_AWID("AXI_16_AWID"), AXI_16_AWLEN("AXI_16_AWLEN"), AXI_16_AWSIZE("AXI_16_AWSIZE"), AXI_16_AWVALID("AXI_16_AWVALID"), AXI_16_RREADY("AXI_16_RREADY"), AXI_16_BREADY("AXI_16_BREADY"), AXI_16_WDATA("AXI_16_WDATA"), AXI_16_WLAST("AXI_16_WLAST"), AXI_16_WSTRB("AXI_16_WSTRB"), AXI_16_WDATA_PARITY("AXI_16_WDATA_PARITY"), AXI_16_WVALID("AXI_16_WVALID"), APB_0_PCLK("APB_0_PCLK"), APB_0_PRESET_N("APB_0_PRESET_N"), APB_1_PCLK("APB_1_PCLK"), APB_1_PRESET_N("APB_1_PRESET_N"), AXI_15_ARREADY("AXI_15_ARREADY"), AXI_15_AWREADY("AXI_15_AWREADY"), AXI_15_RDATA_PARITY("AXI_15_RDATA_PARITY"), AXI_15_RDATA("AXI_15_RDATA"), AXI_15_RID("AXI_15_RID"), AXI_15_RLAST("AXI_15_RLAST"), AXI_15_RRESP("AXI_15_RRESP"), AXI_15_RVALID("AXI_15_RVALID"), AXI_15_WREADY("AXI_15_WREADY"), AXI_15_BID("AXI_15_BID"), AXI_15_BRESP("AXI_15_BRESP"), AXI_15_BVALID("AXI_15_BVALID"), AXI_16_ARREADY("AXI_16_ARREADY"), AXI_16_AWREADY("AXI_16_AWREADY"), AXI_16_RDATA_PARITY("AXI_16_RDATA_PARITY"), AXI_16_RDATA("AXI_16_RDATA"), AXI_16_RID("AXI_16_RID"), AXI_16_RLAST("AXI_16_RLAST"), AXI_16_RRESP("AXI_16_RRESP"), AXI_16_RVALID("AXI_16_RVALID"), AXI_16_WREADY("AXI_16_WREADY"), AXI_16_BID("AXI_16_BID"), AXI_16_BRESP("AXI_16_BRESP"), AXI_16_BVALID("AXI_16_BVALID"), apb_complete_0("apb_complete_0"), apb_complete_1("apb_complete_1"), DRAM_0_STAT_CATTRIP("DRAM_0_STAT_CATTRIP"), DRAM_0_STAT_TEMP("DRAM_0_STAT_TEMP"), DRAM_1_STAT_CATTRIP("DRAM_1_STAT_CATTRIP"), DRAM_1_STAT_TEMP("DRAM_1_STAT_TEMP")
{

  // initialize pins
  mp_impl->HBM_REF_CLK_0(HBM_REF_CLK_0);
  mp_impl->HBM_REF_CLK_1(HBM_REF_CLK_1);
  mp_impl->AXI_15_ACLK(AXI_15_ACLK);
  mp_impl->AXI_15_ARESET_N(AXI_15_ARESET_N);
  mp_impl->AXI_15_WDATA_PARITY(AXI_15_WDATA_PARITY);
  mp_impl->AXI_16_ACLK(AXI_16_ACLK);
  mp_impl->AXI_16_ARESET_N(AXI_16_ARESET_N);
  mp_impl->AXI_16_WDATA_PARITY(AXI_16_WDATA_PARITY);
  mp_impl->APB_0_PCLK(APB_0_PCLK);
  mp_impl->APB_0_PRESET_N(APB_0_PRESET_N);
  mp_impl->APB_1_PCLK(APB_1_PCLK);
  mp_impl->APB_1_PRESET_N(APB_1_PRESET_N);
  mp_impl->AXI_15_RDATA_PARITY(AXI_15_RDATA_PARITY);
  mp_impl->AXI_16_RDATA_PARITY(AXI_16_RDATA_PARITY);
  mp_impl->apb_complete_0(apb_complete_0);
  mp_impl->apb_complete_1(apb_complete_1);
  mp_impl->DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP);
  mp_impl->DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP);
  mp_impl->DRAM_1_STAT_CATTRIP(DRAM_1_STAT_CATTRIP);
  mp_impl->DRAM_1_STAT_TEMP(DRAM_1_STAT_TEMP);

  // initialize transactors
  mp_SAXI_15_8HI_transactor = NULL;
  mp_AXI_15_ARLEN_converter = NULL;
  mp_AXI_15_AWLEN_converter = NULL;
  mp_SAXI_16_8HI_transactor = NULL;
  mp_AXI_16_ARLEN_converter = NULL;
  mp_AXI_16_AWLEN_converter = NULL;

  // initialize socket stubs

}

void qdma_hbm_bd_hbm_0_0::before_end_of_elaboration()
{
  // configure 'SAXI_15_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_15_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_15_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_15_8HI_transactor_param_props;
    SAXI_15_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_15_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_15_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_15_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_15_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_15_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_15_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_15_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_15_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_15_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_15_8HI_transactor", SAXI_15_8HI_transactor_param_props);

    // SAXI_15_8HI' transactor ports

    mp_SAXI_15_8HI_transactor->ARADDR(AXI_15_ARADDR);
    mp_SAXI_15_8HI_transactor->ARBURST(AXI_15_ARBURST);
    mp_SAXI_15_8HI_transactor->ARID(AXI_15_ARID);
    mp_AXI_15_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_ARLEN_converter");
    mp_AXI_15_ARLEN_converter->vector_in(AXI_15_ARLEN);
    mp_AXI_15_ARLEN_converter->vector_out(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARLEN(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARREADY(AXI_15_ARREADY);
    mp_SAXI_15_8HI_transactor->ARSIZE(AXI_15_ARSIZE);
    mp_SAXI_15_8HI_transactor->ARVALID(AXI_15_ARVALID);
    mp_SAXI_15_8HI_transactor->AWADDR(AXI_15_AWADDR);
    mp_SAXI_15_8HI_transactor->AWBURST(AXI_15_AWBURST);
    mp_SAXI_15_8HI_transactor->AWID(AXI_15_AWID);
    mp_AXI_15_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_AWLEN_converter");
    mp_AXI_15_AWLEN_converter->vector_in(AXI_15_AWLEN);
    mp_AXI_15_AWLEN_converter->vector_out(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWLEN(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWREADY(AXI_15_AWREADY);
    mp_SAXI_15_8HI_transactor->AWSIZE(AXI_15_AWSIZE);
    mp_SAXI_15_8HI_transactor->AWVALID(AXI_15_AWVALID);
    mp_SAXI_15_8HI_transactor->BID(AXI_15_BID);
    mp_SAXI_15_8HI_transactor->BREADY(AXI_15_BREADY);
    mp_SAXI_15_8HI_transactor->BRESP(AXI_15_BRESP);
    mp_SAXI_15_8HI_transactor->BVALID(AXI_15_BVALID);
    mp_SAXI_15_8HI_transactor->RDATA(AXI_15_RDATA);
    mp_SAXI_15_8HI_transactor->RID(AXI_15_RID);
    mp_SAXI_15_8HI_transactor->RLAST(AXI_15_RLAST);
    mp_SAXI_15_8HI_transactor->RREADY(AXI_15_RREADY);
    mp_SAXI_15_8HI_transactor->RRESP(AXI_15_RRESP);
    mp_SAXI_15_8HI_transactor->RVALID(AXI_15_RVALID);
    mp_SAXI_15_8HI_transactor->WDATA(AXI_15_WDATA);
    mp_SAXI_15_8HI_transactor->WLAST(AXI_15_WLAST);
    mp_SAXI_15_8HI_transactor->WREADY(AXI_15_WREADY);
    mp_SAXI_15_8HI_transactor->WSTRB(AXI_15_WSTRB);
    mp_SAXI_15_8HI_transactor->WVALID(AXI_15_WVALID);
    mp_SAXI_15_8HI_transactor->CLK(AXI_15_ACLK);
    m_SAXI_15_8HI_transactor_rst_signal.write(1);
    mp_SAXI_15_8HI_transactor->RST(m_SAXI_15_8HI_transactor_rst_signal);

    // SAXI_15_8HI' transactor sockets

    mp_impl->SAXI_15_8HI_rd_socket->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_impl->SAXI_15_8HI_wr_socket->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
  }
  else
  {
  }

  // configure 'SAXI_16_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_16_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_16_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_16_8HI_transactor_param_props;
    SAXI_16_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_16_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_16_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_16_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_16_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_16_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_16_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_16_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_16_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_16_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_16_8HI_transactor", SAXI_16_8HI_transactor_param_props);

    // SAXI_16_8HI' transactor ports

    mp_SAXI_16_8HI_transactor->ARADDR(AXI_16_ARADDR);
    mp_SAXI_16_8HI_transactor->ARBURST(AXI_16_ARBURST);
    mp_SAXI_16_8HI_transactor->ARID(AXI_16_ARID);
    mp_AXI_16_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_ARLEN_converter");
    mp_AXI_16_ARLEN_converter->vector_in(AXI_16_ARLEN);
    mp_AXI_16_ARLEN_converter->vector_out(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARLEN(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARREADY(AXI_16_ARREADY);
    mp_SAXI_16_8HI_transactor->ARSIZE(AXI_16_ARSIZE);
    mp_SAXI_16_8HI_transactor->ARVALID(AXI_16_ARVALID);
    mp_SAXI_16_8HI_transactor->AWADDR(AXI_16_AWADDR);
    mp_SAXI_16_8HI_transactor->AWBURST(AXI_16_AWBURST);
    mp_SAXI_16_8HI_transactor->AWID(AXI_16_AWID);
    mp_AXI_16_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_AWLEN_converter");
    mp_AXI_16_AWLEN_converter->vector_in(AXI_16_AWLEN);
    mp_AXI_16_AWLEN_converter->vector_out(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWLEN(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWREADY(AXI_16_AWREADY);
    mp_SAXI_16_8HI_transactor->AWSIZE(AXI_16_AWSIZE);
    mp_SAXI_16_8HI_transactor->AWVALID(AXI_16_AWVALID);
    mp_SAXI_16_8HI_transactor->BID(AXI_16_BID);
    mp_SAXI_16_8HI_transactor->BREADY(AXI_16_BREADY);
    mp_SAXI_16_8HI_transactor->BRESP(AXI_16_BRESP);
    mp_SAXI_16_8HI_transactor->BVALID(AXI_16_BVALID);
    mp_SAXI_16_8HI_transactor->RDATA(AXI_16_RDATA);
    mp_SAXI_16_8HI_transactor->RID(AXI_16_RID);
    mp_SAXI_16_8HI_transactor->RLAST(AXI_16_RLAST);
    mp_SAXI_16_8HI_transactor->RREADY(AXI_16_RREADY);
    mp_SAXI_16_8HI_transactor->RRESP(AXI_16_RRESP);
    mp_SAXI_16_8HI_transactor->RVALID(AXI_16_RVALID);
    mp_SAXI_16_8HI_transactor->WDATA(AXI_16_WDATA);
    mp_SAXI_16_8HI_transactor->WLAST(AXI_16_WLAST);
    mp_SAXI_16_8HI_transactor->WREADY(AXI_16_WREADY);
    mp_SAXI_16_8HI_transactor->WSTRB(AXI_16_WSTRB);
    mp_SAXI_16_8HI_transactor->WVALID(AXI_16_WVALID);
    mp_SAXI_16_8HI_transactor->CLK(AXI_16_ACLK);
    m_SAXI_16_8HI_transactor_rst_signal.write(1);
    mp_SAXI_16_8HI_transactor->RST(m_SAXI_16_8HI_transactor_rst_signal);

    // SAXI_16_8HI' transactor sockets

    mp_impl->SAXI_16_8HI_rd_socket->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_impl->SAXI_16_8HI_wr_socket->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
  }
  else
  {
  }

}

#endif // XILINX_SIMULATOR




#ifdef XM_SYSTEMC
qdma_hbm_bd_hbm_0_0::qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm) : qdma_hbm_bd_hbm_0_0_sc(nm), HBM_REF_CLK_0("HBM_REF_CLK_0"), HBM_REF_CLK_1("HBM_REF_CLK_1"), AXI_15_ACLK("AXI_15_ACLK"), AXI_15_ARESET_N("AXI_15_ARESET_N"), AXI_15_ARADDR("AXI_15_ARADDR"), AXI_15_ARBURST("AXI_15_ARBURST"), AXI_15_ARID("AXI_15_ARID"), AXI_15_ARLEN("AXI_15_ARLEN"), AXI_15_ARSIZE("AXI_15_ARSIZE"), AXI_15_ARVALID("AXI_15_ARVALID"), AXI_15_AWADDR("AXI_15_AWADDR"), AXI_15_AWBURST("AXI_15_AWBURST"), AXI_15_AWID("AXI_15_AWID"), AXI_15_AWLEN("AXI_15_AWLEN"), AXI_15_AWSIZE("AXI_15_AWSIZE"), AXI_15_AWVALID("AXI_15_AWVALID"), AXI_15_RREADY("AXI_15_RREADY"), AXI_15_BREADY("AXI_15_BREADY"), AXI_15_WDATA("AXI_15_WDATA"), AXI_15_WLAST("AXI_15_WLAST"), AXI_15_WSTRB("AXI_15_WSTRB"), AXI_15_WDATA_PARITY("AXI_15_WDATA_PARITY"), AXI_15_WVALID("AXI_15_WVALID"), AXI_16_ACLK("AXI_16_ACLK"), AXI_16_ARESET_N("AXI_16_ARESET_N"), AXI_16_ARADDR("AXI_16_ARADDR"), AXI_16_ARBURST("AXI_16_ARBURST"), AXI_16_ARID("AXI_16_ARID"), AXI_16_ARLEN("AXI_16_ARLEN"), AXI_16_ARSIZE("AXI_16_ARSIZE"), AXI_16_ARVALID("AXI_16_ARVALID"), AXI_16_AWADDR("AXI_16_AWADDR"), AXI_16_AWBURST("AXI_16_AWBURST"), AXI_16_AWID("AXI_16_AWID"), AXI_16_AWLEN("AXI_16_AWLEN"), AXI_16_AWSIZE("AXI_16_AWSIZE"), AXI_16_AWVALID("AXI_16_AWVALID"), AXI_16_RREADY("AXI_16_RREADY"), AXI_16_BREADY("AXI_16_BREADY"), AXI_16_WDATA("AXI_16_WDATA"), AXI_16_WLAST("AXI_16_WLAST"), AXI_16_WSTRB("AXI_16_WSTRB"), AXI_16_WDATA_PARITY("AXI_16_WDATA_PARITY"), AXI_16_WVALID("AXI_16_WVALID"), APB_0_PCLK("APB_0_PCLK"), APB_0_PRESET_N("APB_0_PRESET_N"), APB_1_PCLK("APB_1_PCLK"), APB_1_PRESET_N("APB_1_PRESET_N"), AXI_15_ARREADY("AXI_15_ARREADY"), AXI_15_AWREADY("AXI_15_AWREADY"), AXI_15_RDATA_PARITY("AXI_15_RDATA_PARITY"), AXI_15_RDATA("AXI_15_RDATA"), AXI_15_RID("AXI_15_RID"), AXI_15_RLAST("AXI_15_RLAST"), AXI_15_RRESP("AXI_15_RRESP"), AXI_15_RVALID("AXI_15_RVALID"), AXI_15_WREADY("AXI_15_WREADY"), AXI_15_BID("AXI_15_BID"), AXI_15_BRESP("AXI_15_BRESP"), AXI_15_BVALID("AXI_15_BVALID"), AXI_16_ARREADY("AXI_16_ARREADY"), AXI_16_AWREADY("AXI_16_AWREADY"), AXI_16_RDATA_PARITY("AXI_16_RDATA_PARITY"), AXI_16_RDATA("AXI_16_RDATA"), AXI_16_RID("AXI_16_RID"), AXI_16_RLAST("AXI_16_RLAST"), AXI_16_RRESP("AXI_16_RRESP"), AXI_16_RVALID("AXI_16_RVALID"), AXI_16_WREADY("AXI_16_WREADY"), AXI_16_BID("AXI_16_BID"), AXI_16_BRESP("AXI_16_BRESP"), AXI_16_BVALID("AXI_16_BVALID"), apb_complete_0("apb_complete_0"), apb_complete_1("apb_complete_1"), DRAM_0_STAT_CATTRIP("DRAM_0_STAT_CATTRIP"), DRAM_0_STAT_TEMP("DRAM_0_STAT_TEMP"), DRAM_1_STAT_CATTRIP("DRAM_1_STAT_CATTRIP"), DRAM_1_STAT_TEMP("DRAM_1_STAT_TEMP")
{

  // initialize pins
  mp_impl->HBM_REF_CLK_0(HBM_REF_CLK_0);
  mp_impl->HBM_REF_CLK_1(HBM_REF_CLK_1);
  mp_impl->AXI_15_ACLK(AXI_15_ACLK);
  mp_impl->AXI_15_ARESET_N(AXI_15_ARESET_N);
  mp_impl->AXI_15_WDATA_PARITY(AXI_15_WDATA_PARITY);
  mp_impl->AXI_16_ACLK(AXI_16_ACLK);
  mp_impl->AXI_16_ARESET_N(AXI_16_ARESET_N);
  mp_impl->AXI_16_WDATA_PARITY(AXI_16_WDATA_PARITY);
  mp_impl->APB_0_PCLK(APB_0_PCLK);
  mp_impl->APB_0_PRESET_N(APB_0_PRESET_N);
  mp_impl->APB_1_PCLK(APB_1_PCLK);
  mp_impl->APB_1_PRESET_N(APB_1_PRESET_N);
  mp_impl->AXI_15_RDATA_PARITY(AXI_15_RDATA_PARITY);
  mp_impl->AXI_16_RDATA_PARITY(AXI_16_RDATA_PARITY);
  mp_impl->apb_complete_0(apb_complete_0);
  mp_impl->apb_complete_1(apb_complete_1);
  mp_impl->DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP);
  mp_impl->DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP);
  mp_impl->DRAM_1_STAT_CATTRIP(DRAM_1_STAT_CATTRIP);
  mp_impl->DRAM_1_STAT_TEMP(DRAM_1_STAT_TEMP);

  // initialize transactors
  mp_SAXI_15_8HI_transactor = NULL;
  mp_AXI_15_ARLEN_converter = NULL;
  mp_AXI_15_AWLEN_converter = NULL;
  mp_SAXI_16_8HI_transactor = NULL;
  mp_AXI_16_ARLEN_converter = NULL;
  mp_AXI_16_AWLEN_converter = NULL;

  // initialize socket stubs

}

void qdma_hbm_bd_hbm_0_0::before_end_of_elaboration()
{
  // configure 'SAXI_15_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_15_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_15_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_15_8HI_transactor_param_props;
    SAXI_15_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_15_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_15_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_15_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_15_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_15_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_15_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_15_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_15_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_15_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_15_8HI_transactor", SAXI_15_8HI_transactor_param_props);

    // SAXI_15_8HI' transactor ports

    mp_SAXI_15_8HI_transactor->ARADDR(AXI_15_ARADDR);
    mp_SAXI_15_8HI_transactor->ARBURST(AXI_15_ARBURST);
    mp_SAXI_15_8HI_transactor->ARID(AXI_15_ARID);
    mp_AXI_15_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_ARLEN_converter");
    mp_AXI_15_ARLEN_converter->vector_in(AXI_15_ARLEN);
    mp_AXI_15_ARLEN_converter->vector_out(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARLEN(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARREADY(AXI_15_ARREADY);
    mp_SAXI_15_8HI_transactor->ARSIZE(AXI_15_ARSIZE);
    mp_SAXI_15_8HI_transactor->ARVALID(AXI_15_ARVALID);
    mp_SAXI_15_8HI_transactor->AWADDR(AXI_15_AWADDR);
    mp_SAXI_15_8HI_transactor->AWBURST(AXI_15_AWBURST);
    mp_SAXI_15_8HI_transactor->AWID(AXI_15_AWID);
    mp_AXI_15_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_AWLEN_converter");
    mp_AXI_15_AWLEN_converter->vector_in(AXI_15_AWLEN);
    mp_AXI_15_AWLEN_converter->vector_out(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWLEN(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWREADY(AXI_15_AWREADY);
    mp_SAXI_15_8HI_transactor->AWSIZE(AXI_15_AWSIZE);
    mp_SAXI_15_8HI_transactor->AWVALID(AXI_15_AWVALID);
    mp_SAXI_15_8HI_transactor->BID(AXI_15_BID);
    mp_SAXI_15_8HI_transactor->BREADY(AXI_15_BREADY);
    mp_SAXI_15_8HI_transactor->BRESP(AXI_15_BRESP);
    mp_SAXI_15_8HI_transactor->BVALID(AXI_15_BVALID);
    mp_SAXI_15_8HI_transactor->RDATA(AXI_15_RDATA);
    mp_SAXI_15_8HI_transactor->RID(AXI_15_RID);
    mp_SAXI_15_8HI_transactor->RLAST(AXI_15_RLAST);
    mp_SAXI_15_8HI_transactor->RREADY(AXI_15_RREADY);
    mp_SAXI_15_8HI_transactor->RRESP(AXI_15_RRESP);
    mp_SAXI_15_8HI_transactor->RVALID(AXI_15_RVALID);
    mp_SAXI_15_8HI_transactor->WDATA(AXI_15_WDATA);
    mp_SAXI_15_8HI_transactor->WLAST(AXI_15_WLAST);
    mp_SAXI_15_8HI_transactor->WREADY(AXI_15_WREADY);
    mp_SAXI_15_8HI_transactor->WSTRB(AXI_15_WSTRB);
    mp_SAXI_15_8HI_transactor->WVALID(AXI_15_WVALID);
    mp_SAXI_15_8HI_transactor->CLK(AXI_15_ACLK);
    m_SAXI_15_8HI_transactor_rst_signal.write(1);
    mp_SAXI_15_8HI_transactor->RST(m_SAXI_15_8HI_transactor_rst_signal);

    // SAXI_15_8HI' transactor sockets

    mp_impl->SAXI_15_8HI_rd_socket->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_impl->SAXI_15_8HI_wr_socket->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
  }
  else
  {
  }

  // configure 'SAXI_16_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_16_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_16_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_16_8HI_transactor_param_props;
    SAXI_16_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_16_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_16_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_16_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_16_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_16_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_16_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_16_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_16_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_16_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_16_8HI_transactor", SAXI_16_8HI_transactor_param_props);

    // SAXI_16_8HI' transactor ports

    mp_SAXI_16_8HI_transactor->ARADDR(AXI_16_ARADDR);
    mp_SAXI_16_8HI_transactor->ARBURST(AXI_16_ARBURST);
    mp_SAXI_16_8HI_transactor->ARID(AXI_16_ARID);
    mp_AXI_16_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_ARLEN_converter");
    mp_AXI_16_ARLEN_converter->vector_in(AXI_16_ARLEN);
    mp_AXI_16_ARLEN_converter->vector_out(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARLEN(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARREADY(AXI_16_ARREADY);
    mp_SAXI_16_8HI_transactor->ARSIZE(AXI_16_ARSIZE);
    mp_SAXI_16_8HI_transactor->ARVALID(AXI_16_ARVALID);
    mp_SAXI_16_8HI_transactor->AWADDR(AXI_16_AWADDR);
    mp_SAXI_16_8HI_transactor->AWBURST(AXI_16_AWBURST);
    mp_SAXI_16_8HI_transactor->AWID(AXI_16_AWID);
    mp_AXI_16_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_AWLEN_converter");
    mp_AXI_16_AWLEN_converter->vector_in(AXI_16_AWLEN);
    mp_AXI_16_AWLEN_converter->vector_out(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWLEN(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWREADY(AXI_16_AWREADY);
    mp_SAXI_16_8HI_transactor->AWSIZE(AXI_16_AWSIZE);
    mp_SAXI_16_8HI_transactor->AWVALID(AXI_16_AWVALID);
    mp_SAXI_16_8HI_transactor->BID(AXI_16_BID);
    mp_SAXI_16_8HI_transactor->BREADY(AXI_16_BREADY);
    mp_SAXI_16_8HI_transactor->BRESP(AXI_16_BRESP);
    mp_SAXI_16_8HI_transactor->BVALID(AXI_16_BVALID);
    mp_SAXI_16_8HI_transactor->RDATA(AXI_16_RDATA);
    mp_SAXI_16_8HI_transactor->RID(AXI_16_RID);
    mp_SAXI_16_8HI_transactor->RLAST(AXI_16_RLAST);
    mp_SAXI_16_8HI_transactor->RREADY(AXI_16_RREADY);
    mp_SAXI_16_8HI_transactor->RRESP(AXI_16_RRESP);
    mp_SAXI_16_8HI_transactor->RVALID(AXI_16_RVALID);
    mp_SAXI_16_8HI_transactor->WDATA(AXI_16_WDATA);
    mp_SAXI_16_8HI_transactor->WLAST(AXI_16_WLAST);
    mp_SAXI_16_8HI_transactor->WREADY(AXI_16_WREADY);
    mp_SAXI_16_8HI_transactor->WSTRB(AXI_16_WSTRB);
    mp_SAXI_16_8HI_transactor->WVALID(AXI_16_WVALID);
    mp_SAXI_16_8HI_transactor->CLK(AXI_16_ACLK);
    m_SAXI_16_8HI_transactor_rst_signal.write(1);
    mp_SAXI_16_8HI_transactor->RST(m_SAXI_16_8HI_transactor_rst_signal);

    // SAXI_16_8HI' transactor sockets

    mp_impl->SAXI_16_8HI_rd_socket->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_impl->SAXI_16_8HI_wr_socket->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
  }
  else
  {
  }

}

#endif // XM_SYSTEMC




#ifdef RIVIERA
qdma_hbm_bd_hbm_0_0::qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm) : qdma_hbm_bd_hbm_0_0_sc(nm), HBM_REF_CLK_0("HBM_REF_CLK_0"), HBM_REF_CLK_1("HBM_REF_CLK_1"), AXI_15_ACLK("AXI_15_ACLK"), AXI_15_ARESET_N("AXI_15_ARESET_N"), AXI_15_ARADDR("AXI_15_ARADDR"), AXI_15_ARBURST("AXI_15_ARBURST"), AXI_15_ARID("AXI_15_ARID"), AXI_15_ARLEN("AXI_15_ARLEN"), AXI_15_ARSIZE("AXI_15_ARSIZE"), AXI_15_ARVALID("AXI_15_ARVALID"), AXI_15_AWADDR("AXI_15_AWADDR"), AXI_15_AWBURST("AXI_15_AWBURST"), AXI_15_AWID("AXI_15_AWID"), AXI_15_AWLEN("AXI_15_AWLEN"), AXI_15_AWSIZE("AXI_15_AWSIZE"), AXI_15_AWVALID("AXI_15_AWVALID"), AXI_15_RREADY("AXI_15_RREADY"), AXI_15_BREADY("AXI_15_BREADY"), AXI_15_WDATA("AXI_15_WDATA"), AXI_15_WLAST("AXI_15_WLAST"), AXI_15_WSTRB("AXI_15_WSTRB"), AXI_15_WDATA_PARITY("AXI_15_WDATA_PARITY"), AXI_15_WVALID("AXI_15_WVALID"), AXI_16_ACLK("AXI_16_ACLK"), AXI_16_ARESET_N("AXI_16_ARESET_N"), AXI_16_ARADDR("AXI_16_ARADDR"), AXI_16_ARBURST("AXI_16_ARBURST"), AXI_16_ARID("AXI_16_ARID"), AXI_16_ARLEN("AXI_16_ARLEN"), AXI_16_ARSIZE("AXI_16_ARSIZE"), AXI_16_ARVALID("AXI_16_ARVALID"), AXI_16_AWADDR("AXI_16_AWADDR"), AXI_16_AWBURST("AXI_16_AWBURST"), AXI_16_AWID("AXI_16_AWID"), AXI_16_AWLEN("AXI_16_AWLEN"), AXI_16_AWSIZE("AXI_16_AWSIZE"), AXI_16_AWVALID("AXI_16_AWVALID"), AXI_16_RREADY("AXI_16_RREADY"), AXI_16_BREADY("AXI_16_BREADY"), AXI_16_WDATA("AXI_16_WDATA"), AXI_16_WLAST("AXI_16_WLAST"), AXI_16_WSTRB("AXI_16_WSTRB"), AXI_16_WDATA_PARITY("AXI_16_WDATA_PARITY"), AXI_16_WVALID("AXI_16_WVALID"), APB_0_PCLK("APB_0_PCLK"), APB_0_PRESET_N("APB_0_PRESET_N"), APB_1_PCLK("APB_1_PCLK"), APB_1_PRESET_N("APB_1_PRESET_N"), AXI_15_ARREADY("AXI_15_ARREADY"), AXI_15_AWREADY("AXI_15_AWREADY"), AXI_15_RDATA_PARITY("AXI_15_RDATA_PARITY"), AXI_15_RDATA("AXI_15_RDATA"), AXI_15_RID("AXI_15_RID"), AXI_15_RLAST("AXI_15_RLAST"), AXI_15_RRESP("AXI_15_RRESP"), AXI_15_RVALID("AXI_15_RVALID"), AXI_15_WREADY("AXI_15_WREADY"), AXI_15_BID("AXI_15_BID"), AXI_15_BRESP("AXI_15_BRESP"), AXI_15_BVALID("AXI_15_BVALID"), AXI_16_ARREADY("AXI_16_ARREADY"), AXI_16_AWREADY("AXI_16_AWREADY"), AXI_16_RDATA_PARITY("AXI_16_RDATA_PARITY"), AXI_16_RDATA("AXI_16_RDATA"), AXI_16_RID("AXI_16_RID"), AXI_16_RLAST("AXI_16_RLAST"), AXI_16_RRESP("AXI_16_RRESP"), AXI_16_RVALID("AXI_16_RVALID"), AXI_16_WREADY("AXI_16_WREADY"), AXI_16_BID("AXI_16_BID"), AXI_16_BRESP("AXI_16_BRESP"), AXI_16_BVALID("AXI_16_BVALID"), apb_complete_0("apb_complete_0"), apb_complete_1("apb_complete_1"), DRAM_0_STAT_CATTRIP("DRAM_0_STAT_CATTRIP"), DRAM_0_STAT_TEMP("DRAM_0_STAT_TEMP"), DRAM_1_STAT_CATTRIP("DRAM_1_STAT_CATTRIP"), DRAM_1_STAT_TEMP("DRAM_1_STAT_TEMP")
{

  // initialize pins
  mp_impl->HBM_REF_CLK_0(HBM_REF_CLK_0);
  mp_impl->HBM_REF_CLK_1(HBM_REF_CLK_1);
  mp_impl->AXI_15_ACLK(AXI_15_ACLK);
  mp_impl->AXI_15_ARESET_N(AXI_15_ARESET_N);
  mp_impl->AXI_15_WDATA_PARITY(AXI_15_WDATA_PARITY);
  mp_impl->AXI_16_ACLK(AXI_16_ACLK);
  mp_impl->AXI_16_ARESET_N(AXI_16_ARESET_N);
  mp_impl->AXI_16_WDATA_PARITY(AXI_16_WDATA_PARITY);
  mp_impl->APB_0_PCLK(APB_0_PCLK);
  mp_impl->APB_0_PRESET_N(APB_0_PRESET_N);
  mp_impl->APB_1_PCLK(APB_1_PCLK);
  mp_impl->APB_1_PRESET_N(APB_1_PRESET_N);
  mp_impl->AXI_15_RDATA_PARITY(AXI_15_RDATA_PARITY);
  mp_impl->AXI_16_RDATA_PARITY(AXI_16_RDATA_PARITY);
  mp_impl->apb_complete_0(apb_complete_0);
  mp_impl->apb_complete_1(apb_complete_1);
  mp_impl->DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP);
  mp_impl->DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP);
  mp_impl->DRAM_1_STAT_CATTRIP(DRAM_1_STAT_CATTRIP);
  mp_impl->DRAM_1_STAT_TEMP(DRAM_1_STAT_TEMP);

  // initialize transactors
  mp_SAXI_15_8HI_transactor = NULL;
  mp_AXI_15_ARLEN_converter = NULL;
  mp_AXI_15_AWLEN_converter = NULL;
  mp_SAXI_16_8HI_transactor = NULL;
  mp_AXI_16_ARLEN_converter = NULL;
  mp_AXI_16_AWLEN_converter = NULL;

  // initialize socket stubs

}

void qdma_hbm_bd_hbm_0_0::before_end_of_elaboration()
{
  // configure 'SAXI_15_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_15_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_15_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_15_8HI_transactor_param_props;
    SAXI_15_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_15_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_15_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_15_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_15_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_15_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_15_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_15_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_15_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_15_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_15_8HI_transactor", SAXI_15_8HI_transactor_param_props);

    // SAXI_15_8HI' transactor ports

    mp_SAXI_15_8HI_transactor->ARADDR(AXI_15_ARADDR);
    mp_SAXI_15_8HI_transactor->ARBURST(AXI_15_ARBURST);
    mp_SAXI_15_8HI_transactor->ARID(AXI_15_ARID);
    mp_AXI_15_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_ARLEN_converter");
    mp_AXI_15_ARLEN_converter->vector_in(AXI_15_ARLEN);
    mp_AXI_15_ARLEN_converter->vector_out(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARLEN(m_AXI_15_ARLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->ARREADY(AXI_15_ARREADY);
    mp_SAXI_15_8HI_transactor->ARSIZE(AXI_15_ARSIZE);
    mp_SAXI_15_8HI_transactor->ARVALID(AXI_15_ARVALID);
    mp_SAXI_15_8HI_transactor->AWADDR(AXI_15_AWADDR);
    mp_SAXI_15_8HI_transactor->AWBURST(AXI_15_AWBURST);
    mp_SAXI_15_8HI_transactor->AWID(AXI_15_AWID);
    mp_AXI_15_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_AWLEN_converter");
    mp_AXI_15_AWLEN_converter->vector_in(AXI_15_AWLEN);
    mp_AXI_15_AWLEN_converter->vector_out(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWLEN(m_AXI_15_AWLEN_converter_signal);
    mp_SAXI_15_8HI_transactor->AWREADY(AXI_15_AWREADY);
    mp_SAXI_15_8HI_transactor->AWSIZE(AXI_15_AWSIZE);
    mp_SAXI_15_8HI_transactor->AWVALID(AXI_15_AWVALID);
    mp_SAXI_15_8HI_transactor->BID(AXI_15_BID);
    mp_SAXI_15_8HI_transactor->BREADY(AXI_15_BREADY);
    mp_SAXI_15_8HI_transactor->BRESP(AXI_15_BRESP);
    mp_SAXI_15_8HI_transactor->BVALID(AXI_15_BVALID);
    mp_SAXI_15_8HI_transactor->RDATA(AXI_15_RDATA);
    mp_SAXI_15_8HI_transactor->RID(AXI_15_RID);
    mp_SAXI_15_8HI_transactor->RLAST(AXI_15_RLAST);
    mp_SAXI_15_8HI_transactor->RREADY(AXI_15_RREADY);
    mp_SAXI_15_8HI_transactor->RRESP(AXI_15_RRESP);
    mp_SAXI_15_8HI_transactor->RVALID(AXI_15_RVALID);
    mp_SAXI_15_8HI_transactor->WDATA(AXI_15_WDATA);
    mp_SAXI_15_8HI_transactor->WLAST(AXI_15_WLAST);
    mp_SAXI_15_8HI_transactor->WREADY(AXI_15_WREADY);
    mp_SAXI_15_8HI_transactor->WSTRB(AXI_15_WSTRB);
    mp_SAXI_15_8HI_transactor->WVALID(AXI_15_WVALID);
    mp_SAXI_15_8HI_transactor->CLK(AXI_15_ACLK);
    m_SAXI_15_8HI_transactor_rst_signal.write(1);
    mp_SAXI_15_8HI_transactor->RST(m_SAXI_15_8HI_transactor_rst_signal);

    // SAXI_15_8HI' transactor sockets

    mp_impl->SAXI_15_8HI_rd_socket->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_impl->SAXI_15_8HI_wr_socket->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
  }
  else
  {
  }

  // configure 'SAXI_16_8HI' transactor

  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_16_8HI_TLM_MODE") != 1)
  {
    // Instantiate Socket Stubs

  // 'SAXI_16_8HI' transactor parameters
    xsc::common_cpp::properties SAXI_16_8HI_transactor_param_props;
    SAXI_16_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_16_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_16_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_16_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_16_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_16_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_16_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_16_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_16_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_16_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_16_8HI_transactor", SAXI_16_8HI_transactor_param_props);

    // SAXI_16_8HI' transactor ports

    mp_SAXI_16_8HI_transactor->ARADDR(AXI_16_ARADDR);
    mp_SAXI_16_8HI_transactor->ARBURST(AXI_16_ARBURST);
    mp_SAXI_16_8HI_transactor->ARID(AXI_16_ARID);
    mp_AXI_16_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_ARLEN_converter");
    mp_AXI_16_ARLEN_converter->vector_in(AXI_16_ARLEN);
    mp_AXI_16_ARLEN_converter->vector_out(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARLEN(m_AXI_16_ARLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->ARREADY(AXI_16_ARREADY);
    mp_SAXI_16_8HI_transactor->ARSIZE(AXI_16_ARSIZE);
    mp_SAXI_16_8HI_transactor->ARVALID(AXI_16_ARVALID);
    mp_SAXI_16_8HI_transactor->AWADDR(AXI_16_AWADDR);
    mp_SAXI_16_8HI_transactor->AWBURST(AXI_16_AWBURST);
    mp_SAXI_16_8HI_transactor->AWID(AXI_16_AWID);
    mp_AXI_16_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_AWLEN_converter");
    mp_AXI_16_AWLEN_converter->vector_in(AXI_16_AWLEN);
    mp_AXI_16_AWLEN_converter->vector_out(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWLEN(m_AXI_16_AWLEN_converter_signal);
    mp_SAXI_16_8HI_transactor->AWREADY(AXI_16_AWREADY);
    mp_SAXI_16_8HI_transactor->AWSIZE(AXI_16_AWSIZE);
    mp_SAXI_16_8HI_transactor->AWVALID(AXI_16_AWVALID);
    mp_SAXI_16_8HI_transactor->BID(AXI_16_BID);
    mp_SAXI_16_8HI_transactor->BREADY(AXI_16_BREADY);
    mp_SAXI_16_8HI_transactor->BRESP(AXI_16_BRESP);
    mp_SAXI_16_8HI_transactor->BVALID(AXI_16_BVALID);
    mp_SAXI_16_8HI_transactor->RDATA(AXI_16_RDATA);
    mp_SAXI_16_8HI_transactor->RID(AXI_16_RID);
    mp_SAXI_16_8HI_transactor->RLAST(AXI_16_RLAST);
    mp_SAXI_16_8HI_transactor->RREADY(AXI_16_RREADY);
    mp_SAXI_16_8HI_transactor->RRESP(AXI_16_RRESP);
    mp_SAXI_16_8HI_transactor->RVALID(AXI_16_RVALID);
    mp_SAXI_16_8HI_transactor->WDATA(AXI_16_WDATA);
    mp_SAXI_16_8HI_transactor->WLAST(AXI_16_WLAST);
    mp_SAXI_16_8HI_transactor->WREADY(AXI_16_WREADY);
    mp_SAXI_16_8HI_transactor->WSTRB(AXI_16_WSTRB);
    mp_SAXI_16_8HI_transactor->WVALID(AXI_16_WVALID);
    mp_SAXI_16_8HI_transactor->CLK(AXI_16_ACLK);
    m_SAXI_16_8HI_transactor_rst_signal.write(1);
    mp_SAXI_16_8HI_transactor->RST(m_SAXI_16_8HI_transactor_rst_signal);

    // SAXI_16_8HI' transactor sockets

    mp_impl->SAXI_16_8HI_rd_socket->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_impl->SAXI_16_8HI_wr_socket->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
  }
  else
  {
  }

}

#endif // RIVIERA




#ifdef VCSSYSTEMC
qdma_hbm_bd_hbm_0_0::qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm) : qdma_hbm_bd_hbm_0_0_sc(nm),  HBM_REF_CLK_0("HBM_REF_CLK_0"), HBM_REF_CLK_1("HBM_REF_CLK_1"), AXI_15_ACLK("AXI_15_ACLK"), AXI_15_ARESET_N("AXI_15_ARESET_N"), AXI_15_ARADDR("AXI_15_ARADDR"), AXI_15_ARBURST("AXI_15_ARBURST"), AXI_15_ARID("AXI_15_ARID"), AXI_15_ARLEN("AXI_15_ARLEN"), AXI_15_ARSIZE("AXI_15_ARSIZE"), AXI_15_ARVALID("AXI_15_ARVALID"), AXI_15_AWADDR("AXI_15_AWADDR"), AXI_15_AWBURST("AXI_15_AWBURST"), AXI_15_AWID("AXI_15_AWID"), AXI_15_AWLEN("AXI_15_AWLEN"), AXI_15_AWSIZE("AXI_15_AWSIZE"), AXI_15_AWVALID("AXI_15_AWVALID"), AXI_15_RREADY("AXI_15_RREADY"), AXI_15_BREADY("AXI_15_BREADY"), AXI_15_WDATA("AXI_15_WDATA"), AXI_15_WLAST("AXI_15_WLAST"), AXI_15_WSTRB("AXI_15_WSTRB"), AXI_15_WDATA_PARITY("AXI_15_WDATA_PARITY"), AXI_15_WVALID("AXI_15_WVALID"), AXI_16_ACLK("AXI_16_ACLK"), AXI_16_ARESET_N("AXI_16_ARESET_N"), AXI_16_ARADDR("AXI_16_ARADDR"), AXI_16_ARBURST("AXI_16_ARBURST"), AXI_16_ARID("AXI_16_ARID"), AXI_16_ARLEN("AXI_16_ARLEN"), AXI_16_ARSIZE("AXI_16_ARSIZE"), AXI_16_ARVALID("AXI_16_ARVALID"), AXI_16_AWADDR("AXI_16_AWADDR"), AXI_16_AWBURST("AXI_16_AWBURST"), AXI_16_AWID("AXI_16_AWID"), AXI_16_AWLEN("AXI_16_AWLEN"), AXI_16_AWSIZE("AXI_16_AWSIZE"), AXI_16_AWVALID("AXI_16_AWVALID"), AXI_16_RREADY("AXI_16_RREADY"), AXI_16_BREADY("AXI_16_BREADY"), AXI_16_WDATA("AXI_16_WDATA"), AXI_16_WLAST("AXI_16_WLAST"), AXI_16_WSTRB("AXI_16_WSTRB"), AXI_16_WDATA_PARITY("AXI_16_WDATA_PARITY"), AXI_16_WVALID("AXI_16_WVALID"), APB_0_PCLK("APB_0_PCLK"), APB_0_PRESET_N("APB_0_PRESET_N"), APB_1_PCLK("APB_1_PCLK"), APB_1_PRESET_N("APB_1_PRESET_N"), AXI_15_ARREADY("AXI_15_ARREADY"), AXI_15_AWREADY("AXI_15_AWREADY"), AXI_15_RDATA_PARITY("AXI_15_RDATA_PARITY"), AXI_15_RDATA("AXI_15_RDATA"), AXI_15_RID("AXI_15_RID"), AXI_15_RLAST("AXI_15_RLAST"), AXI_15_RRESP("AXI_15_RRESP"), AXI_15_RVALID("AXI_15_RVALID"), AXI_15_WREADY("AXI_15_WREADY"), AXI_15_BID("AXI_15_BID"), AXI_15_BRESP("AXI_15_BRESP"), AXI_15_BVALID("AXI_15_BVALID"), AXI_16_ARREADY("AXI_16_ARREADY"), AXI_16_AWREADY("AXI_16_AWREADY"), AXI_16_RDATA_PARITY("AXI_16_RDATA_PARITY"), AXI_16_RDATA("AXI_16_RDATA"), AXI_16_RID("AXI_16_RID"), AXI_16_RLAST("AXI_16_RLAST"), AXI_16_RRESP("AXI_16_RRESP"), AXI_16_RVALID("AXI_16_RVALID"), AXI_16_WREADY("AXI_16_WREADY"), AXI_16_BID("AXI_16_BID"), AXI_16_BRESP("AXI_16_BRESP"), AXI_16_BVALID("AXI_16_BVALID"), apb_complete_0("apb_complete_0"), apb_complete_1("apb_complete_1"), DRAM_0_STAT_CATTRIP("DRAM_0_STAT_CATTRIP"), DRAM_0_STAT_TEMP("DRAM_0_STAT_TEMP"), DRAM_1_STAT_CATTRIP("DRAM_1_STAT_CATTRIP"), DRAM_1_STAT_TEMP("DRAM_1_STAT_TEMP")
{
  // initialize pins
  mp_impl->HBM_REF_CLK_0(HBM_REF_CLK_0);
  mp_impl->HBM_REF_CLK_1(HBM_REF_CLK_1);
  mp_impl->AXI_15_ACLK(AXI_15_ACLK);
  mp_impl->AXI_15_ARESET_N(AXI_15_ARESET_N);
  mp_impl->AXI_15_WDATA_PARITY(AXI_15_WDATA_PARITY);
  mp_impl->AXI_16_ACLK(AXI_16_ACLK);
  mp_impl->AXI_16_ARESET_N(AXI_16_ARESET_N);
  mp_impl->AXI_16_WDATA_PARITY(AXI_16_WDATA_PARITY);
  mp_impl->APB_0_PCLK(APB_0_PCLK);
  mp_impl->APB_0_PRESET_N(APB_0_PRESET_N);
  mp_impl->APB_1_PCLK(APB_1_PCLK);
  mp_impl->APB_1_PRESET_N(APB_1_PRESET_N);
  mp_impl->AXI_15_RDATA_PARITY(AXI_15_RDATA_PARITY);
  mp_impl->AXI_16_RDATA_PARITY(AXI_16_RDATA_PARITY);
  mp_impl->apb_complete_0(apb_complete_0);
  mp_impl->apb_complete_1(apb_complete_1);
  mp_impl->DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP);
  mp_impl->DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP);
  mp_impl->DRAM_1_STAT_CATTRIP(DRAM_1_STAT_CATTRIP);
  mp_impl->DRAM_1_STAT_TEMP(DRAM_1_STAT_TEMP);

  // initialize transactors
  mp_SAXI_15_8HI_transactor = NULL;
  mp_AXI_15_ARLEN_converter = NULL;
  mp_AXI_15_AWLEN_converter = NULL;
  mp_SAXI_16_8HI_transactor = NULL;
  mp_AXI_16_ARLEN_converter = NULL;
  mp_AXI_16_AWLEN_converter = NULL;

  // Instantiate Socket Stubs

  // configure SAXI_15_8HI_transactor
    xsc::common_cpp::properties SAXI_15_8HI_transactor_param_props;
    SAXI_15_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_15_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_15_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_15_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_15_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_15_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_15_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_15_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_15_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_15_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_15_8HI_transactor", SAXI_15_8HI_transactor_param_props);
  mp_SAXI_15_8HI_transactor->ARADDR(AXI_15_ARADDR);
  mp_SAXI_15_8HI_transactor->ARBURST(AXI_15_ARBURST);
  mp_SAXI_15_8HI_transactor->ARID(AXI_15_ARID);
  mp_AXI_15_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_ARLEN_converter");
  mp_AXI_15_ARLEN_converter->vector_in(AXI_15_ARLEN);
  mp_AXI_15_ARLEN_converter->vector_out(m_AXI_15_ARLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->ARLEN(m_AXI_15_ARLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->ARREADY(AXI_15_ARREADY);
  mp_SAXI_15_8HI_transactor->ARSIZE(AXI_15_ARSIZE);
  mp_SAXI_15_8HI_transactor->ARVALID(AXI_15_ARVALID);
  mp_SAXI_15_8HI_transactor->AWADDR(AXI_15_AWADDR);
  mp_SAXI_15_8HI_transactor->AWBURST(AXI_15_AWBURST);
  mp_SAXI_15_8HI_transactor->AWID(AXI_15_AWID);
  mp_AXI_15_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_AWLEN_converter");
  mp_AXI_15_AWLEN_converter->vector_in(AXI_15_AWLEN);
  mp_AXI_15_AWLEN_converter->vector_out(m_AXI_15_AWLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->AWLEN(m_AXI_15_AWLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->AWREADY(AXI_15_AWREADY);
  mp_SAXI_15_8HI_transactor->AWSIZE(AXI_15_AWSIZE);
  mp_SAXI_15_8HI_transactor->AWVALID(AXI_15_AWVALID);
  mp_SAXI_15_8HI_transactor->BID(AXI_15_BID);
  mp_SAXI_15_8HI_transactor->BREADY(AXI_15_BREADY);
  mp_SAXI_15_8HI_transactor->BRESP(AXI_15_BRESP);
  mp_SAXI_15_8HI_transactor->BVALID(AXI_15_BVALID);
  mp_SAXI_15_8HI_transactor->RDATA(AXI_15_RDATA);
  mp_SAXI_15_8HI_transactor->RID(AXI_15_RID);
  mp_SAXI_15_8HI_transactor->RLAST(AXI_15_RLAST);
  mp_SAXI_15_8HI_transactor->RREADY(AXI_15_RREADY);
  mp_SAXI_15_8HI_transactor->RRESP(AXI_15_RRESP);
  mp_SAXI_15_8HI_transactor->RVALID(AXI_15_RVALID);
  mp_SAXI_15_8HI_transactor->WDATA(AXI_15_WDATA);
  mp_SAXI_15_8HI_transactor->WLAST(AXI_15_WLAST);
  mp_SAXI_15_8HI_transactor->WREADY(AXI_15_WREADY);
  mp_SAXI_15_8HI_transactor->WSTRB(AXI_15_WSTRB);
  mp_SAXI_15_8HI_transactor->WVALID(AXI_15_WVALID);
  mp_SAXI_15_8HI_transactor->CLK(AXI_15_ACLK);
  m_SAXI_15_8HI_transactor_rst_signal.write(1);
  mp_SAXI_15_8HI_transactor->RST(m_SAXI_15_8HI_transactor_rst_signal);
  // configure SAXI_16_8HI_transactor
    xsc::common_cpp::properties SAXI_16_8HI_transactor_param_props;
    SAXI_16_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_16_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_16_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_16_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_16_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_16_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_16_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_16_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_16_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_16_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_16_8HI_transactor", SAXI_16_8HI_transactor_param_props);
  mp_SAXI_16_8HI_transactor->ARADDR(AXI_16_ARADDR);
  mp_SAXI_16_8HI_transactor->ARBURST(AXI_16_ARBURST);
  mp_SAXI_16_8HI_transactor->ARID(AXI_16_ARID);
  mp_AXI_16_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_ARLEN_converter");
  mp_AXI_16_ARLEN_converter->vector_in(AXI_16_ARLEN);
  mp_AXI_16_ARLEN_converter->vector_out(m_AXI_16_ARLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->ARLEN(m_AXI_16_ARLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->ARREADY(AXI_16_ARREADY);
  mp_SAXI_16_8HI_transactor->ARSIZE(AXI_16_ARSIZE);
  mp_SAXI_16_8HI_transactor->ARVALID(AXI_16_ARVALID);
  mp_SAXI_16_8HI_transactor->AWADDR(AXI_16_AWADDR);
  mp_SAXI_16_8HI_transactor->AWBURST(AXI_16_AWBURST);
  mp_SAXI_16_8HI_transactor->AWID(AXI_16_AWID);
  mp_AXI_16_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_AWLEN_converter");
  mp_AXI_16_AWLEN_converter->vector_in(AXI_16_AWLEN);
  mp_AXI_16_AWLEN_converter->vector_out(m_AXI_16_AWLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->AWLEN(m_AXI_16_AWLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->AWREADY(AXI_16_AWREADY);
  mp_SAXI_16_8HI_transactor->AWSIZE(AXI_16_AWSIZE);
  mp_SAXI_16_8HI_transactor->AWVALID(AXI_16_AWVALID);
  mp_SAXI_16_8HI_transactor->BID(AXI_16_BID);
  mp_SAXI_16_8HI_transactor->BREADY(AXI_16_BREADY);
  mp_SAXI_16_8HI_transactor->BRESP(AXI_16_BRESP);
  mp_SAXI_16_8HI_transactor->BVALID(AXI_16_BVALID);
  mp_SAXI_16_8HI_transactor->RDATA(AXI_16_RDATA);
  mp_SAXI_16_8HI_transactor->RID(AXI_16_RID);
  mp_SAXI_16_8HI_transactor->RLAST(AXI_16_RLAST);
  mp_SAXI_16_8HI_transactor->RREADY(AXI_16_RREADY);
  mp_SAXI_16_8HI_transactor->RRESP(AXI_16_RRESP);
  mp_SAXI_16_8HI_transactor->RVALID(AXI_16_RVALID);
  mp_SAXI_16_8HI_transactor->WDATA(AXI_16_WDATA);
  mp_SAXI_16_8HI_transactor->WLAST(AXI_16_WLAST);
  mp_SAXI_16_8HI_transactor->WREADY(AXI_16_WREADY);
  mp_SAXI_16_8HI_transactor->WSTRB(AXI_16_WSTRB);
  mp_SAXI_16_8HI_transactor->WVALID(AXI_16_WVALID);
  mp_SAXI_16_8HI_transactor->CLK(AXI_16_ACLK);
  m_SAXI_16_8HI_transactor_rst_signal.write(1);
  mp_SAXI_16_8HI_transactor->RST(m_SAXI_16_8HI_transactor_rst_signal);

  // initialize transactors stubs
  SAXI_15_8HI_transactor_target_wr_socket_stub = nullptr;
  SAXI_15_8HI_transactor_target_rd_socket_stub = nullptr;
  SAXI_16_8HI_transactor_target_wr_socket_stub = nullptr;
  SAXI_16_8HI_transactor_target_rd_socket_stub = nullptr;

}

void qdma_hbm_bd_hbm_0_0::before_end_of_elaboration()
{
  // configure 'SAXI_15_8HI' transactor
  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_15_8HI_TLM_MODE") != 1)
  {
    mp_impl->SAXI_15_8HI_rd_socket->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_impl->SAXI_15_8HI_wr_socket->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
  
  }
  else
  {
    SAXI_15_8HI_transactor_target_wr_socket_stub = new xtlm::xtlm_aximm_target_stub("wr_socket",0);
    SAXI_15_8HI_transactor_target_wr_socket_stub->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
    SAXI_15_8HI_transactor_target_rd_socket_stub = new xtlm::xtlm_aximm_target_stub("rd_socket",0);
    SAXI_15_8HI_transactor_target_rd_socket_stub->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_SAXI_15_8HI_transactor->disable_transactor();
  }

  // configure 'SAXI_16_8HI' transactor
  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_16_8HI_TLM_MODE") != 1)
  {
    mp_impl->SAXI_16_8HI_rd_socket->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_impl->SAXI_16_8HI_wr_socket->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
  
  }
  else
  {
    SAXI_16_8HI_transactor_target_wr_socket_stub = new xtlm::xtlm_aximm_target_stub("wr_socket",0);
    SAXI_16_8HI_transactor_target_wr_socket_stub->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
    SAXI_16_8HI_transactor_target_rd_socket_stub = new xtlm::xtlm_aximm_target_stub("rd_socket",0);
    SAXI_16_8HI_transactor_target_rd_socket_stub->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_SAXI_16_8HI_transactor->disable_transactor();
  }

}

#endif // VCSSYSTEMC




#ifdef MTI_SYSTEMC
qdma_hbm_bd_hbm_0_0::qdma_hbm_bd_hbm_0_0(const sc_core::sc_module_name& nm) : qdma_hbm_bd_hbm_0_0_sc(nm),  HBM_REF_CLK_0("HBM_REF_CLK_0"), HBM_REF_CLK_1("HBM_REF_CLK_1"), AXI_15_ACLK("AXI_15_ACLK"), AXI_15_ARESET_N("AXI_15_ARESET_N"), AXI_15_ARADDR("AXI_15_ARADDR"), AXI_15_ARBURST("AXI_15_ARBURST"), AXI_15_ARID("AXI_15_ARID"), AXI_15_ARLEN("AXI_15_ARLEN"), AXI_15_ARSIZE("AXI_15_ARSIZE"), AXI_15_ARVALID("AXI_15_ARVALID"), AXI_15_AWADDR("AXI_15_AWADDR"), AXI_15_AWBURST("AXI_15_AWBURST"), AXI_15_AWID("AXI_15_AWID"), AXI_15_AWLEN("AXI_15_AWLEN"), AXI_15_AWSIZE("AXI_15_AWSIZE"), AXI_15_AWVALID("AXI_15_AWVALID"), AXI_15_RREADY("AXI_15_RREADY"), AXI_15_BREADY("AXI_15_BREADY"), AXI_15_WDATA("AXI_15_WDATA"), AXI_15_WLAST("AXI_15_WLAST"), AXI_15_WSTRB("AXI_15_WSTRB"), AXI_15_WDATA_PARITY("AXI_15_WDATA_PARITY"), AXI_15_WVALID("AXI_15_WVALID"), AXI_16_ACLK("AXI_16_ACLK"), AXI_16_ARESET_N("AXI_16_ARESET_N"), AXI_16_ARADDR("AXI_16_ARADDR"), AXI_16_ARBURST("AXI_16_ARBURST"), AXI_16_ARID("AXI_16_ARID"), AXI_16_ARLEN("AXI_16_ARLEN"), AXI_16_ARSIZE("AXI_16_ARSIZE"), AXI_16_ARVALID("AXI_16_ARVALID"), AXI_16_AWADDR("AXI_16_AWADDR"), AXI_16_AWBURST("AXI_16_AWBURST"), AXI_16_AWID("AXI_16_AWID"), AXI_16_AWLEN("AXI_16_AWLEN"), AXI_16_AWSIZE("AXI_16_AWSIZE"), AXI_16_AWVALID("AXI_16_AWVALID"), AXI_16_RREADY("AXI_16_RREADY"), AXI_16_BREADY("AXI_16_BREADY"), AXI_16_WDATA("AXI_16_WDATA"), AXI_16_WLAST("AXI_16_WLAST"), AXI_16_WSTRB("AXI_16_WSTRB"), AXI_16_WDATA_PARITY("AXI_16_WDATA_PARITY"), AXI_16_WVALID("AXI_16_WVALID"), APB_0_PCLK("APB_0_PCLK"), APB_0_PRESET_N("APB_0_PRESET_N"), APB_1_PCLK("APB_1_PCLK"), APB_1_PRESET_N("APB_1_PRESET_N"), AXI_15_ARREADY("AXI_15_ARREADY"), AXI_15_AWREADY("AXI_15_AWREADY"), AXI_15_RDATA_PARITY("AXI_15_RDATA_PARITY"), AXI_15_RDATA("AXI_15_RDATA"), AXI_15_RID("AXI_15_RID"), AXI_15_RLAST("AXI_15_RLAST"), AXI_15_RRESP("AXI_15_RRESP"), AXI_15_RVALID("AXI_15_RVALID"), AXI_15_WREADY("AXI_15_WREADY"), AXI_15_BID("AXI_15_BID"), AXI_15_BRESP("AXI_15_BRESP"), AXI_15_BVALID("AXI_15_BVALID"), AXI_16_ARREADY("AXI_16_ARREADY"), AXI_16_AWREADY("AXI_16_AWREADY"), AXI_16_RDATA_PARITY("AXI_16_RDATA_PARITY"), AXI_16_RDATA("AXI_16_RDATA"), AXI_16_RID("AXI_16_RID"), AXI_16_RLAST("AXI_16_RLAST"), AXI_16_RRESP("AXI_16_RRESP"), AXI_16_RVALID("AXI_16_RVALID"), AXI_16_WREADY("AXI_16_WREADY"), AXI_16_BID("AXI_16_BID"), AXI_16_BRESP("AXI_16_BRESP"), AXI_16_BVALID("AXI_16_BVALID"), apb_complete_0("apb_complete_0"), apb_complete_1("apb_complete_1"), DRAM_0_STAT_CATTRIP("DRAM_0_STAT_CATTRIP"), DRAM_0_STAT_TEMP("DRAM_0_STAT_TEMP"), DRAM_1_STAT_CATTRIP("DRAM_1_STAT_CATTRIP"), DRAM_1_STAT_TEMP("DRAM_1_STAT_TEMP")
{
  // initialize pins
  mp_impl->HBM_REF_CLK_0(HBM_REF_CLK_0);
  mp_impl->HBM_REF_CLK_1(HBM_REF_CLK_1);
  mp_impl->AXI_15_ACLK(AXI_15_ACLK);
  mp_impl->AXI_15_ARESET_N(AXI_15_ARESET_N);
  mp_impl->AXI_15_WDATA_PARITY(AXI_15_WDATA_PARITY);
  mp_impl->AXI_16_ACLK(AXI_16_ACLK);
  mp_impl->AXI_16_ARESET_N(AXI_16_ARESET_N);
  mp_impl->AXI_16_WDATA_PARITY(AXI_16_WDATA_PARITY);
  mp_impl->APB_0_PCLK(APB_0_PCLK);
  mp_impl->APB_0_PRESET_N(APB_0_PRESET_N);
  mp_impl->APB_1_PCLK(APB_1_PCLK);
  mp_impl->APB_1_PRESET_N(APB_1_PRESET_N);
  mp_impl->AXI_15_RDATA_PARITY(AXI_15_RDATA_PARITY);
  mp_impl->AXI_16_RDATA_PARITY(AXI_16_RDATA_PARITY);
  mp_impl->apb_complete_0(apb_complete_0);
  mp_impl->apb_complete_1(apb_complete_1);
  mp_impl->DRAM_0_STAT_CATTRIP(DRAM_0_STAT_CATTRIP);
  mp_impl->DRAM_0_STAT_TEMP(DRAM_0_STAT_TEMP);
  mp_impl->DRAM_1_STAT_CATTRIP(DRAM_1_STAT_CATTRIP);
  mp_impl->DRAM_1_STAT_TEMP(DRAM_1_STAT_TEMP);

  // initialize transactors
  mp_SAXI_15_8HI_transactor = NULL;
  mp_AXI_15_ARLEN_converter = NULL;
  mp_AXI_15_AWLEN_converter = NULL;
  mp_SAXI_16_8HI_transactor = NULL;
  mp_AXI_16_ARLEN_converter = NULL;
  mp_AXI_16_AWLEN_converter = NULL;

  // Instantiate Socket Stubs

  // configure SAXI_15_8HI_transactor
    xsc::common_cpp::properties SAXI_15_8HI_transactor_param_props;
    SAXI_15_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_15_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_15_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_15_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_15_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_15_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_15_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_15_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_15_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_15_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_15_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_15_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_15_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_15_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_15_8HI_transactor", SAXI_15_8HI_transactor_param_props);
  mp_SAXI_15_8HI_transactor->ARADDR(AXI_15_ARADDR);
  mp_SAXI_15_8HI_transactor->ARBURST(AXI_15_ARBURST);
  mp_SAXI_15_8HI_transactor->ARID(AXI_15_ARID);
  mp_AXI_15_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_ARLEN_converter");
  mp_AXI_15_ARLEN_converter->vector_in(AXI_15_ARLEN);
  mp_AXI_15_ARLEN_converter->vector_out(m_AXI_15_ARLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->ARLEN(m_AXI_15_ARLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->ARREADY(AXI_15_ARREADY);
  mp_SAXI_15_8HI_transactor->ARSIZE(AXI_15_ARSIZE);
  mp_SAXI_15_8HI_transactor->ARVALID(AXI_15_ARVALID);
  mp_SAXI_15_8HI_transactor->AWADDR(AXI_15_AWADDR);
  mp_SAXI_15_8HI_transactor->AWBURST(AXI_15_AWBURST);
  mp_SAXI_15_8HI_transactor->AWID(AXI_15_AWID);
  mp_AXI_15_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_15_AWLEN_converter");
  mp_AXI_15_AWLEN_converter->vector_in(AXI_15_AWLEN);
  mp_AXI_15_AWLEN_converter->vector_out(m_AXI_15_AWLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->AWLEN(m_AXI_15_AWLEN_converter_signal);
  mp_SAXI_15_8HI_transactor->AWREADY(AXI_15_AWREADY);
  mp_SAXI_15_8HI_transactor->AWSIZE(AXI_15_AWSIZE);
  mp_SAXI_15_8HI_transactor->AWVALID(AXI_15_AWVALID);
  mp_SAXI_15_8HI_transactor->BID(AXI_15_BID);
  mp_SAXI_15_8HI_transactor->BREADY(AXI_15_BREADY);
  mp_SAXI_15_8HI_transactor->BRESP(AXI_15_BRESP);
  mp_SAXI_15_8HI_transactor->BVALID(AXI_15_BVALID);
  mp_SAXI_15_8HI_transactor->RDATA(AXI_15_RDATA);
  mp_SAXI_15_8HI_transactor->RID(AXI_15_RID);
  mp_SAXI_15_8HI_transactor->RLAST(AXI_15_RLAST);
  mp_SAXI_15_8HI_transactor->RREADY(AXI_15_RREADY);
  mp_SAXI_15_8HI_transactor->RRESP(AXI_15_RRESP);
  mp_SAXI_15_8HI_transactor->RVALID(AXI_15_RVALID);
  mp_SAXI_15_8HI_transactor->WDATA(AXI_15_WDATA);
  mp_SAXI_15_8HI_transactor->WLAST(AXI_15_WLAST);
  mp_SAXI_15_8HI_transactor->WREADY(AXI_15_WREADY);
  mp_SAXI_15_8HI_transactor->WSTRB(AXI_15_WSTRB);
  mp_SAXI_15_8HI_transactor->WVALID(AXI_15_WVALID);
  mp_SAXI_15_8HI_transactor->CLK(AXI_15_ACLK);
  m_SAXI_15_8HI_transactor_rst_signal.write(1);
  mp_SAXI_15_8HI_transactor->RST(m_SAXI_15_8HI_transactor_rst_signal);
  // configure SAXI_16_8HI_transactor
    xsc::common_cpp::properties SAXI_16_8HI_transactor_param_props;
    SAXI_16_8HI_transactor_param_props.addLong("DATA_WIDTH", "256");
    SAXI_16_8HI_transactor_param_props.addLong("FREQ_HZ", "250000000");
    SAXI_16_8HI_transactor_param_props.addLong("ID_WIDTH", "6");
    SAXI_16_8HI_transactor_param_props.addLong("ADDR_WIDTH", "34");
    SAXI_16_8HI_transactor_param_props.addLong("AWUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("ARUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("BUSER_WIDTH", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_LOCK", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_PROT", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_CACHE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_QOS", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_REGION", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_WSTRB", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_BRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RRESP", "1");
    SAXI_16_8HI_transactor_param_props.addLong("SUPPORTS_NARROW_BURST", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_OUTSTANDING", "2");
    SAXI_16_8HI_transactor_param_props.addLong("MAX_BURST_LENGTH", "16");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_READ_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("NUM_WRITE_THREADS", "1");
    SAXI_16_8HI_transactor_param_props.addLong("RUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("WUSER_BITS_PER_BYTE", "0");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_SIZE", "1");
    SAXI_16_8HI_transactor_param_props.addLong("HAS_RESET", "0");
    SAXI_16_8HI_transactor_param_props.addFloat("PHASE", "0.0");
    SAXI_16_8HI_transactor_param_props.addString("PROTOCOL", "AXI3");
    SAXI_16_8HI_transactor_param_props.addString("READ_WRITE_MODE", "READ_WRITE");
    SAXI_16_8HI_transactor_param_props.addString("CLK_DOMAIN", "qdma_hbm_bd_aclk_0");

    mp_SAXI_16_8HI_transactor = new xtlm::xaximm_pin2xtlm_t<256,34,6,1,1,1,1,1>("SAXI_16_8HI_transactor", SAXI_16_8HI_transactor_param_props);
  mp_SAXI_16_8HI_transactor->ARADDR(AXI_16_ARADDR);
  mp_SAXI_16_8HI_transactor->ARBURST(AXI_16_ARBURST);
  mp_SAXI_16_8HI_transactor->ARID(AXI_16_ARID);
  mp_AXI_16_ARLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_ARLEN_converter");
  mp_AXI_16_ARLEN_converter->vector_in(AXI_16_ARLEN);
  mp_AXI_16_ARLEN_converter->vector_out(m_AXI_16_ARLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->ARLEN(m_AXI_16_ARLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->ARREADY(AXI_16_ARREADY);
  mp_SAXI_16_8HI_transactor->ARSIZE(AXI_16_ARSIZE);
  mp_SAXI_16_8HI_transactor->ARVALID(AXI_16_ARVALID);
  mp_SAXI_16_8HI_transactor->AWADDR(AXI_16_AWADDR);
  mp_SAXI_16_8HI_transactor->AWBURST(AXI_16_AWBURST);
  mp_SAXI_16_8HI_transactor->AWID(AXI_16_AWID);
  mp_AXI_16_AWLEN_converter = new xsc::common::vector2vector_converter<4,8>("AXI_16_AWLEN_converter");
  mp_AXI_16_AWLEN_converter->vector_in(AXI_16_AWLEN);
  mp_AXI_16_AWLEN_converter->vector_out(m_AXI_16_AWLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->AWLEN(m_AXI_16_AWLEN_converter_signal);
  mp_SAXI_16_8HI_transactor->AWREADY(AXI_16_AWREADY);
  mp_SAXI_16_8HI_transactor->AWSIZE(AXI_16_AWSIZE);
  mp_SAXI_16_8HI_transactor->AWVALID(AXI_16_AWVALID);
  mp_SAXI_16_8HI_transactor->BID(AXI_16_BID);
  mp_SAXI_16_8HI_transactor->BREADY(AXI_16_BREADY);
  mp_SAXI_16_8HI_transactor->BRESP(AXI_16_BRESP);
  mp_SAXI_16_8HI_transactor->BVALID(AXI_16_BVALID);
  mp_SAXI_16_8HI_transactor->RDATA(AXI_16_RDATA);
  mp_SAXI_16_8HI_transactor->RID(AXI_16_RID);
  mp_SAXI_16_8HI_transactor->RLAST(AXI_16_RLAST);
  mp_SAXI_16_8HI_transactor->RREADY(AXI_16_RREADY);
  mp_SAXI_16_8HI_transactor->RRESP(AXI_16_RRESP);
  mp_SAXI_16_8HI_transactor->RVALID(AXI_16_RVALID);
  mp_SAXI_16_8HI_transactor->WDATA(AXI_16_WDATA);
  mp_SAXI_16_8HI_transactor->WLAST(AXI_16_WLAST);
  mp_SAXI_16_8HI_transactor->WREADY(AXI_16_WREADY);
  mp_SAXI_16_8HI_transactor->WSTRB(AXI_16_WSTRB);
  mp_SAXI_16_8HI_transactor->WVALID(AXI_16_WVALID);
  mp_SAXI_16_8HI_transactor->CLK(AXI_16_ACLK);
  m_SAXI_16_8HI_transactor_rst_signal.write(1);
  mp_SAXI_16_8HI_transactor->RST(m_SAXI_16_8HI_transactor_rst_signal);

  // initialize transactors stubs
  SAXI_15_8HI_transactor_target_wr_socket_stub = nullptr;
  SAXI_15_8HI_transactor_target_rd_socket_stub = nullptr;
  SAXI_16_8HI_transactor_target_wr_socket_stub = nullptr;
  SAXI_16_8HI_transactor_target_rd_socket_stub = nullptr;

}

void qdma_hbm_bd_hbm_0_0::before_end_of_elaboration()
{
  // configure 'SAXI_15_8HI' transactor
  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_15_8HI_TLM_MODE") != 1)
  {
    mp_impl->SAXI_15_8HI_rd_socket->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_impl->SAXI_15_8HI_wr_socket->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
  
  }
  else
  {
    SAXI_15_8HI_transactor_target_wr_socket_stub = new xtlm::xtlm_aximm_target_stub("wr_socket",0);
    SAXI_15_8HI_transactor_target_wr_socket_stub->bind(*(mp_SAXI_15_8HI_transactor->wr_socket));
    SAXI_15_8HI_transactor_target_rd_socket_stub = new xtlm::xtlm_aximm_target_stub("rd_socket",0);
    SAXI_15_8HI_transactor_target_rd_socket_stub->bind(*(mp_SAXI_15_8HI_transactor->rd_socket));
    mp_SAXI_15_8HI_transactor->disable_transactor();
  }

  // configure 'SAXI_16_8HI' transactor
  if (xsc::utils::xsc_sim_manager::getInstanceParameterInt("qdma_hbm_bd_hbm_0_0", "SAXI_16_8HI_TLM_MODE") != 1)
  {
    mp_impl->SAXI_16_8HI_rd_socket->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_impl->SAXI_16_8HI_wr_socket->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
  
  }
  else
  {
    SAXI_16_8HI_transactor_target_wr_socket_stub = new xtlm::xtlm_aximm_target_stub("wr_socket",0);
    SAXI_16_8HI_transactor_target_wr_socket_stub->bind(*(mp_SAXI_16_8HI_transactor->wr_socket));
    SAXI_16_8HI_transactor_target_rd_socket_stub = new xtlm::xtlm_aximm_target_stub("rd_socket",0);
    SAXI_16_8HI_transactor_target_rd_socket_stub->bind(*(mp_SAXI_16_8HI_transactor->rd_socket));
    mp_SAXI_16_8HI_transactor->disable_transactor();
  }

}

#endif // MTI_SYSTEMC




qdma_hbm_bd_hbm_0_0::~qdma_hbm_bd_hbm_0_0()
{
  delete mp_SAXI_15_8HI_transactor;
  delete mp_AXI_15_ARLEN_converter;
  delete mp_AXI_15_AWLEN_converter;

  delete mp_SAXI_16_8HI_transactor;
  delete mp_AXI_16_ARLEN_converter;
  delete mp_AXI_16_AWLEN_converter;

}

#ifdef MTI_SYSTEMC
SC_MODULE_EXPORT(qdma_hbm_bd_hbm_0_0);
#endif

#ifdef XM_SYSTEMC
XMSC_MODULE_EXPORT(qdma_hbm_bd_hbm_0_0);
#endif

#ifdef RIVIERA
SC_MODULE_EXPORT(qdma_hbm_bd_hbm_0_0);
SC_REGISTER_BV(256);
#endif

