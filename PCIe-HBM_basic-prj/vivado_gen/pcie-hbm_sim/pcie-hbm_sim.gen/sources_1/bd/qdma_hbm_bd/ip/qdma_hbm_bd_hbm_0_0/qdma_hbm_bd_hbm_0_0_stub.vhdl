-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
-- Date        : Wed Mar 26 16:48:15 2025
-- Host        : ogreOptiPlex running 64-bit Ubuntu 22.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/khanna/HBM/PCIe-HBM_basic-prj/vivado_gen/pcie-hbm_sim/pcie-hbm_sim.gen/sources_1/bd/qdma_hbm_bd/ip/qdma_hbm_bd_hbm_0_0/qdma_hbm_bd_hbm_0_0_stub.vhdl
-- Design      : qdma_hbm_bd_hbm_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcu55c-fsvh2892-2L-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity qdma_hbm_bd_hbm_0_0 is
  Port ( 
    HBM_REF_CLK_0 : in STD_LOGIC;
    HBM_REF_CLK_1 : in STD_LOGIC;
    AXI_15_ACLK : in STD_LOGIC;
    AXI_15_ARESET_N : in STD_LOGIC;
    AXI_15_ARADDR : in STD_LOGIC_VECTOR ( 33 downto 0 );
    AXI_15_ARBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_15_ARID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_15_ARLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    AXI_15_ARSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    AXI_15_ARVALID : in STD_LOGIC;
    AXI_15_AWADDR : in STD_LOGIC_VECTOR ( 33 downto 0 );
    AXI_15_AWBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_15_AWID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_15_AWLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    AXI_15_AWSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    AXI_15_AWVALID : in STD_LOGIC;
    AXI_15_RREADY : in STD_LOGIC;
    AXI_15_BREADY : in STD_LOGIC;
    AXI_15_WDATA : in STD_LOGIC_VECTOR ( 255 downto 0 );
    AXI_15_WLAST : in STD_LOGIC;
    AXI_15_WSTRB : in STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_15_WDATA_PARITY : in STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_15_WVALID : in STD_LOGIC;
    AXI_16_ACLK : in STD_LOGIC;
    AXI_16_ARESET_N : in STD_LOGIC;
    AXI_16_ARADDR : in STD_LOGIC_VECTOR ( 33 downto 0 );
    AXI_16_ARBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_16_ARID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_16_ARLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    AXI_16_ARSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    AXI_16_ARVALID : in STD_LOGIC;
    AXI_16_AWADDR : in STD_LOGIC_VECTOR ( 33 downto 0 );
    AXI_16_AWBURST : in STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_16_AWID : in STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_16_AWLEN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    AXI_16_AWSIZE : in STD_LOGIC_VECTOR ( 2 downto 0 );
    AXI_16_AWVALID : in STD_LOGIC;
    AXI_16_RREADY : in STD_LOGIC;
    AXI_16_BREADY : in STD_LOGIC;
    AXI_16_WDATA : in STD_LOGIC_VECTOR ( 255 downto 0 );
    AXI_16_WLAST : in STD_LOGIC;
    AXI_16_WSTRB : in STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_16_WDATA_PARITY : in STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_16_WVALID : in STD_LOGIC;
    APB_0_PCLK : in STD_LOGIC;
    APB_0_PRESET_N : in STD_LOGIC;
    APB_1_PCLK : in STD_LOGIC;
    APB_1_PRESET_N : in STD_LOGIC;
    AXI_15_ARREADY : out STD_LOGIC;
    AXI_15_AWREADY : out STD_LOGIC;
    AXI_15_RDATA_PARITY : out STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_15_RDATA : out STD_LOGIC_VECTOR ( 255 downto 0 );
    AXI_15_RID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_15_RLAST : out STD_LOGIC;
    AXI_15_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_15_RVALID : out STD_LOGIC;
    AXI_15_WREADY : out STD_LOGIC;
    AXI_15_BID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_15_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_15_BVALID : out STD_LOGIC;
    AXI_16_ARREADY : out STD_LOGIC;
    AXI_16_AWREADY : out STD_LOGIC;
    AXI_16_RDATA_PARITY : out STD_LOGIC_VECTOR ( 31 downto 0 );
    AXI_16_RDATA : out STD_LOGIC_VECTOR ( 255 downto 0 );
    AXI_16_RID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_16_RLAST : out STD_LOGIC;
    AXI_16_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_16_RVALID : out STD_LOGIC;
    AXI_16_WREADY : out STD_LOGIC;
    AXI_16_BID : out STD_LOGIC_VECTOR ( 5 downto 0 );
    AXI_16_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    AXI_16_BVALID : out STD_LOGIC;
    apb_complete_0 : out STD_LOGIC;
    apb_complete_1 : out STD_LOGIC;
    DRAM_0_STAT_CATTRIP : out STD_LOGIC;
    DRAM_0_STAT_TEMP : out STD_LOGIC_VECTOR ( 6 downto 0 );
    DRAM_1_STAT_CATTRIP : out STD_LOGIC;
    DRAM_1_STAT_TEMP : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of qdma_hbm_bd_hbm_0_0 : entity is "qdma_hbm_bd_hbm_0_0,hbm_v1_0_16,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of qdma_hbm_bd_hbm_0_0 : entity is "qdma_hbm_bd_hbm_0_0,hbm_v1_0_16,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=hbm,x_ipVersion=1.0,x_ipCoreRevision=16,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,HBM_STACK=2,SWITCH_ENABLE_00=TRUE,SWITCH_ENABLE_01=TRUE,INIT_BYPASS=FALSE,INIT_SEQ_TIMEOUT=10000000,AXI_RST_ASSERT_WIDTH=16,AXI_RST_DEASSERT_WIDTH=2,TEMP_WAIT_PERIOD_0=100000,TEMP_WAIT_PERIOD_1=100000,SWITCH_EN_0=1,SWITCH_EN_1=1,AXI_CLK_FREQ=450,AXI_CLK1_FREQ=450,HBM_REF_CLK_FREQ_0=100,HBM_REF_CLK_FREQ_1=100,HBM_CLK_FREQ_0=900,HBM_CLK_FREQ_1=900,HBM_STACK_NUM=0,CLK_SEL_00=FALSE,CLK_SEL_01=FALSE,CLK_SEL_02=FALSE,CLK_SEL_03=FALSE,CLK_SEL_04=FALSE,CLK_SEL_05=FALSE,CLK_SEL_06=FALSE,CLK_SEL_07=FALSE,CLK_SEL_08=FALSE,CLK_SEL_09=FALSE,CLK_SEL_10=FALSE,CLK_SEL_11=FALSE,CLK_SEL_12=FALSE,CLK_SEL_13=FALSE,CLK_SEL_14=FALSE,CLK_SEL_15=TRUE,CLK_SEL_16=TRUE,CLK_SEL_17=FALSE,CLK_SEL_18=FALSE,CLK_SEL_19=FALSE,CLK_SEL_20=FALSE,CLK_SEL_21=FALSE,CLK_SEL_22=FALSE,CLK_SEL_23=FALSE,CLK_SEL_24=FALSE,CLK_SEL_25=FALSE,CLK_SEL_26=FALSE,CLK_SEL_27=FALSE,CLK_SEL_28=FALSE,CLK_SEL_29=FALSE,CLK_SEL_30=FALSE,CLK_SEL_31=FALSE,DATARATE_STACK_0=1800,DATARATE_STACK_1=1800,READ_PERCENT_00=40,READ_PERCENT_01=40,READ_PERCENT_02=40,READ_PERCENT_03=40,READ_PERCENT_04=40,READ_PERCENT_05=40,READ_PERCENT_06=40,READ_PERCENT_07=40,READ_PERCENT_08=40,READ_PERCENT_09=40,READ_PERCENT_10=40,READ_PERCENT_11=40,READ_PERCENT_12=40,READ_PERCENT_13=40,READ_PERCENT_14=40,READ_PERCENT_15=40,READ_PERCENT_16=40,READ_PERCENT_17=40,READ_PERCENT_18=40,READ_PERCENT_19=40,READ_PERCENT_20=40,READ_PERCENT_21=40,READ_PERCENT_22=40,READ_PERCENT_23=40,READ_PERCENT_24=40,READ_PERCENT_25=40,READ_PERCENT_26=40,READ_PERCENT_27=40,READ_PERCENT_28=40,READ_PERCENT_29=40,READ_PERCENT_30=40,READ_PERCENT_31=40,WRITE_PERCENT_00=40,WRITE_PERCENT_01=40,WRITE_PERCENT_02=40,WRITE_PERCENT_03=40,WRITE_PERCENT_04=40,WRITE_PERCENT_05=40,WRITE_PERCENT_06=40,WRITE_PERCENT_07=40,WRITE_PERCENT_08=40,WRITE_PERCENT_09=40,WRITE_PERCENT_10=40,WRITE_PERCENT_11=40,WRITE_PERCENT_12=40,WRITE_PERCENT_13=40,WRITE_PERCENT_14=40,WRITE_PERCENT_15=40,WRITE_PERCENT_16=40,WRITE_PERCENT_17=40,WRITE_PERCENT_18=40,WRITE_PERCENT_19=40,WRITE_PERCENT_20=40,WRITE_PERCENT_21=40,WRITE_PERCENT_22=40,WRITE_PERCENT_23=40,WRITE_PERCENT_24=40,WRITE_PERCENT_25=40,WRITE_PERCENT_26=40,WRITE_PERCENT_27=40,WRITE_PERCENT_28=40,WRITE_PERCENT_29=40,WRITE_PERCENT_30=40,WRITE_PERCENT_31=40,PAGEHIT_PERCENT_00=75,PAGEHIT_PERCENT_01=75,MC_ENABLE_00=TRUE,MC_ENABLE_01=TRUE,MC_ENABLE_02=TRUE,MC_ENABLE_03=TRUE,MC_ENABLE_04=TRUE,MC_ENABLE_05=TRUE,MC_ENABLE_06=TRUE,MC_ENABLE_07=TRUE,MC_ENABLE_08=TRUE,MC_ENABLE_09=TRUE,MC_ENABLE_10=TRUE,MC_ENABLE_11=TRUE,MC_ENABLE_12=TRUE,MC_ENABLE_13=TRUE,MC_ENABLE_14=TRUE,MC_ENABLE_15=TRUE,MC_ENABLE_APB_00=TRUE,MC_ENABLE_APB_01=TRUE,PHY_ENABLE_00=TRUE,PHY_ENABLE_01=TRUE,PHY_ENABLE_02=TRUE,PHY_ENABLE_03=TRUE,PHY_ENABLE_04=TRUE,PHY_ENABLE_05=TRUE,PHY_ENABLE_06=TRUE,PHY_ENABLE_07=TRUE,PHY_ENABLE_08=TRUE,PHY_ENABLE_09=TRUE,PHY_ENABLE_10=TRUE,PHY_ENABLE_11=TRUE,PHY_ENABLE_12=TRUE,PHY_ENABLE_13=TRUE,PHY_ENABLE_14=TRUE,PHY_ENABLE_15=TRUE,PHY_ENABLE_16=TRUE,PHY_ENABLE_17=TRUE,PHY_ENABLE_18=TRUE,PHY_ENABLE_19=TRUE,PHY_ENABLE_20=TRUE,PHY_ENABLE_21=TRUE,PHY_ENABLE_22=TRUE,PHY_ENABLE_23=TRUE,PHY_ENABLE_24=TRUE,PHY_ENABLE_25=TRUE,PHY_ENABLE_26=TRUE,PHY_ENABLE_27=TRUE,PHY_ENABLE_28=TRUE,PHY_ENABLE_29=TRUE,PHY_ENABLE_30=TRUE,PHY_ENABLE_31=TRUE,PHY_ENABLE_APB_00=TRUE,PHY_ENABLE_APB_01=TRUE}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of qdma_hbm_bd_hbm_0_0 : entity is "yes";
end qdma_hbm_bd_hbm_0_0;

architecture stub of qdma_hbm_bd_hbm_0_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "HBM_REF_CLK_0,HBM_REF_CLK_1,AXI_15_ACLK,AXI_15_ARESET_N,AXI_15_ARADDR[33:0],AXI_15_ARBURST[1:0],AXI_15_ARID[5:0],AXI_15_ARLEN[3:0],AXI_15_ARSIZE[2:0],AXI_15_ARVALID,AXI_15_AWADDR[33:0],AXI_15_AWBURST[1:0],AXI_15_AWID[5:0],AXI_15_AWLEN[3:0],AXI_15_AWSIZE[2:0],AXI_15_AWVALID,AXI_15_RREADY,AXI_15_BREADY,AXI_15_WDATA[255:0],AXI_15_WLAST,AXI_15_WSTRB[31:0],AXI_15_WDATA_PARITY[31:0],AXI_15_WVALID,AXI_16_ACLK,AXI_16_ARESET_N,AXI_16_ARADDR[33:0],AXI_16_ARBURST[1:0],AXI_16_ARID[5:0],AXI_16_ARLEN[3:0],AXI_16_ARSIZE[2:0],AXI_16_ARVALID,AXI_16_AWADDR[33:0],AXI_16_AWBURST[1:0],AXI_16_AWID[5:0],AXI_16_AWLEN[3:0],AXI_16_AWSIZE[2:0],AXI_16_AWVALID,AXI_16_RREADY,AXI_16_BREADY,AXI_16_WDATA[255:0],AXI_16_WLAST,AXI_16_WSTRB[31:0],AXI_16_WDATA_PARITY[31:0],AXI_16_WVALID,APB_0_PCLK,APB_0_PRESET_N,APB_1_PCLK,APB_1_PRESET_N,AXI_15_ARREADY,AXI_15_AWREADY,AXI_15_RDATA_PARITY[31:0],AXI_15_RDATA[255:0],AXI_15_RID[5:0],AXI_15_RLAST,AXI_15_RRESP[1:0],AXI_15_RVALID,AXI_15_WREADY,AXI_15_BID[5:0],AXI_15_BRESP[1:0],AXI_15_BVALID,AXI_16_ARREADY,AXI_16_AWREADY,AXI_16_RDATA_PARITY[31:0],AXI_16_RDATA[255:0],AXI_16_RID[5:0],AXI_16_RLAST,AXI_16_RRESP[1:0],AXI_16_RVALID,AXI_16_WREADY,AXI_16_BID[5:0],AXI_16_BRESP[1:0],AXI_16_BVALID,apb_complete_0,apb_complete_1,DRAM_0_STAT_CATTRIP,DRAM_0_STAT_TEMP[6:0],DRAM_1_STAT_CATTRIP,DRAM_1_STAT_TEMP[6:0]";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of HBM_REF_CLK_0 : signal is "xilinx.com:signal:clock:1.0 HBM_REF_CLK_0 CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of HBM_REF_CLK_0 : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of HBM_REF_CLK_0 : signal is "XIL_INTERFACENAME HBM_REF_CLK_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_clk_wiz_0_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of HBM_REF_CLK_1 : signal is "xilinx.com:signal:clock:1.0 HBM_REF_CLK_1 CLK";
  attribute X_INTERFACE_MODE of HBM_REF_CLK_1 : signal is "slave";
  attribute X_INTERFACE_PARAMETER of HBM_REF_CLK_1 : signal is "XIL_INTERFACENAME HBM_REF_CLK_1, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_clk_wiz_0_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_15_ACLK : signal is "xilinx.com:signal:clock:1.0 ACLK_15_8HI CLK";
  attribute X_INTERFACE_MODE of AXI_15_ACLK : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_15_ACLK : signal is "XIL_INTERFACENAME ACLK_15_8HI, ASSOCIATED_BUSIF SAXI_15_8HI, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_aclk_0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_15_ARESET_N : signal is "xilinx.com:signal:reset:1.0 ARST_15_N RST";
  attribute X_INTERFACE_MODE of AXI_15_ARESET_N : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_15_ARESET_N : signal is "XIL_INTERFACENAME ARST_15_N, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_15_ARADDR : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARADDR";
  attribute X_INTERFACE_MODE of AXI_15_ARADDR : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_15_ARADDR : signal is "XIL_INTERFACENAME SAXI_15_8HI, DATA_WIDTH 256, PROTOCOL AXI3, FREQ_HZ 250000000, ID_WIDTH 6, ADDR_WIDTH 34, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 16, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_aclk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_15_ARBURST : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARBURST";
  attribute X_INTERFACE_INFO of AXI_15_ARID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARID";
  attribute X_INTERFACE_INFO of AXI_15_ARLEN : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARLEN";
  attribute X_INTERFACE_INFO of AXI_15_ARSIZE : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARSIZE";
  attribute X_INTERFACE_INFO of AXI_15_ARVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARVALID";
  attribute X_INTERFACE_INFO of AXI_15_AWADDR : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWADDR";
  attribute X_INTERFACE_INFO of AXI_15_AWBURST : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWBURST";
  attribute X_INTERFACE_INFO of AXI_15_AWID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWID";
  attribute X_INTERFACE_INFO of AXI_15_AWLEN : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWLEN";
  attribute X_INTERFACE_INFO of AXI_15_AWSIZE : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWSIZE";
  attribute X_INTERFACE_INFO of AXI_15_AWVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWVALID";
  attribute X_INTERFACE_INFO of AXI_15_RREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RREADY";
  attribute X_INTERFACE_INFO of AXI_15_BREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI BREADY";
  attribute X_INTERFACE_INFO of AXI_15_WDATA : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI WDATA";
  attribute X_INTERFACE_INFO of AXI_15_WLAST : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI WLAST";
  attribute X_INTERFACE_INFO of AXI_15_WSTRB : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI WSTRB";
  attribute X_INTERFACE_INFO of AXI_15_WVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI WVALID";
  attribute X_INTERFACE_INFO of AXI_16_ACLK : signal is "xilinx.com:signal:clock:1.0 ACLK_16_8HI CLK";
  attribute X_INTERFACE_MODE of AXI_16_ACLK : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_16_ACLK : signal is "XIL_INTERFACENAME ACLK_16_8HI, ASSOCIATED_BUSIF SAXI_16_8HI, FREQ_HZ 250000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_aclk_0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_16_ARESET_N : signal is "xilinx.com:signal:reset:1.0 ARST_16_N RST";
  attribute X_INTERFACE_MODE of AXI_16_ARESET_N : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_16_ARESET_N : signal is "XIL_INTERFACENAME ARST_16_N, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_16_ARADDR : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARADDR";
  attribute X_INTERFACE_MODE of AXI_16_ARADDR : signal is "slave";
  attribute X_INTERFACE_PARAMETER of AXI_16_ARADDR : signal is "XIL_INTERFACENAME SAXI_16_8HI, DATA_WIDTH 256, PROTOCOL AXI3, FREQ_HZ 250000000, ID_WIDTH 6, ADDR_WIDTH 34, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 16, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_aclk_0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_16_ARBURST : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARBURST";
  attribute X_INTERFACE_INFO of AXI_16_ARID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARID";
  attribute X_INTERFACE_INFO of AXI_16_ARLEN : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARLEN";
  attribute X_INTERFACE_INFO of AXI_16_ARSIZE : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARSIZE";
  attribute X_INTERFACE_INFO of AXI_16_ARVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARVALID";
  attribute X_INTERFACE_INFO of AXI_16_AWADDR : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWADDR";
  attribute X_INTERFACE_INFO of AXI_16_AWBURST : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWBURST";
  attribute X_INTERFACE_INFO of AXI_16_AWID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWID";
  attribute X_INTERFACE_INFO of AXI_16_AWLEN : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWLEN";
  attribute X_INTERFACE_INFO of AXI_16_AWSIZE : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWSIZE";
  attribute X_INTERFACE_INFO of AXI_16_AWVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWVALID";
  attribute X_INTERFACE_INFO of AXI_16_RREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RREADY";
  attribute X_INTERFACE_INFO of AXI_16_BREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI BREADY";
  attribute X_INTERFACE_INFO of AXI_16_WDATA : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI WDATA";
  attribute X_INTERFACE_INFO of AXI_16_WLAST : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI WLAST";
  attribute X_INTERFACE_INFO of AXI_16_WSTRB : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI WSTRB";
  attribute X_INTERFACE_INFO of AXI_16_WVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI WVALID";
  attribute X_INTERFACE_INFO of APB_0_PCLK : signal is "xilinx.com:signal:clock:1.0 PCLK_0 CLK";
  attribute X_INTERFACE_MODE of APB_0_PCLK : signal is "slave";
  attribute X_INTERFACE_PARAMETER of APB_0_PCLK : signal is "XIL_INTERFACENAME PCLK_0, ASSOCIATED_BUSIF SAPB_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_clk_wiz_0_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of APB_0_PRESET_N : signal is "xilinx.com:signal:reset:1.0 PRST_0_N RST";
  attribute X_INTERFACE_MODE of APB_0_PRESET_N : signal is "slave";
  attribute X_INTERFACE_PARAMETER of APB_0_PRESET_N : signal is "XIL_INTERFACENAME PRST_0_N, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of APB_1_PCLK : signal is "xilinx.com:signal:clock:1.0 PCLK_1 CLK";
  attribute X_INTERFACE_MODE of APB_1_PCLK : signal is "slave";
  attribute X_INTERFACE_PARAMETER of APB_1_PCLK : signal is "XIL_INTERFACENAME PCLK_1, ASSOCIATED_BUSIF SAPB_1, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN qdma_hbm_bd_clk_wiz_0_0_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of APB_1_PRESET_N : signal is "xilinx.com:signal:reset:1.0 PRST_1_N RST";
  attribute X_INTERFACE_MODE of APB_1_PRESET_N : signal is "slave";
  attribute X_INTERFACE_PARAMETER of APB_1_PRESET_N : signal is "XIL_INTERFACENAME PRST_1_N, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of AXI_15_ARREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI ARREADY";
  attribute X_INTERFACE_INFO of AXI_15_AWREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI AWREADY";
  attribute X_INTERFACE_INFO of AXI_15_RDATA : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RDATA";
  attribute X_INTERFACE_INFO of AXI_15_RID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RID";
  attribute X_INTERFACE_INFO of AXI_15_RLAST : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RLAST";
  attribute X_INTERFACE_INFO of AXI_15_RRESP : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RRESP";
  attribute X_INTERFACE_INFO of AXI_15_RVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI RVALID";
  attribute X_INTERFACE_INFO of AXI_15_WREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI WREADY";
  attribute X_INTERFACE_INFO of AXI_15_BID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI BID";
  attribute X_INTERFACE_INFO of AXI_15_BRESP : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI BRESP";
  attribute X_INTERFACE_INFO of AXI_15_BVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_15_8HI BVALID";
  attribute X_INTERFACE_INFO of AXI_16_ARREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI ARREADY";
  attribute X_INTERFACE_INFO of AXI_16_AWREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI AWREADY";
  attribute X_INTERFACE_INFO of AXI_16_RDATA : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RDATA";
  attribute X_INTERFACE_INFO of AXI_16_RID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RID";
  attribute X_INTERFACE_INFO of AXI_16_RLAST : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RLAST";
  attribute X_INTERFACE_INFO of AXI_16_RRESP : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RRESP";
  attribute X_INTERFACE_INFO of AXI_16_RVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI RVALID";
  attribute X_INTERFACE_INFO of AXI_16_WREADY : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI WREADY";
  attribute X_INTERFACE_INFO of AXI_16_BID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI BID";
  attribute X_INTERFACE_INFO of AXI_16_BRESP : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI BRESP";
  attribute X_INTERFACE_INFO of AXI_16_BVALID : signal is "xilinx.com:interface:aximm:1.0 SAXI_16_8HI BVALID";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "hbm_v1_0_16,Vivado 2024.2";
begin
end;
