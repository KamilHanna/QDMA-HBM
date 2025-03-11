
//-----------------------------------------------------------------------------
//
// (c) Copyright 2020-2025 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and
// international copyright and other intellectual property
// laws.
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
//-----------------------------------------------------------------------------
//
// Project    : PCI Express DMA 
// File       : usp_pci_exp_usrapp_tx.v
// Version    : 5.0
//-----------------------------------------------------------------------------
//--------------------------------------------------------------------------------
`include "board_common.vh"

module pci_exp_usrapp_tx #(
  parameter ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG = 0,
  parameter AXISTEN_IF_RQ_PARITY_CHECK   = 0,
  parameter AXISTEN_IF_CC_PARITY_CHECK   = 0,
  parameter AXISTEN_IF_RQ_ALIGNMENT_MODE  = "FALSE",
  parameter AXISTEN_IF_CC_ALIGNMENT_MODE  = "FALSE",
  parameter AXISTEN_IF_CQ_ALIGNMENT_MODE  = "FALSE",
  parameter AXISTEN_IF_RC_ALIGNMENT_MODE  = "FALSE",
  parameter DEV_CAP_MAX_PAYLOAD_SUPPORTED = 1,
  parameter C_DATA_WIDTH  = 512,
  parameter KEEP_WIDTH    = C_DATA_WIDTH / 32,
  parameter STRB_WIDTH    = C_DATA_WIDTH / 8,
  parameter EP_DEV_ID     = 16'h7700,
  parameter REM_WIDTH     = C_DATA_WIDTH == 512,
  parameter [5:0] RP_BAR_SIZE = 6'd11 // Number of RP BAR's Address Bit - 1
)
(
  output reg                    s_axis_rq_tlast,
  output reg [C_DATA_WIDTH-1:0] s_axis_rq_tdata,
  output     [136:0]            s_axis_rq_tuser,
  output reg [KEEP_WIDTH-1:0]   s_axis_rq_tkeep,
  input                         s_axis_rq_tready,
  output reg                    s_axis_rq_tvalid,

  output reg [C_DATA_WIDTH-1:0] s_axis_cc_tdata,
  output reg [82:0]             s_axis_cc_tuser,
  output reg                    s_axis_cc_tlast,
  output reg [KEEP_WIDTH-1:0]   s_axis_cc_tkeep,
  output reg                    s_axis_cc_tvalid,
  input                         s_axis_cc_tready,

  input  [3:0]  pcie_rq_seq_num,
  input         pcie_rq_seq_num_vld,
  input  [5:0]  pcie_rq_tag,
  input         pcie_rq_tag_vld,

  input  [1:0]  pcie_tfc_nph_av,
  input  [1:0]  pcie_tfc_npd_av,
//------------------------------------------------------
  input speed_change_done_n,
//------------------------------------------------------
  input user_clk,
  input reset,
  input user_lnk_up
);

parameter  Tcq = 1;
localparam [15:0] DMA_BYTE_CNT = 3072;

localparam  [4:0] LINK_CAP_MAX_LINK_WIDTH = 5'd16;
localparam  [4:0] LINK_CAP_MAX_LINK_SPEED = 5'd4;
localparam  [3:0] MAX_LINK_SPEED = (LINK_CAP_MAX_LINK_SPEED == 5'd16) ? 4'h5 : (LINK_CAP_MAX_LINK_SPEED==5'd8) ? 4'h4 : (LINK_CAP_MAX_LINK_SPEED==5'd4) ? 4'h3 : ((LINK_CAP_MAX_LINK_SPEED==5'd2) ? 4'h2 : 4'h1);
localparam  [5:0] BAR_ENABLED = 6'b1;
localparam [11:0] LINK_CTRL_REG_ADDR = 12'h080;
localparam [11:0] PCIE_DEV_CAP_ADDR  = 12'h074;
localparam [11:0] DEV_CTRL_REG_ADDR  = 12'h078;
localparam NUMBER_OF_PFS = 1; //1;
localparam NUM_FN=9'h1;
localparam QUEUE_PER_PF = 32;

reg [31:0] MSIX_VEC_OFFSET[NUM_FN-1:0];
reg [31:0] MSIX_PBA_OFFSET[NUM_FN-1:0];
reg  [2:0] MSIX_VEC_BAR[NUM_FN-1:0];
reg  [2:0] MSIX_PBA_BAR[NUM_FN-1:0];
reg [10:0] MSIX_TABLE_SIZE[NUM_FN-1:0];
reg [(C_DATA_WIDTH - 1):0] pcie_tlp_data;
reg [(REM_WIDTH - 1):0]    pcie_tlp_rem;

integer xdma_bar = 0;
integer user_bar = 0;

localparam C_NUM_USR_IRQ       = 16;
localparam MSIX_CTRL_REG_ADDR  = 12'h060;
localparam MSIX_VEC_TABLE_A    = 12'h64;
localparam MSIX_PBA_TABLE_A    = 12'h68;
localparam QUEUE_PTR_PF_ADDR   = 32'h00018000;
localparam CMPT_ADDR = 32'h3000;
localparam H2C_ADDR  = 32'h2000;
localparam C2H_ADDR  = 32'h2800;

/* Local Variables */
integer                         i, j, k;
// NOTE: The first 32 bits of DATA_STORE are reserved for the register write task!
reg [7:0]  DATA_STORE   [16383:0]; // For Downstream Direction Data Storage
reg [7:0]  DATA_STORE_2 [(2**(RP_BAR_SIZE+1))-1:0]; // For Upstream Direction Data Storage
reg [31:0] ADDRESS_32_L;
reg [31:0] ADDRESS_32_H;
reg [63:0] ADDRESS_64;
reg [15:0] EP_BUS_DEV_FNS_INIT;
reg [15:0] EP_BUS_DEV_FNS;
reg [15:0] RP_BUS_DEV_FNS;
reg [2:0]  DEFAULT_TC;
reg [9:0]  DEFAULT_LENGTH;
reg [3:0]  DEFAULT_BE_LAST_DW;
reg [3:0]  DEFAULT_BE_FIRST_DW;
reg [1:0]  DEFAULT_ATTR;
reg [7:0]  DEFAULT_TAG;
reg [3:0]  DEFAULT_COMP;
reg [11:0] EXT_REG_ADDR;
reg        TD;
reg        EP;
reg [15:0] VENDOR_ID;
reg [9:0]  LENGTH;         // For 1DW config and IO transactions
reg [9:0]  CFG_DWADDR;

event test_begin;

reg [31:0] P_ADDRESS_MASK;
reg [31:0] P_READ_DATA;      // will store the 1st DW (lo) of a PCIE read completion
reg [31:0] P_READ_DATA_2;    // will store the 2nd DW (hi) of a PCIE read completion
reg        P_READ_DATA_VALID;
reg [31:0] P_WRITE_DATA;
reg [31:0] data;

reg error_check;
reg set_malformed;

// BAR Init variables
reg [32:0] BAR_INIT_P_BAR[6:0];         // 6 corresponds to Expansion ROM
                                        // note that bit 32 is for overflow checking
reg [31:0] BAR_INIT_P_BAR_RANGE[6:0];   // 6 corresponds to Expansion ROM
reg [1:0]  BAR_INIT_P_BAR_ENABLED[6:0]; // 6 corresponds to Expansion ROM
                                        // 0 = disabled;  1 = io mapped;  2 = mem32 mapped;  3 = mem64 mapped

reg [31:0] BAR_INIT_P_MEM64_HI_START;   // start address for hi memory space
reg [31:0] BAR_INIT_P_MEM64_LO_START;   // start address for hi memory space
reg [32:0] BAR_INIT_P_MEM32_START;      // start address for low memory space
                                        // top bit used for overflow indicator
reg [32:0] BAR_INIT_P_IO_START;         // start address for io space
reg [100:0]BAR_INIT_MESSAGE[3:0];       // to be used to display info to user

reg [32:0] BAR_INIT_TEMP;

reg OUT_OF_LO_MEM; // flags to indicate out of mem, mem64, and io
reg OUT_OF_IO;
reg OUT_OF_HI_MEM;

integer NUMBER_OF_IO_BARS;
integer NUMBER_OF_MEM32_BARS; // Not counting the Mem32 EROM space
integer NUMBER_OF_MEM64_BARS;

reg     [3:0]  ii;
integer        jj;
integer        kk;
reg     [3:0]  pfIndex = 0;
reg     [3:0]  pfTestIteration = 0;
reg     [3:0]  pf_loop_index = 0;
reg            dmaTestDone;

reg     [31:0] DEV_VEN_ID;             // holds device and vendor id
integer        PIO_MAX_NUM_BLOCK_RAMS; // holds the max number of block RAMS
reg     [31:0] PIO_MAX_MEMORY;

reg pio_check_design; // boolean value to check PCI Express BAR configuration against
                      // limitations of PIO design. Setting this to true will cause the
                      // testbench to check if the core has been configured for more than
                      // one IO space, one general purpose Mem32 space (not counting
                      // the Mem32 EROM space), and one Mem64 space.

reg cpld_to;          // boolean value to indicate if time out has occured while waiting for cpld
reg cpld_to_finish;   // boolean value to indicate to $finish on cpld_to

reg verbose;          // boolean value to display additional info to stdout

wire        user_lnk_up_n;
wire [63:0] s_axis_cc_tparity;
wire [63:0] s_axis_rq_tparity;

reg[255:0] testname;
integer    test_vars [31:0];
reg  [7:0] exp_tag;
reg  [7:0] expect_cpld_payload [4095:0];
reg  [7:0] expect_msgd_payload [4095:0];
reg  [7:0] expect_memwr_payload [4095:0];
reg  [7:0] expect_memwr64_payload [4095:0];
reg  [7:0] expect_cfgwr_payload [3:0];
reg        expect_status;
reg        expect_finish_check;
reg        testError;
reg[136:0] s_axis_rq_tuser_wo_parity;
reg [16:0] MM_wb_sts_pidx;
reg [16:0] MM_wb_sts_cidx;
reg [10:0] axi_mm_q;
reg [10:0] axi_st_q;
reg [10:0] axi_st_q_phy;
reg [10:0] pf0_qmax;
reg [10:0] pf1_qmax;
reg[255:0] wr_dat;
reg [31:0] wr_add;
reg [15:0] data_tmp = 0;
reg        test_state =0;
reg [10:0] qid;
reg  [7:0] fnc = 8'h0;

assign s_axis_rq_tuser = {(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0),s_axis_rq_tuser_wo_parity[72:0]};

assign user_lnk_up_n = ~user_lnk_up;

integer desc_count = 0;
integer loop_timeout = 0;

reg [15:0] EP_DEV_ID1;
reg [31:0] h2c_status = 32'h0;
reg [31:0] c2h_status = 32'h0;
reg [31:0] int_req_reg;

/************************************************************
  Initial Statements
*************************************************************/
initial begin
  s_axis_rq_tlast   = 0;
  s_axis_rq_tdata   = 0;
  s_axis_rq_tuser_wo_parity = 0;
  s_axis_rq_tkeep   = 0;
  s_axis_rq_tvalid  = 0;

  s_axis_cc_tdata   = 0;
  s_axis_cc_tuser   = 0;
  s_axis_cc_tlast   = 0;
  s_axis_cc_tkeep   = 0;
  s_axis_cc_tvalid  = 0;

  ADDRESS_32_L   = 32'b1011_1110_1110_1111_1100_1010_1111_1110;
  ADDRESS_32_H   = 32'b1011_1110_1110_1111_1100_1010_1111_1110;
  ADDRESS_64     = { ADDRESS_32_H, ADDRESS_32_L };
//EP_BUS_DEV_FNS = 16'b0000_0001_0000_0000;
//RP_BUS_DEV_FNS = 16'b0000_0000_0000_0000;
  EP_BUS_DEV_FNS_INIT  = 16'b0000_0001_0000_0000;
  EP_BUS_DEV_FNS = 16'b0000_0001_0000_0000;
  RP_BUS_DEV_FNS = 16'b0000_0000_0000_0000;
  DEFAULT_TC     = 3'b000;
  DEFAULT_LENGTH = 10'h000;
  DEFAULT_BE_LAST_DW  = 4'h0;
  DEFAULT_BE_FIRST_DW = 4'h0;
  DEFAULT_ATTR = 2'b01;
  DEFAULT_TAG  = 8'h00;
  DEFAULT_COMP = 4'h0;
  EXT_REG_ADDR = 12'h000;
  TD = 0;
  EP = 0;
  VENDOR_ID = 16'h10ee;
  LENGTH    = 10'b00_0000_0001;

  set_malformed = 1'b0;
end
//-----------------------------------------------------------------------\\
// Pre-BAR initialization
initial begin

  BAR_INIT_MESSAGE[0] = "DISABLED";
  BAR_INIT_MESSAGE[1] = "IO MAPPED";
  BAR_INIT_MESSAGE[2] = "MEM32 MAPPED";
  BAR_INIT_MESSAGE[3] = "MEM64 MAPPED";

  OUT_OF_LO_MEM = 1'b0;
  OUT_OF_IO     = 1'b0;
  OUT_OF_HI_MEM = 1'b0;

  // Disable variables to start
  for (ii = 0; ii <= 6; ii = ii + 1) begin
    BAR_INIT_P_BAR[ii]         = 33'h00000_0000;
    BAR_INIT_P_BAR_RANGE[ii]   = 32'h0000_0000;
    BAR_INIT_P_BAR_ENABLED[ii] = 2'b00;
  end

  BAR_INIT_P_MEM64_HI_START =  32'h0000_0001;  // hi 32 bit start of 64bit memory
  BAR_INIT_P_MEM64_LO_START =  32'h0000_0000;  // low 32 bit start of 64bit memory
  BAR_INIT_P_MEM32_START    =  33'h00000_0000; // start of 32bit memory
  BAR_INIT_P_IO_START       =  33'h00000_0000; // start of 32bit io

  DEV_VEN_ID             = (EP_DEV_ID1 << 16) | (32'h10EE);
  PIO_MAX_MEMORY         = 8192; // PIO has max of 8Kbytes of memory
  PIO_MAX_NUM_BLOCK_RAMS = 4;    // PIO has four block RAMS to test
  PIO_MAX_MEMORY         = 2048; // PIO has 4 memory regions with 2 Kbytes of memory per region, ie 8 Kbytes
  PIO_MAX_NUM_BLOCK_RAMS = 4;    // PIO has four block RAMS to test

  pio_check_design = 1;  // By default check to make sure the core has been configured
                         // appropriately for the PIO design
  cpld_to          = 0;  // By default time out has not occured
  cpld_to_finish   = 1;  // By default end simulation on time out

  verbose = 0;  // turned off by default

  NUMBER_OF_IO_BARS    = 0;
  NUMBER_OF_MEM32_BARS = 0;
  NUMBER_OF_MEM64_BARS = 0;

end

//-----------------------------------------------------------------------\\
// logic to store received data

reg [15:0] rcv_data[0:16384];
reg 	     cq_wr;
reg  [3:0] count;
wire[15:0] tmp_data_0;
wire[15:0] tmp_data_1;
wire[15:0] tmp_data_2;
wire[15:0] tmp_data_0_1;
wire[15:0] tmp_data_1_1;
wire[15:0] tmp_data_2_1;
reg [15:0] cq_addr;
reg 		   tvalid_d;
wire[15:0] cq_addr_fst;
wire [7:0] xfr_len;

always @(posedge user_clk) begin
	tvalid_d <= board.RP.m_axis_cq_tvalid & board.RP.m_axis_cq_tready;
end

assign cq_addr_fst = (board.RP.m_axis_cq_tvalid & board.RP.m_axis_cq_tready & ~tvalid_d) ? board.RP.m_axis_cq_tdata[15:0] : 16'h0;
assign xfr_len = (board.RP.m_axis_cq_tvalid & board.RP.m_axis_cq_tready & ~tvalid_d) ? board.RP.m_axis_cq_tdata[71:64] : 8'h0;

always @(posedge user_clk) begin
  if(reset) begin
    cq_wr <= 0;
    count <= 0;
    cq_addr <= 0;
  end
  else if(board.RP.m_axis_cq_tvalid & board.RP.m_axis_cq_tready & (cq_wr | board.RP.m_axis_cq_tdata[75])) begin
    cq_wr <= 1'b1;
    count <= count+1;
    if(count == 0) begin
	    for (i = 8; i < 32; i= i+1) begin
	      rcv_data[cq_addr_fst + (i-8)] <=  board.RP.m_axis_cq_tdata[i*16 +: 16];
	      if(i == 31) cq_addr <= cq_addr_fst + 24;
	    //$display ("addr = %d, data 0 %h\n", (cq_addr_fst+ (i-8)), board.RP.m_axis_cq_tdata[i*16 +: 16]);
	    end
    end
    else begin
      for (i = 0; i < 32; i= i+1) begin
        rcv_data[cq_addr + i] <=  board.RP.m_axis_cq_tdata[i*16 +: 16];
        if(i == 31) cq_addr <= cq_addr + 32;
      //$display ("addr = %d, data %h\n", (cq_addr+i), board.RP.m_axis_cq_tdata[i*16 +: 16]);
      end
    end
  end
  else begin
    cq_wr <= 0;
    count <= 0;
  end
end

assign tmp_data_0 = rcv_data[2048];
assign tmp_data_1 = rcv_data[2049];
assign tmp_data_2 = rcv_data[2050];
assign tmp_data_0_1 = rcv_data[2051];
assign tmp_data_1_1 = rcv_data[2052];
assign tmp_data_2_1 = rcv_data[2053];

//--------------------------------------------------------------------------------------------------------

/************************************************************
  Logic to Compute the Parity of the CC and the RQ Channel
*************************************************************/

generate
if(AXISTEN_IF_RQ_PARITY_CHECK == 1) begin
  genvar a;
  for(a=0; a< STRB_WIDTH; a = a + 1) // Parity needs to be computed for every byte of data
  begin : parity_assign
    assign s_axis_rq_tparity[a] = !( s_axis_rq_tdata[(8*a)+ 0] ^ s_axis_rq_tdata[(8*a)+ 1]
                                   ^ s_axis_rq_tdata[(8*a)+ 2] ^ s_axis_rq_tdata[(8*a)+ 3]
                                   ^ s_axis_rq_tdata[(8*a)+ 4] ^ s_axis_rq_tdata[(8*a)+ 5]
                                   ^ s_axis_rq_tdata[(8*a)+ 6] ^ s_axis_rq_tdata[(8*a)+ 7]);
    assign s_axis_cc_tparity[a] = !( s_axis_cc_tdata[(8*a)+ 0] ^ s_axis_cc_tdata[(8*a)+ 1]
                                   ^ s_axis_cc_tdata[(8*a)+ 2] ^ s_axis_cc_tdata[(8*a)+ 3]
                                   ^ s_axis_cc_tdata[(8*a)+ 4] ^ s_axis_cc_tdata[(8*a)+ 5]
                                   ^ s_axis_cc_tdata[(8*a)+ 6] ^ s_axis_cc_tdata[(8*a)+ 7]);
  end
end
endgenerate




//////////////////////////////////////////////////////////////////////////////////////////////



task TSK_QDMA_MM_H2C_TEST;
  input [10:0] qid;
  input dsc_bypass;
  input irq_en;

  reg [11:0] q_count;
  reg [10:0] q_base;
  reg [15:0] pidx;
  localparam NUM_ITER = 12;
  integer    iter;
  logic [31:0] wr_data[8];
begin
  //$display({__FILE__, "../../binaries/polybench/trisolv_0.bin"});
	//----------------------------------------------------------------------------------------
	// QDMA AXI-MM H2C Test Starts
	//----------------------------------------------------------------------------------------
  $display("------AXI-MM H2C Tests start--------\n");

  $display(" **** read Address at BAR0  = %h\n", board.RP.tx_usrapp.BAR_INIT_P_BAR[0][31:0]);
  $display(" **** read Address at BAR1  = %h\n", board.RP.tx_usrapp.BAR_INIT_P_BAR[1][31:0]);

  // Global programming
  //
  // Assign Q 0 for AXI-MM
  axi_mm_q = qid;
  q_base   = QUEUE_PER_PF * fnc;
  q_count  = QUEUE_PER_PF;
  EP_BUS_DEV_FNS      = {EP_BUS_DEV_FNS_INIT[15:2], fnc};
  pidx = 0;

  //-------------- Load DATA in Buffer ----------------------------------------------------
  // H2C DSC start at 0x0100 (256)
  // H2C data start at 0x0300 (768)
  // Initializes descriptor and data (addresses are hard-coded)
  board.RP.tx_usrapp.TSK_INIT_QDMA_MM_DATA_H2C;

	//-------------- DMA Engine ID Read -----------------------------------------------------
  board.RP.tx_usrapp.TSK_REG_READ(xdma_bar, 16'h00);

  //-------------- Global Ring Size for Queue 0  0x204  : num of dsc 16 ------------------------
  // It initializes the ring size registers (from addr 0x204 to addr 0x240)
  // with the value 16 (0x10). Each queue can choose the ring size to read.
  for (shortint addr = 16'h204; addr <= 16'h240; addr += 4)
    board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, addr, 32'h00000010, 4'hF);



  //-------------- Ind Dire CTXT MASK 0x824  0xffffffff for all 128 bits -------------------
  // Put all bits of the context mask to 1 (it is probably to enable all data bytes or something, but I don't know)
  for (shortint addr = 16'h824; addr <= 16'h840; addr += 4)
    board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, addr, 32'hffffffff, 4'hF);

  //-------------- Clear HW CXTX for H2C for Qid -----------------------------------------
  // Writing in the CTXT CMD register issues a command for the context.
  // In this case, it clears the context for the HW H2C context.
  wr_data[0][31:18] = 'h0; // reserved
  wr_data[0][17:7]  = axi_mm_q[10:0]; // qid
  wr_data[0][6:5]   = 2'h0; // MDMA_CTXT_CMD_CLR
  wr_data[0][4:1]   = 4'h3; // MDMA_CTXT_SELC_DSC_HW_H2C
  wr_data[0][0]     = 'h0;
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h844, wr_data[0], 4'hF);

  
  
  //-------------- Global Function MAP 0x400  : Func0 22:11 Qnumber ( 16 Queue ) : 10:0 Qid_base for this Func
  // Writing in the CTXT DATA register: it is putting the context to zero, except for the first two words that
  // contain the q_base (the first queue for this physical function) and the q_count (the number of queues for
  // each PF). Don't know exactly how it works, but apparently the Function Map is used to allocate the accesses
  // to the different queues with some sort of addressing translation.
  wr_data[0]  = 32'h0 | q_base;
  wr_data[1]  = 32'h0 | q_count;
  for (iter = 2; iter < 8; iter++)
    wr_data[iter] = '0;

  iter = 0;
  for (shortint addr = 16'h804; addr <= 16'h820; addr += 4)
  begin
    TSK_REG_WRITE(xdma_bar, addr, wr_data[iter], 4'hF);
    iter ++;
  end
  //-------------- Write CXTX to Function Map -----------------------------------------
  // Writing in the CTXT CMD register issues a command for the context.
  // In this case, it writes the content of the context to the Function Map.
  wr_data[0][31:18] = 'h0; // reserved
  wr_data[0][17:7]  = 11'h0 | fnc[7:0]; // fnc
  wr_data[0][6:5]   = 2'h1; // MDMA_CTXT_CMD_WR
  wr_data[0][4:1]   = 4'hC; // QDMA_CTXT_SELC_FMAP
  wr_data[0][0]     = 'h0;
  TSK_REG_WRITE(xdma_bar, 32'h844, wr_data[0], 4'hF);



  // AXI-MM Transfer start
  $display(" *** QDMA H2C *** \n");

  // Here, it writes the H2C descriptor SW context
  //-------------- Ind Direct AXI-MM H2C CTXT DATA -------------------
  wr_dat[255:140] = 'd0;
  wr_dat[139]     = 'd0;    // int_aggr
  wr_dat[138:128] = 'd1;    // vec MSI-X Vector
  wr_dat[127:64]  =  (64'h0 | H2C_ADDR); // dsc base
  wr_dat[63]      =  1'b1;  // is_mm
  wr_dat[62]      =  1'b0;  // mrkr_dis
  wr_dat[61]      =  1'b0;  // irq_req
  wr_dat[60]      =  1'b0;  // err_wb_sent
  wr_dat[59:58]   =  2'b0;  // err
  wr_dat[57]      =  1'b0;  // irq_no_last
  wr_dat[56:54]   =  3'h0;  // port_id
  wr_dat[53]      =  irq_en;  // irq_en
  wr_dat[52]      =  1'b1;  // wbk_en
  wr_dat[51]      =  1'b0;  // mm_chn
  wr_dat[50]      =  dsc_bypass ? 1'b1 : 1'b0;  // bypass
  wr_dat[49:48]   =  2'b10; // dsc_sz, 32bytes
  wr_dat[47:44]   =  4'h1;  // rng_sz
  wr_dat[43:41]   =  3'h0;  // reserved
  wr_dat[40:37]   =  4'h0;  // fetch_max
  wr_dat[36]      =  1'b0;  // atc
  wr_dat[35]      =  1'b0;  // wbi_intvl_en
  wr_dat[34]      =  1'b1;  // wbi_chk
  wr_dat[33]      =  1'b0;  // fcrd_en
  wr_dat[32]      =  1'b1;  // qen
  wr_dat[31:25]   =  7'h0;  // reserved
  wr_dat[24:17]   =  {4'h0,pfTestIteration[3:0]}; // func_id
  wr_dat[16]      =  1'b0;  // irq_arm
  wr_dat[15:0]    =  16'b0; // pidx

  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h804, wr_dat[31 :0 ], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h808, wr_dat[63 :32], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h80C, wr_dat[95 :64], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h810, wr_dat[127:96], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h814, wr_dat[159:128], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h818, wr_dat[191:160], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h81C, wr_dat[223:192], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h820, wr_dat[255:224], 4'hF);

  //-------------- Ind Dire CTXT CMD 0x844 [17:7] Qid : 0 [17:7} : CMD MDMA_CTXT_CMD_WR=1 ---------
  // [17:7] QID   00
  // [6:5 ] MDMA_CTXT_CMD_WR=1 : 01
  // [4:1]  MDMA_CTXT_SELC_DSC_SW_H2C = 1 : 0001
  // 0      BUSY : 0
  //        00000000000_01_0001_0 : 0x22
  wr_dat = {14'h0,axi_mm_q[10:0],7'b0100010};
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h844, wr_dat[31:0], 4'hF);



  //-------------- ARM H2C transfer 0x1204 MDMA_H2C_MM0_CONTROL set to run--------
  // Writing to this register simply starts the execution of the DMA
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h1204, 32'h00000001, 4'hF);



  //-------------- Start DMA tranfer ------------------------------------------------------
  $display(" **** Start AXI-MM H2C transfer ***\n");

  for (iter=0; iter < NUM_ITER; iter=iter+1) begin
    fork
      //-------------- Writ PIDX to 1 to transfer 1 descriptor ----------------
      
      // Putting the producer index into the PIXD address. I guess it's enough to use it.
      //write address
      pidx = pidx +1;
      wr_add = QUEUE_PTR_PF_ADDR + (axi_mm_q* 16) + 4;            // Xilinx says: 32'h00006404
      $display("Address where it puts the pixd: %x\n", wr_add);   // What I see:  32'h00018014
      board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, wr_add[31:0], {irq_en, pidx[15:0]} | 32'h0, 4'hF);   // Write 1 PIDX

      //-------------- compare H2C data -------------------------------------------------------
      $display("------Compare H2C AXI-MM Data--------\n");
      board.RP.tx_usrapp.COMPARE_DATA_H2C({16'h0,board.RP.tx_usrapp.DMA_BYTE_CNT},768);    //input payload bytes
    join

    // Waits until the back status is the one it expects
    //board.RP.tx_usrapp.COMPARE_TRANS_STATUS(32'h000011E0, pidx[15:0]);

    board.RP.tx_usrapp.TSK_REG_READ(xdma_bar, 16'h1248);
  end

  $display("------AXI-MM H2C Completed--------\n");
  #1000;
end
endtask

task TSK_QDMA_MM_C2H_TEST;
  input [10:0] qid;
  input dsc_bypass;
  input irq_en;

  reg [11:0] q_count;
  reg [10:0] q_base;
  reg [15:0] pidx;
  localparam NUM_ITER = 1; // Max 8
  integer    iter;
begin

  //------------- This test performs a 32 bit write to a 32 bit Memory space and performs a read back

	//----------------------------------------------------------------------------------------
	// QDMA AXI-MM C2H Test Starts
	//----------------------------------------------------------------------------------------
  $display("------AXI-MM C2H Tests start--------\n");

  $display(" **** read Address at BAR0  = %h\n", board.RP.tx_usrapp.BAR_INIT_P_BAR[0][31:0]);
  $display(" **** read Address at BAR1  = %h\n", board.RP.tx_usrapp.BAR_INIT_P_BAR[1][31:0]);

  // Global programming
  //
  // Assign Q 0 for AXI-MM
  axi_mm_q = qid;
  q_base   = QUEUE_PER_PF * fnc;
  q_count  = QUEUE_PER_PF;
  pidx = 0;

	//-------------- DMA Engine ID Read -----------------------------------------------------
  board.RP.tx_usrapp.TSK_REG_READ(xdma_bar, 16'h00);

  // enable dsc bypass loopback
  if(dsc_bypass)
    board.RP.tx_usrapp.TSK_REG_WRITE(user_bar, 32'h90, 32'h3, 4'hF);

  // initilize all ring size to some value.
  //-------------- Global Ring Size for Queue 0  0x204  : num of dsc 16 ------------------------
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h204, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h208, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h20C, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h210, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h214, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h218, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h21C, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h220, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h224, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h228, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h22C, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h230, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h234, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h238, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h23C, 32'h00000010, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h240, 32'h00000010, 4'hF);

  //-------------- Clear HW CXTX for C2H for Qid -----------------------------------------
  wr_dat[31:18] = 'h0; // reserved
  wr_dat[17:7]  = axi_mm_q[10:0]; // qid
  wr_dat[6:5]   = 2'h0; // MDMA_CTXT_CMD_CLR
  wr_dat[4:1]   = 4'h2; // MDMA_CTXT_SELC_DSC_HW_C2H
  wr_dat[0]     = 'h0;

  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h844, wr_dat[31:0], 4'hF);

  // FMAP programing. set up 16Queues
  wr_dat[31:0]   = 32'h0 | q_base;
  wr_dat[63:32]  = 32'h0 | q_count;
  wr_dat[255:64] = 'h0;

  TSK_REG_WRITE(xdma_bar, 16'h804, wr_dat[31 :0 ], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h808, wr_dat[63 :32], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h80C, wr_dat[95 :64], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h810, wr_dat[127:96], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h814, wr_dat[159:128], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h818, wr_dat[191:160], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h81C, wr_dat[223:192], 4'hF);
  TSK_REG_WRITE(xdma_bar, 16'h820, wr_dat[255:224], 4'hF);

  wr_dat[31:18] = 'h0; // reserved
  wr_dat[17:7]  = 11'h0 | fnc[7:0]; // fnc
  wr_dat[6:5]   = 2'h1; // MDMA_CTXT_CMD_WR
  wr_dat[4:1]   = 4'hC; // QDMA_CTXT_SELC_FMAP
  wr_dat[0]     = 'h0;
  TSK_REG_WRITE(xdma_bar, 32'h844, wr_dat[31:0], 4'hF);

//for(pf_loop_index=0; pf_loop_index <= pfTestIteration; pf_loop_index = pf_loop_index + 1)
//begin
//  if(pf_loop_index == pfTestIteration) begin
//    board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h400+(pf_loop_index*4), 32'h00008000, 4'hF);
//  end else begin
//    board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h400+(pf_loop_index*4), 32'h00000000, 4'hF);
//  end
//end

  if(irq_en == 1'b1) begin
    TSK_PROGRAM_MSIX_VEC_TABLE (0);
  end

  //-------------- Ind Dire CTXT MASK 0x814  0xffffffff for all 128 bits -------------------
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h824, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h828, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h82C, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h830, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h834, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h838, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h83C, 32'hffffffff, 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h840, 32'hffffffff, 4'hF);

  //-------------- Load DATA in Buffer ----------------------------------------------------
  // C2H DSC starts at 0x0800 (2048)
  // C2H data starts at 0x0A00 (2560)
  board.RP.tx_usrapp.TSK_INIT_QDMA_MM_DATA_C2H;

  //-------------- Ind Direer AXI-MM C2H CTXT DATA -------------------
  wr_dat[255:140] = 'd0;
  wr_dat[139]     = 'd0;    // int_aggr
  wr_dat[138:128] = 'd2;    // vec MSI-X Vector
  wr_dat[127:64]  =  (64'h0 | C2H_ADDR); // dsc base
  wr_dat[63]      =  1'b1;  // is_mm
  wr_dat[62]      =  1'b0;  // mrkr_dis
  wr_dat[61]      =  1'b0;  // irq_req
  wr_dat[60]      =  1'b0;  // err_wb_sent
  wr_dat[59:58]   =  2'b0;  // err
  wr_dat[57]      =  1'b0;  // irq_no_last
  wr_dat[56:54]   =  3'h0;  // port_id
  wr_dat[53]      =  irq_en;  // irq_en
  wr_dat[52]      =  1'b1;  // wbk_en
  wr_dat[51]      =  1'b0;  // mm_chn
  wr_dat[50]      =  dsc_bypass ? 1'b1 : 1'b0;  // bypass
  wr_dat[49:48]   =  2'b10; // dsc_sz, 32bytes
  wr_dat[47:44]   =  4'h1;  // rng_sz
  wr_dat[43:40]   =  4'h0;  // reserved
  wr_dat[39:37]   =  3'h0;  // fetch_max
  wr_dat[36]      =  1'b0;  // atc
  wr_dat[35]      =  1'b0;  // wbi_intvl_en
  wr_dat[34]      =  1'b1;  // wbi_chk
  wr_dat[33]      =  1'b0;  // fcrd_en
  wr_dat[32]      =  1'b1;  // qen
  wr_dat[31:25]   =  7'h0;  // reserved
  wr_dat[24:17]   =  {4'h0,pfTestIteration[3:0]}; // func_id
  wr_dat[16]      =  1'b0;  // irq_arm
  wr_dat[15:0]    =  16'b0; // pidx

  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h804, wr_dat[31 :0] , 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h808, wr_dat[63 :32], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h80C, wr_dat[95 :64], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h810, wr_dat[127:96], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h814, wr_dat[159:128], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h818, wr_dat[191:160], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h81C, wr_dat[223:192], 4'hF);
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h820, wr_dat[255:224], 4'hF);

  //-------------- Ind Dire CTXT CMD 0x844 [17:7] Qid : 1 [17:7] : CMD MDMA_CTXT_CMD_WR=1 ---------
  // [17:7] QID   00
  // [6:5 ] MDMA_CTXT_CMD_WR=1 : 01
  // [4:1]  MDMA_CTXT_SELC_DSC_SW_C2H = 0 : 0000
  // 0      BUSY : 0
  //        00000000000_01_0000_0 : 0010_0000 : 0x20
  wr_dat = {14'h0,axi_mm_q[10:0],7'b0100000};
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h844, wr_dat[31:0], 4'hF);

  //-------------- ARM C2H transfer 0x1004 MDMA_C2H_MM0_CONTROL set to run--------
  board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, 16'h1004, 32'h00000001, 4'hF);

  //-------------- Start DMA tranfer ------------------------------------------------------
  $display(" **** Start DMA C2H transfer ***\n");

  for (iter=0; iter < NUM_ITER; iter=iter+1) begin
    fork
      //-------------- Write PIDX to 1 to transfer 1 descriptor in C2H ----------------
      pidx = pidx + 1;
      wr_add = QUEUE_PTR_PF_ADDR + (axi_mm_q* 16) + 8;  // 32'h00006408
      board.RP.tx_usrapp.TSK_REG_WRITE(xdma_bar, wr_add[31:0], {irq_en, pidx[15:0]} | 32'h0, 4'hF); // Write 1 PIDX

      //compare C2H data
      $display("------Compare C2H AXI-MM Data--------\n");
      // for coparision H2C data is stored in 768
      board.RP.tx_usrapp.COMPARE_DATA_C2H({16'h0,board.RP.tx_usrapp.DMA_BYTE_CNT},768);
    join
      //board.RP.tx_usrapp.COMPARE_TRANS_STATUS(32'h000021E0, pidx[15:0]);
      board.RP.tx_usrapp.TSK_REG_READ(xdma_bar, 16'h1048);
      $display ("**** C2H Decsriptor Count = %h\n", P_READ_DATA);
    end
    $display("------AXI-MM C2H Completed--------\n");
  end
endtask


/************************************************************
Task : TSK_TX_TYPE0_CONFIGURATION_READ
Inputs : Tag, PCI/PCI-Express Reg Address, First BypeEn
Outputs : Transaction Tx Interface Signaling
Description : Generates a Type 0 Configuration Read TLP
*************************************************************/
task TSK_TX_TYPE0_CONFIGURATION_READ;
  input [7:0]  tag_;         // Tag
  input [11:0] reg_addr_;    // Register Number
  input [3:0]  first_dw_be_; // First DW Byte Enable
begin
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish;
  end
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //--------- CFG TYPE-0 Read Transaction :                     -----------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b1;
  s_axis_rq_tlast  <= #(Tcq) 1'b1;
  s_axis_rq_tkeep  <= #(Tcq) 8'h0F; // 2DW Descriptor
  s_axis_rq_tuser_wo_parity<= #(Tcq) {
      //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
      64'b0,       // Parity Bit slot - 64bit
      6'b101010,   // Seq Number - 6bit
      6'b101010,   // Seq Number - 6bit
      16'h0000,    // TPH Steering Tag - 16 bit
      2'b00,       // TPH indirect Tag Enable - 2bit
      4'b0000,     // TPH Type - 4 bit
      2'b00,       // TPH Present - 2 bit
      1'b0,        // Discontinue
      4'b0000,     // is_eop1_ptr
      4'b0000,     // is_eop0_ptr
      2'b01,       // is_eop[1:0]
      2'b10,       // is_sop1_ptr[1:0]
      2'b00,       // is_sop0_ptr[1:0]
      2'b01,       // is_sop[1:0]
      2'b00,2'b00, // Byte Lane number in case of Address Aligned mode - 4 bit
      4'b0000,4'b0000, // Last BE of the Write Data -  8 bit
      4'b0000,first_dw_be_ // First BE of the Write Data - 8 bit
    };

  s_axis_rq_tdata <= #(Tcq) {256'b0,128'b0, // 4DW unused             //256
      1'b0,     // Force ECRC             //128
      3'b000,   // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      3'b000,   // Traffic Class
      1'b1,     // RID Enable to use the Client supplied Bus/Device/Func No
      EP_BUS_DEV_FNS,  // Completer ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      RP_BUS_DEV_FNS,  // Requester ID  //96
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      4'b1000,         // Req Type for TYPE0 CFG READ Req
      11'b00000000001, // DWORD Count
      32'b0,           // Address *unused*       // 64
      16'b0,           // Address *unused*       // 32
      4'b0,            // Address *unused*
      reg_addr_[11:2], // Extended + Base Register Number
      2'b00};          // AT -> 00 : Untranslated Address

  pcie_tlp_data <= #(Tcq) {
      3'b000,   // Fmt for Type 0 Configuration Read Req
      5'b00100, // Type for Type 0 Configuration Read Req
      1'b0,     // *reserved*
      3'b000,   // Traffic Class
      1'b0,     // *reserved*
      1'b0,     // Attributes {ID Based Ordering}
      1'b0,     // *reserved*
      1'b0,     // TLP Processing Hints
      1'b0,     // TLP Digest Present
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      2'b00,    // Attributes {Relaxed Ordering, No Snoop}
      2'b00,    // Address Translation
      10'b0000000001,  // DWORD Count            //32
      RP_BUS_DEV_FNS,  // Requester ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      4'b0000,         // Last DW Byte Enable
      first_dw_be_,    // First DW Byte Enable   //64
      EP_BUS_DEV_FNS,  // Completer ID
      4'b0000,         // *reserved*
      reg_addr_[11:2], // Extended + Base Register Number
      2'b00,    // *reserved* //96
      32'b0 ,   // *unused*   //128
      128'b0    // *unused*   //256
    };

  pcie_tlp_rem  <= #(Tcq)  3'b101;
  set_malformed <= #(Tcq)  1'b0;
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid  <= #(Tcq) 1'b0;
  s_axis_rq_tlast   <= #(Tcq) 1'b0;
  s_axis_rq_tkeep   <= #(Tcq) 8'h00;
  s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
  s_axis_rq_tdata   <= #(Tcq) 512'b0;
  pcie_tlp_rem      <= #(Tcq) 3'b000;
end
endtask // TSK_TX_TYPE0_CONFIGURATION_READ

/************************************************************
Task : TSK_TX_TYPE0_CONFIGURATION_WRITE
Inputs : Tag, PCI/PCI-Express Reg Address, First BypeEn
Outputs : Transaction Tx Interface Signaling
Description : Generates a Type 0 Configuration Write TLP
*************************************************************/

task TSK_TX_TYPE0_CONFIGURATION_WRITE;
  input  [7:0] tag_; // Tag
  input [11:0] reg_addr_; // Register Number
  input [31:0] reg_data_; // Data
  input  [3:0] first_dw_be_; // First DW Byte Enable
begin
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //--------- TYPE-0 CFG Write Transaction :                     -----------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b1;
  s_axis_rq_tlast  <= #(Tcq) (AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") ?  1'b0 : 1'b1;
  s_axis_rq_tkeep  <= #(Tcq) (AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") ?  8'hFF : 8'h1F;       // 2DW Descriptor
  s_axis_rq_tuser_wo_parity<= #(Tcq) {
      //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
      64'b0,       // Parity Bit slot - 64bit
      6'b101010,   // Seq Number - 6bit
      6'b101010,   // Seq Number - 6bit
      16'h0000,    // TPH Steering Tag - 16 bit
      2'b00,       // TPH indirect Tag Enable - 2bit
      4'b0000,     // TPH Type - 4 bit
      2'b00,       // TPH Present - 2 bit
      1'b0,        // Discontinue
      4'b0000,     // is_eop1_ptr
      4'b0000,     // is_eop0_ptr
      2'b01,       // is_eop[1:0]
      2'b10,       // is_sop1_ptr[1:0]
      2'b00,       // is_sop0_ptr[1:0]
      2'b01,       // is_sop[1:0]
      2'b00,2'b00, // Byte Lane number in case of Address Aligned mode - 4 bit
      4'b0000,4'b0000, // Last BE of the Write Data -  8 bit
      4'b0000,first_dw_be_ // First BE of the Write Data - 8 bit
    };

    s_axis_rq_tdata <= #(Tcq) {256'b0,96'b0,           // 3 DW unused            //256
      ((AXISTEN_IF_RQ_ALIGNMENT_MODE=="FALSE")? {reg_data_[31:24], reg_data_[23:16], reg_data_[15:8], reg_data_[7:0]} : 32'h0), // Data
      1'b0,            // Force ECRC             //128
      3'b000,          // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      3'b000,          // Traffic Class
      1'b1,            // RID Enable to use the Client supplied Bus/Device/Func No
      EP_BUS_DEV_FNS,  // Completer ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      RP_BUS_DEV_FNS,  // Requester ID           //96
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      4'b1010,         // Req Type for TYPE0 CFG Write Req
      11'b00000000001, // DWORD Count
      32'b0,           // Address *unused*       //64
      16'b0,           // Address *unused*       //32
      4'b0,            // Address *unused*
      reg_addr_[11:2], // Extended + Base Register Number
      2'b00};          // AT -> 00 : Untranslated Address

    //-----------------------------------------------------------------------\\
    pcie_tlp_data <= #(Tcq) {
        3'b010,   // Fmt for Type 0 Configuration Write Req
        5'b00100, // Type for Type 0 Configuration Write Req
        1'b0,     // *reserved*
        3'b000,   // Traffic Class
        1'b0,     // *reserved*
        1'b0,     // Attributes {ID Based Ordering}
        1'b0,     // *reserved*
        1'b0,     // TLP Processing Hints
        1'b0,     // TLP Digest Present
        (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
        2'b00,    // Attributes {Relaxed Ordering, No Snoop}
        2'b00,    // Address Translation
        10'b0000000001,   // DWORD Count           //32
        RP_BUS_DEV_FNS,   // Requester ID
        (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
        4'b0000,          // Last DW Byte Enable
        first_dw_be_,     // First DW Byte Enable  //64
        EP_BUS_DEV_FNS,   // Completer ID
        4'b0000,          // *reserved*
        reg_addr_[11:2],  // Extended + Base Register Number
        2'b00,            // *reserved*            //96
        reg_data_[7:0],   // Data
        reg_data_[15:8],  // Data
        reg_data_[23:16], // Data
        reg_data_[31:24], // Data //128
        128'b0      // *unused*  //256
      };

  pcie_tlp_rem             <= #(Tcq)  3'b100;
  set_malformed            <= #(Tcq)  1'b0;

  TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  if(AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") begin
     s_axis_rq_tvalid <= #(Tcq) 1'b1;
     s_axis_rq_tlast  <= #(Tcq) 1'b1;
     s_axis_rq_tkeep  <= #(Tcq) 8'h01;             // 2DW Descriptor
     s_axis_rq_tdata  <= #(Tcq) {256'b0,128'b0,
        32'b0, // *unused* //128
        32'b0, // *unused* //96
        32'b0, // *unused* //64
        reg_data_[31:24], //32
        reg_data_[23:16],
        reg_data_[15:8],
        reg_data_[7:0]
      };

    // Just call TSK_TX_SYNCHRONIZE to wait for tready but don't log anything, because
    // the pcie_tlp_data has complete in the previous clock cycle
    TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  end
    //-----------------------------------------------------------------------\\
    s_axis_rq_tvalid <= #(Tcq) 1'b0;
    s_axis_rq_tlast  <= #(Tcq) 1'b0;
    s_axis_rq_tkeep  <= #(Tcq) 8'h00;
    s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
    s_axis_rq_tdata  <= #(Tcq) 512'b0;
    //-----------------------------------------------------------------------\\
    pcie_tlp_rem <= #(Tcq) 3'b0;
    //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_TYPE0_CONFIGURATION_WRITE

/************************************************************
Task : TSK_TX_MEMORY_READ_32
Inputs : Tag, Length, Address, Last Byte En, First Byte En
Outputs : Transaction Tx Interface Signaling
Description : Generates a Memory Read 32 TLP
*************************************************************/

task TSK_TX_MEMORY_READ_32;
  input [7:0]  tag_;  // Tag
  input [2:0]  tc_;   // Traffic Class
  input [10:0] len_;  // Length (in DW)
  input [31:0] addr_; // Address
  input [3:0]  last_dw_be_; // Last DW Byte Enable
  input [3:0]  first_dw_be_; // First DW Byte Enable
begin
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  $display("[%t] : Mem32 Read Req @address 0x%0x", $realtime,addr_);
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b1;
  s_axis_rq_tlast  <= #(Tcq) 1'b1;
  s_axis_rq_tkeep  <= #(Tcq) 8'h0F;             // 2DW Descriptor for Memory Transactions alone
  s_axis_rq_tuser_wo_parity<= #(Tcq) {
      //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
      64'b0,     // Parity Bit slot - 64bit
      6'b101010, // Seq Number - 6bit
      6'b101010, // Seq Number - 6bit
      16'h0000,  // TPH Steering Tag - 16 bit
      2'b00,     // TPH indirect Tag Enable - 2bit
      4'b0000,   // TPH Type - 4 bit
      2'b00,     // TPH Present - 2 bit
      1'b0,      // Discontinue
      4'b0000,   // is_eop1_ptr
      4'b0000,   // is_eop0_ptr
      2'b01,     // is_eop[1:0]
      2'b10,     // is_sop1_ptr[1:0]
      2'b00,     // is_sop0_ptr[1:0]
      2'b01,     // is_sop[1:0]
      2'b00,2'b00, // Byte Lane number in case of Address Aligned mode - 4 bit
      4'b0000,last_dw_be_, // Last BE of the Write Data -  8 bit
      4'b0000,first_dw_be_ // First BE of the Write Data - 8 bit
    };

  s_axis_rq_tdata <= #(Tcq) {256'b0,128'b0,           // 4 DW unused                                    //256
      1'b0,   // Force ECRC                                     //128
      3'b000, // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      tc_,    // Traffic Class
      1'b1,   // RID Enable to use the Client supplied Bus/Device/Func No
      EP_BUS_DEV_FNS, // Completer ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      RP_BUS_DEV_FNS,   // Requester ID -- Used only when RID enable = 1  //96
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      4'b0000,     // Req Type for MRd Req
      len_ ,       // DWORD Count
      32'b0,       // 32-bit Addressing. So, bits[63:32] = 0 //64
      addr_[31:2], // Memory read address 32-bits //32
      2'b00};      // AT -> 00 : Untranslated Address

  //-----------------------------------------------------------------------\\
  pcie_tlp_data <= #(Tcq) {
      3'b000,   // Fmt for 32-bit MRd Req
      5'b00000, // Type for 32-bit Mrd Req
      1'b0,     // *reserved*
      tc_,      // 3-bit Traffic Class
      1'b0,     // *reserved*
      1'b0,     // Attributes {ID Based Ordering}
      1'b0,     // *reserved*
      1'b0,     // TLP Processing Hints
      1'b0,     // TLP Digest Present
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      2'b00,    // Attributes {Relaxed Ordering, No Snoop}
      2'b00,    // Address Translation
      len_[9:0],// DWORD Count              //32
      RP_BUS_DEV_FNS,   // Requester ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      last_dw_be_,  // Last DW Byte Enable
      first_dw_be_, // First DW Byte Enable //64
      addr_[31:2],  // Address
      2'b00,    // *reserved* //96
      32'b0,    // *unused*   //128
      128'b0    // *unused*   //256
    };

  pcie_tlp_rem <= #(Tcq)  3'b100;
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b0;
  s_axis_rq_tlast  <= #(Tcq) 1'b0;
  s_axis_rq_tkeep  <= #(Tcq) 8'h00;
  s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
  s_axis_rq_tdata  <= #(Tcq) 512'b0;
  //-----------------------------------------------------------------------\\
  pcie_tlp_rem <= #(Tcq) 3'b0;
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_MEMORY_READ_32

/************************************************************
Task : TSK_TX_MEMORY_READ_64
Inputs : Tag, Length, Address, Last Byte En, First Byte En
Outputs : Transaction Tx Interface Signaling
Description : Generates a Memory Read 64 TLP
*************************************************************/

task TSK_TX_MEMORY_READ_64;
  input [7:0]  tag_;  // Tag
  input [2:0]  tc_;   // Traffic Class
  input [10:0] len_;  // Length (in DW)
  input [63:0] addr_; // Address
  input [3:0]  last_dw_be_;  // Last DW Byte Enable
  input [3:0]  first_dw_be_; // First DW Byte Enable
begin
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  $display("[%t] : Mem64 Read Req @address %x", $realtime,addr_[31:0]);
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b1;
  s_axis_rq_tlast  <= #(Tcq) 1'b1;
  s_axis_rq_tkeep  <= #(Tcq) 8'h0F; // 2DW Descriptor for Memory Transactions alone
  s_axis_rq_tuser_wo_parity<= #(Tcq) {
      //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
      64'b0,     // Parity Bit slot - 64bit
      6'b101010, // Seq Number - 6bit
      6'b101010, // Seq Number - 6bit
      16'h0000,  // TPH Steering Tag - 16 bit
      2'b00,     // TPH indirect Tag Enable - 2bit
      4'b0000,   // TPH Type - 4 bit
      2'b00,     // TPH Present - 2 bit
      1'b0,      // Discontinue
      4'b0000,   // is_eop1_ptr
      4'b0000,   // is_eop0_ptr
      2'b01,     //is_eop[1:0]
      2'b10,     //is_sop1_ptr[1:0]
      2'b00,     //is_sop0_ptr[1:0]
      2'b01,     //is_sop[1:0]
      2'b00,2'b00, // Byte Lane number in case of Address Aligned mode - 4 bit
      4'b0000,last_dw_be_, // Last BE of the Write Data -  8 bit
      4'b0000,first_dw_be_ // First BE of the Write Data - 8 bit
    };

  s_axis_rq_tdata <= #(Tcq) {256'b0,128'b0, // 4 DW unused //256
    1'b0,   // Force ECRC  //128
    3'b000, // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
    tc_,    // Traffic Class
    1'b1,   // RID Enable to use the Client supplied Bus/Device/Func No
    EP_BUS_DEV_FNS,   // Completer ID
    (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
    RP_BUS_DEV_FNS,   // Requester ID -- Used only when RID enable = 1  //96
    (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
    4'b0000,     // Req Type for MRd Req
    len_ ,       // DWORD Count
    addr_[63:2], // Memory read address 64-bits //64
    2'b00};      // AT -> 00 : Untranslated Address

  //-----------------------------------------------------------------------\\
  pcie_tlp_data <= #(Tcq) {
      3'b001,   // Fmt for 64-bit MRd Req
      5'b00000, // Type for 64-bit Mrd Req
      1'b0,     // *reserved*
      tc_,      // 3-bit Traffic Class
      1'b0,     // *reserved*
      1'b0,     // Attributes {ID Based Ordering}
      1'b0,     // *reserved*
      1'b0,     // TLP Processing Hints
      1'b0,     // TLP Digest Present
      (set_malformed ? 1'b1 : 1'b0), // Poisoned Req
      2'b00,    // Attributes {Relaxed Ordering, No Snoop}
      2'b00,    // Address Translation
      len_[9:0],// DWORD Count                //32
      RP_BUS_DEV_FNS,   // Requester ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      last_dw_be_,  // Last DW Byte Enable
      first_dw_be_, // First DW Byte Enable   //64
      addr_[63:2],  // Address
      2'b00,   // *reserved*  //128
      128'b0   // *unused*    //256
    };

  pcie_tlp_rem <= #(Tcq)  3'b100;
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b0;
  s_axis_rq_tlast  <= #(Tcq) 1'b0;
  s_axis_rq_tkeep  <= #(Tcq) 8'h00;
  s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
  s_axis_rq_tdata  <= #(Tcq) 512'b0;
  //-----------------------------------------------------------------------\\
  pcie_tlp_rem <= #(Tcq) 3'b0;
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_MEMORY_READ_64

/************************************************************
Task : TSK_TX_MEMORY_WRITE_32
Inputs : Tag, Length, Address, Last Byte En, First Byte En
Outputs : Transaction Tx Interface Signaling
Description : Generates a Memory Write 32 TLP
*************************************************************/

task TSK_TX_MEMORY_WRITE_32;
  input  [7:0]    tag_;         // Tag
  input  [2:0]    tc_;          // Traffic Class
  input  [10:0]   len_;         // Length (in DW)
  input  [31:0]   addr_;        // Address
  input  [3:0]    last_dw_be_;  // Last DW Byte Enable
  input  [3:0]    first_dw_be_; // First DW Byte Enable
  input           ep_;          // Poisoned Data: Payload is invalid if set
  reg    [10:0]   _len;         // Length Info on pcie_tlp_data -- Used to count how many times to loop
  reg    [10:0]   len_i;        // Length Info on s_axis_rq_tdata -- Used to count how many times to loop
  reg    [2:0]    aa_dw;        // Adjusted DW Count for Address Aligned Mode
  reg    [255:0]  aa_data;      // Adjusted Data for Address Aligned Mode
  reg    [31:0]  data_axis_i;   // Data Info for s_axis_rq_tdata changed from 128 bit to 32 bit
  reg    [511:0] subs_dw;       // adjusted for subsequent DW when len >12
  reg    [159:0]  data_pcie_i;  // Data Info for pcie_tlp_data
  reg    [383:0] data_axis_first_beat;
  integer         _j;           // Byte Index
  integer         start_addr;   // Start Location for Payload DW0
begin
  //-----------------------------------------------------------------------\\
  if(AXISTEN_IF_RQ_ALIGNMENT_MODE=="TRUE")begin
    start_addr  = 0;
    aa_dw       = addr_[4:2];
  end else begin
    start_addr  = 48;
    aa_dw       = 3'b000;
  end

  len_i = len_ + aa_dw;
  _len  = len_;
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  $display("[%t] : Mem32 Write Req @address 0x%0x with data 0x%0x", $realtime,addr_,{DATA_STORE[3], DATA_STORE[2], DATA_STORE[1], DATA_STORE[0]});
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  // Start of First Data Beat
  data_axis_i = {
    /*DATA_STORE[15],
      DATA_STORE[14],
      DATA_STORE[13],
      DATA_STORE[12],
      DATA_STORE[11],
      DATA_STORE[10],
      DATA_STORE[9],
      DATA_STORE[8],
      DATA_STORE[7],
      DATA_STORE[6],
      DATA_STORE[5],
      DATA_STORE[4],*/
      DATA_STORE[3],
      DATA_STORE[2],
      DATA_STORE[1],
      DATA_STORE[0]
    };

  if(len_i > 12 ) begin
    data_axis_first_beat = {12{data_axis_i}};
  end else begin
    case(len_i)
      0 :  data_axis_first_beat =   384'h0;
      1 :  data_axis_first_beat =  {352'h0,data_axis_i};
      2 :  data_axis_first_beat =  {320'h0,{2{data_axis_i}}};
      3 :  data_axis_first_beat =  {288'h0,{3{data_axis_i}}};
      4 :  data_axis_first_beat =  {256'h0,{4{data_axis_i}}};
      5 :  data_axis_first_beat =  {224'h0, {5{data_axis_i}}};
      6 :  data_axis_first_beat =  {192'h0, {6{data_axis_i}}};
      7 :  data_axis_first_beat =  {160'h0, {7{data_axis_i}}};
      8 :  data_axis_first_beat =  {128'h0, {8{data_axis_i}}};
      9 :  data_axis_first_beat =  {96'h0, {9{data_axis_i}}};
      10 :  data_axis_first_beat = {64'h0, {10{data_axis_i}}};
      11 :  data_axis_first_beat = {32'h0, {11{data_axis_i}}};
      12 :  data_axis_first_beat = {12{data_axis_i}};
    endcase
  end

  s_axis_rq_tuser_wo_parity <= #(Tcq) {
      //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
      64'b0,     // Parity Bit slot - 64bit
      6'b101010, // Seq Number - 6bit
      6'b101010, // Seq Number - 6bit
      16'h0000,  // TPH Steering Tag - 16 bit
      2'b00,     // TPH indirect Tag Enable - 2bit
      4'b0000,   // TPH Type - 4 bit
      2'b00,     // TPH Present - 2 bit
      1'b0,      // Discontinue
      4'b0000,   // is_eop1_ptr
      4'b1111,   // is_eop0_ptr
      2'b01,     // is_eop[1:0]
      2'b00,     // is_sop1_ptr[1:0]
      2'b00,     // is_sop0_ptr[1:0]
      2'b01,     // is_sop[1:0]
      2'b0,aa_dw[1:0],     // Byte Lane number in case of Address Aligned mode - 4 bit
      4'b0000,last_dw_be_, // Last BE of the Write Data 8 bit
      4'b0000,first_dw_be_ // First BE of the Write Data 8 bit
    };

  s_axis_rq_tdata <= #(Tcq) { ((AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE" ) ? data_axis_first_beat : 384'h0), // 12 DW write data
     //128
      1'b0,   // Force ECRC
      3'b000, // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      tc_,    // Traffic Class
      1'b1,   // RID Enable to use the Client supplied Bus/Device/Func No
      EP_BUS_DEV_FNS, // Completer ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      //96
      RP_BUS_DEV_FNS, // Requester ID -- Used only when RID enable = 1
      ep_,     // Poisoned Req
      4'b0001, // Req Type for MWr Req
      (set_malformed ? (len_ + 11'h4) : len_), // DWORD Count - length does not include padded zeros
      //64
      32'b0,       // High Address *unused*
      addr_[31:2], // Memory Write address 32-bits
      2'b00        // AT -> 00 : Untranslated Address
    };
  //-----------------------------------------------------------------------\\
  data_pcie_i = {
      DATA_STORE[0],
      DATA_STORE[1],
      DATA_STORE[2],
      DATA_STORE[3],
      DATA_STORE[4],
      DATA_STORE[5],
      DATA_STORE[6],
      DATA_STORE[7],
      DATA_STORE[8],
      DATA_STORE[9],
      DATA_STORE[10],
      DATA_STORE[11],
      DATA_STORE[12],
      DATA_STORE[13],
      DATA_STORE[14],
      DATA_STORE[15],
      DATA_STORE[16],
      DATA_STORE[17],
      DATA_STORE[18],
      DATA_STORE[19]
    };

  pcie_tlp_data <= #(Tcq) {
      3'b010,   // Fmt for 32-bit MWr Req
      5'b00000, // Type for 32-bit MWr Req
      1'b0,     // *reserved*
      tc_,      // 3-bit Traffic Class
      1'b0,     // *reserved*
      1'b0,     // Attributes {ID Based Ordering}
      1'b0,     // *reserved*
      1'b0,     // TLP Processing Hints
      1'b0,     // TLP Digest Present
      ep_,      // Poisoned Req
      2'b00,    // Attributes {Relaxed Ordering, No Snoop}
      2'b00,    // Address Translation
      (set_malformed ? (len_[9:0] + 10'h4) : len_[9:0]),  // DWORD Count
      //32
      RP_BUS_DEV_FNS, // Requester ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      last_dw_be_,   // Last DW Byte Enable
      first_dw_be_,  // First DW Byte Enable
      //64
      addr_[31:2],   // Memory Write address 32-bits
      2'b00,         // *reserved* or Processing Hint
      //96
      data_pcie_i    // Payload Data
      //256
    };

  pcie_tlp_rem  <= #(Tcq) (_len > 12) ? 3'b000 : (_len - 12);
  set_malformed <= #(Tcq) 1'b0;
  _len = (_len > 12) ? (_len - 11'hC) : 11'b0;
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid  <= #(Tcq) 1'b1;

  if(len_i > 12 || AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") begin  //changed from 4 to 12
    s_axis_rq_tlast <= #(Tcq) 1'b0;
    s_axis_rq_tkeep <= #(Tcq) 16'hFFFF;

    len_i = (AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE") ? (len_i - 12) : len_i; // Don't subtract 12 in Address Aligned because
                                                                              // it's always padded with zeros on first beat

      // pcie_tlp_data doesn't append zero even in Address Aligned mode, so it should mark this cycle as the last beat if it has no more payload to log.
      // The AXIS RQ interface will need to execute the next cycle, but we're just not going to log that data beat in pcie_tlp_data
    if(_len == 0)
      TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
    else
      TSK_TX_SYNCHRONIZE(1, 1, 0, `SYNC_RQ_RDY);

  end else begin
    if(len_i == 1)       s_axis_rq_tkeep <= #(Tcq) 16'h001F;
    else if(len_i == 2)  s_axis_rq_tkeep <= #(Tcq) 16'h003F;
    else if(len_i == 3)  s_axis_rq_tkeep <= #(Tcq) 16'h007F;
    else if(len_i == 4)  s_axis_rq_tkeep <= #(Tcq) 16'h00FF;
    else if(len_i == 5)  s_axis_rq_tkeep <= #(Tcq) 16'h01FF;
    else if(len_i == 6)  s_axis_rq_tkeep <= #(Tcq) 16'h03FF;
    else if(len_i == 7)  s_axis_rq_tkeep <= #(Tcq) 16'h07FF;
    else if(len_i == 9)  s_axis_rq_tkeep <= #(Tcq) 16'h1FFF;
    else if(len_i == 10) s_axis_rq_tkeep <= #(Tcq) 16'h3FFF;
    else if(len_i == 11) s_axis_rq_tkeep <= #(Tcq) 16'h7FFF;
    else                 s_axis_rq_tkeep <= #(Tcq) 16'hFFFF;

    s_axis_rq_tlast <= #(Tcq) 1'b1;

    len_i                     = 0;
    TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  end
  // End of First Data Beat
  //-----------------------------------------------------------------------\\
  // Start of Second and Subsequent Data Beat
  if(len_i != 0 || AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") begin
    fork
    begin // Sequential group 1 - AXIS RQ
      for(_j = start_addr; len_i != 0; _j = _j + 32) begin
      /*if(_j==start_addr) begin
          aa_data = {
              DATA_STORE[_j + 31],
              DATA_STORE[_j + 30],
              DATA_STORE[_j + 29],
              DATA_STORE[_j + 28],
              DATA_STORE[_j + 27],
              DATA_STORE[_j + 26],
              DATA_STORE[_j + 25],
              DATA_STORE[_j + 24],
              DATA_STORE[_j + 23],
              DATA_STORE[_j + 22],
              DATA_STORE[_j + 21],
              DATA_STORE[_j + 20],
              DATA_STORE[_j + 19],
              DATA_STORE[_j + 18],
              DATA_STORE[_j + 17],
              DATA_STORE[_j + 16],
              DATA_STORE[_j + 15],
              DATA_STORE[_j + 14],
              DATA_STORE[_j + 13],
              DATA_STORE[_j + 12],
              DATA_STORE[_j + 11],
              DATA_STORE[_j + 10],
              DATA_STORE[_j +  9],
              DATA_STORE[_j +  8],
              DATA_STORE[_j +  7],
              DATA_STORE[_j +  6],
              DATA_STORE[_j +  5],
              DATA_STORE[_j +  4],
              DATA_STORE[_j +  3],
              DATA_STORE[_j +  2],
              DATA_STORE[_j +  1],
              DATA_STORE[_j +  0]
            } << (aa_dw*4*8);
        end else begin
          aa_data = {
              DATA_STORE[_j + 31 - (aa_dw*4)],
              DATA_STORE[_j + 30 - (aa_dw*4)],
              DATA_STORE[_j + 29 - (aa_dw*4)],
              DATA_STORE[_j + 28 - (aa_dw*4)],
              DATA_STORE[_j + 27 - (aa_dw*4)],
              DATA_STORE[_j + 26 - (aa_dw*4)],
              DATA_STORE[_j + 25 - (aa_dw*4)],
              DATA_STORE[_j + 24 - (aa_dw*4)],
              DATA_STORE[_j + 23 - (aa_dw*4)],
              DATA_STORE[_j + 22 - (aa_dw*4)],
              DATA_STORE[_j + 21 - (aa_dw*4)],
              DATA_STORE[_j + 20 - (aa_dw*4)],
              DATA_STORE[_j + 19 - (aa_dw*4)],
              DATA_STORE[_j + 18 - (aa_dw*4)],
              DATA_STORE[_j + 17 - (aa_dw*4)],
              DATA_STORE[_j + 16 - (aa_dw*4)],
              DATA_STORE[_j + 15 - (aa_dw*4)],
              DATA_STORE[_j + 14 - (aa_dw*4)],
              DATA_STORE[_j + 13 - (aa_dw*4)],
              DATA_STORE[_j + 12 - (aa_dw*4)],
              DATA_STORE[_j + 11 - (aa_dw*4)],
              DATA_STORE[_j + 10 - (aa_dw*4)],
              DATA_STORE[_j +  9 - (aa_dw*4)],
              DATA_STORE[_j +  8 - (aa_dw*4)],
              DATA_STORE[_j +  7 - (aa_dw*4)],
              DATA_STORE[_j +  6 - (aa_dw*4)],
              DATA_STORE[_j +  5 - (aa_dw*4)],
              DATA_STORE[_j +  4 - (aa_dw*4)],
              DATA_STORE[_j +  3 - (aa_dw*4)],
              DATA_STORE[_j +  2 - (aa_dw*4)],
              DATA_STORE[_j +  1 - (aa_dw*4)],
              DATA_STORE[_j +  0 - (aa_dw*4)]
            };
        end
      */
      if(((len_i-1)/16) == 0) begin
        case (len_i)
          1 :  subs_dw = {480'h0, data_axis_i};
          2 :  subs_dw = {448'h0, {2{data_axis_i}}};
          3 :  subs_dw = {416'h0, {3{data_axis_i}}};
          4 :  subs_dw = {384'h0, {4{data_axis_i}}};
          5 :  subs_dw = {352'h0, {5{data_axis_i}}};
          6 :  subs_dw = {320'h0, {6{data_axis_i}}};
          7 :  subs_dw = {288'h0, {7{data_axis_i}}};
          8 :  subs_dw = {256'h0, {8{data_axis_i}}};
          9 :  subs_dw = {224'h0, {9{data_axis_i}}};
          10 : subs_dw = {192'h0, {10{data_axis_i}}};
          11 : subs_dw = {160'h0, {11{data_axis_i}}};
          12 : subs_dw = {120'h0, {12{data_axis_i}}};
          13:  subs_dw = {96'h0,  {13{data_axis_i}}};
          14 : subs_dw = {64'h0,  {14{data_axis_i}}};
          15 : subs_dw = {32'h0,  {15{data_axis_i}}};
          16 : subs_dw = {16{data_axis_i}};
        endcase
      end else begin
        subs_dw = {16{data_axis_i}};
      end
			s_axis_rq_tdata <= #(Tcq) subs_dw ;

      if((len_i/16) == 0) begin
        case (len_i % 16)
           1 : begin len_i = len_i - 1;  s_axis_rq_tkeep <= #(Tcq) 16'h0001; end  // D0----------------------------------------------------
           2 : begin len_i = len_i - 2;  s_axis_rq_tkeep <= #(Tcq) 16'h0003; end  // D0-D1-------------------------------------------------
           3 : begin len_i = len_i - 3;  s_axis_rq_tkeep <= #(Tcq) 16'h0007; end  // D0-D1-D2----------------------------------------------
           4 : begin len_i = len_i - 4;  s_axis_rq_tkeep <= #(Tcq) 16'h000F; end  // D0-D1-D2-D3-------------------------------------------
           5 : begin len_i = len_i - 5;  s_axis_rq_tkeep <= #(Tcq) 16'h001F; end  // D0-D1-D2-D3-D4----------------------------------------
           6 : begin len_i = len_i - 6;  s_axis_rq_tkeep <= #(Tcq) 16'h003F; end  // D0-D1-D2-D3-D4-D5-------------------------------------
           7 : begin len_i = len_i - 7;  s_axis_rq_tkeep <= #(Tcq) 16'h007F; end  // D0-D1-D2-D3-D4-D5-D6----------------------------------
           8 : begin len_i = len_i - 8;  s_axis_rq_tkeep <= #(Tcq) 16'h00FF; end  // D0-D1-D2-D3-D4-D5-D6-D7-------------------------------
           9 : begin len_i = len_i - 9;  s_axis_rq_tkeep <= #(Tcq) 16'h01FF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8----------------------------
          10 : begin len_i = len_i - 10; s_axis_rq_tkeep <= #(Tcq) 16'h03FF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9------------------------
          11 : begin len_i = len_i - 11; s_axis_rq_tkeep <= #(Tcq) 16'h07FF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-------------------
          12 : begin len_i = len_i - 12; s_axis_rq_tkeep <= #(Tcq) 16'h0FFF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11----------------
          13 : begin len_i = len_i - 13; s_axis_rq_tkeep <= #(Tcq) 16'h1FFF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12------------
          14 : begin len_i = len_i - 14; s_axis_rq_tkeep <= #(Tcq) 16'h3FFF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13--------
          15 : begin len_i = len_i - 15; s_axis_rq_tkeep <= #(Tcq) 16'h7FFF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14----
           0 : begin len_i = len_i - 16; s_axis_rq_tkeep <= #(Tcq) 16'hFFFF; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
        endcase
      end else begin
        len_i = len_i - 16; s_axis_rq_tkeep <= #(Tcq) 16'hFFFF;      // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
      end

      if(len_i == 0)
        s_axis_rq_tlast <= #(Tcq) 1'b1;
      else
        s_axis_rq_tlast <= #(Tcq) 1'b0;

      // Call this just to check for the tready, but don't log anything. That's the job for pcie_tlp_data
      // The reason for splitting the TSK_TX_SYNCHRONIZE task and distribute them in both sequential group
      // is that in address aligned mode, it's possible that the additional padded zeros cause the AXIS RQ
      // to be one beat longer than the actual PCIe TLP. When it happens do not log the last clock beat
      // but just send the packet on AXIS RQ interface
      TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);

    end // for loop
  end // End sequential group 1 - AXIS RQ

  begin // Sequential group 2 - pcie_tlp
    for (_j = 20; _len != 0; _j = _j + 32) begin
      pcie_tlp_data <= #(Tcq) {
          DATA_STORE[_j + 0],
          DATA_STORE[_j + 1],
          DATA_STORE[_j + 2],
          DATA_STORE[_j + 3],
          DATA_STORE[_j + 4],
          DATA_STORE[_j + 5],
          DATA_STORE[_j + 6],
          DATA_STORE[_j + 7],
          DATA_STORE[_j + 8],
          DATA_STORE[_j + 9],
          DATA_STORE[_j + 10],
          DATA_STORE[_j + 11],
          DATA_STORE[_j + 12],
          DATA_STORE[_j + 13],
          DATA_STORE[_j + 14],
          DATA_STORE[_j + 15],
          DATA_STORE[_j + 16],
          DATA_STORE[_j + 17],
          DATA_STORE[_j + 18],
          DATA_STORE[_j + 19],
          DATA_STORE[_j + 20],
          DATA_STORE[_j + 21],
          DATA_STORE[_j + 22],
          DATA_STORE[_j + 23],
          DATA_STORE[_j + 24],
          DATA_STORE[_j + 25],
          DATA_STORE[_j + 26],
          DATA_STORE[_j + 27],
          DATA_STORE[_j + 28],
          DATA_STORE[_j + 29],
          DATA_STORE[_j + 30],
          DATA_STORE[_j + 31]
        };

      if((_len/16) == 0) begin
        case (_len % 16)
           1 : begin _len = _len - 1; pcie_tlp_rem  <= #(Tcq) 4'b1111; end  // D0--------------------------------------------------
           2 : begin _len = _len - 2; pcie_tlp_rem  <= #(Tcq) 4'b1110; end  // D0-
           3 : begin _len = _len - 3; pcie_tlp_rem  <= #(Tcq) 4'b1101; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           4 : begin _len = _len - 4; pcie_tlp_rem  <= #(Tcq) 4'b1100; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           5 : begin _len = _len - 5; pcie_tlp_rem  <= #(Tcq) 4'b1011; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           6 : begin _len = _len - 6; pcie_tlp_rem  <= #(Tcq) 4'b1010; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           7 : begin _len = _len - 7; pcie_tlp_rem  <= #(Tcq) 4'b1001; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           8 : begin _len = _len - 8; pcie_tlp_rem  <= #(Tcq) 4'b1000; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           9 : begin _len = _len - 9; pcie_tlp_rem  <= #(Tcq) 4'b0111; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          10 : begin _len = _len - 10; pcie_tlp_rem  <= #(Tcq) 4'b0110; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          11 : begin _len = _len - 11; pcie_tlp_rem  <= #(Tcq) 4'b0101; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          12 : begin _len = _len - 12; pcie_tlp_rem  <= #(Tcq) 4'b0100; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          13 : begin _len = _len - 13; pcie_tlp_rem  <= #(Tcq) 4'b0011; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          14 : begin _len = _len - 14; pcie_tlp_rem  <= #(Tcq) 4'b0010; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          15 : begin _len = _len - 15; pcie_tlp_rem  <= #(Tcq) 4'b0001; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
           0 : begin _len = _len - 16; pcie_tlp_rem  <= #(Tcq) 4'b0000; end  // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
        endcase
      end else begin
        _len = _len - 16; pcie_tlp_rem   <= #(Tcq) 4'b0000;     // D0-D1-D2-D3-D4-D5-D6-D7
      end

      if(_len == 0)
        TSK_TX_SYNCHRONIZE(0, 1, 1, `SYNC_RQ_RDY);
      else
        TSK_TX_SYNCHRONIZE(0, 1, 0, `SYNC_RQ_RDY);
      end // for loop
    end // End sequential group 2 - pcie_tlp
    join
  end  // if
  // End of Second and Subsequent Data Beat
  //-----------------------------------------------------------------------\\
  // Packet Complete - Drive 0s
  s_axis_rq_tvalid <= #(Tcq) 1'b0;
  s_axis_rq_tlast  <= #(Tcq) 1'b0;
  s_axis_rq_tkeep  <= #(Tcq) 8'h00;
  s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
  s_axis_rq_tdata  <= #(Tcq) 512'b0;
  //-----------------------------------------------------------------------\\
  pcie_tlp_rem <= #(Tcq) 3'b0;
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_MEMORY_WRITE_32

/************************************************************
Task : TSK_TX_MEMORY_WRITE_64
Inputs : Tag, Length, Address, Last Byte En, First Byte En
Outputs : Transaction Tx Interface Signaling
Description : Generates a Memory Write 64 TLP
*************************************************************/

task TSK_TX_MEMORY_WRITE_64;
  input  [7:0]    tag_;         // Tag
  input  [2:0]    tc_;          // Traffic Class
  input  [10:0]   len_;         // Length (in DW)
  input  [63:0]   addr_;        // Address
  input  [3:0]    last_dw_be_;  // Last DW Byte Enable
  input  [3:0]    first_dw_be_; // First DW Byte Enable
  input           ep_;          // Poisoned Data: Payload is invalid if set
  reg    [10:0]   _len;         // Length Info on pcie_tlp_data -- Used to count how many times to loop
  reg    [10:0]   len_i;        // Length Info on s_axis_rq_tdata -- Used to count how many times to loop
  reg    [2:0]    aa_dw;        // Adjusted DW Count for Address Aligned Mode
  reg    [255:0]  aa_data;      // Adjusted Data for Address Aligned Mode
  reg    [127:0]  data_axis_i;  // Data Info for s_axis_rq_tdata
  reg    [127:0]  data_pcie_i;  // Data Info for pcie_tlp_data
  integer         _j;           // Byte Index
  integer         start_addr;   // Start Location for Payload DW0
begin
  //-----------------------------------------------------------------------\\
  if(AXISTEN_IF_RQ_ALIGNMENT_MODE=="TRUE") begin
    start_addr  = 0;
    aa_dw = addr_[4:2];
  end else begin
    start_addr  = 48;
    aa_dw = 3'b000;
  end

  len_i = len_ + aa_dw;
  _len  = len_;
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  $display("[%t] : Mem64 Write Req @address %x", $realtime,addr_[31:0]);
  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);
  //-----------------------------------------------------------------------\\
  // Start of First Data Beat
  data_axis_i =  {
      DATA_STORE[15],
      DATA_STORE[14],
      DATA_STORE[13],
      DATA_STORE[12],
      DATA_STORE[11],
      DATA_STORE[10],
      DATA_STORE[9],
      DATA_STORE[8],
      DATA_STORE[7],
      DATA_STORE[6],
      DATA_STORE[5],
      DATA_STORE[4],
      DATA_STORE[3],
      DATA_STORE[2],
      DATA_STORE[1],
      DATA_STORE[0]
    };

  s_axis_rq_tuser_wo_parity <= #(Tcq) {
  //(AXISTEN_IF_RQ_PARITY_CHECK ?  s_axis_rq_tparity : 64'b0), // Parity
    64'b0,     // Parity Bit slot - 64bit
    6'b101010, // Seq Number - 6bit
    6'b101010, // Seq Number - 6bit
    16'h0000,  // TPH Steering Tag - 16 bit
    2'b00,     // TPH indirect Tag Enable - 2bit
    4'b0000,   // TPH Type - 4 bit
    2'b00,     // TPH Present - 2 bit
    1'b0,      // Discontinue
    4'b0000,   // is_eop1_ptr
    4'b1111,   // is_eop0_ptr
    2'b01,     // is_eop[1:0]
    2'b00,     // is_sop1_ptr[1:0]
    2'b00,     // is_sop0_ptr[1:0]
    2'b01,     // is_sop[1:0]
    2'b0,aa_dw[1:0],     // Byte Lane number in case of Address Aligned mode - 4 bit
    4'b0000,last_dw_be_, // Last BE of the Write Data 8 bit
    4'b0000,first_dw_be_ // First BE of the Write Data 8 bit
  };

  s_axis_rq_tdata <= #(Tcq) { 256'b0,//256
      ((AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE" ) ?  data_axis_i : 128'h0), // 128-bit write data
      //128
      1'b0,   // Force ECRC
      3'b000, // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      tc_,    // Traffic Class
      1'b1,   // RID Enable to use the Client supplied Bus/Device/Func No
      EP_BUS_DEV_FNS, // Completer ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      //96
      RP_BUS_DEV_FNS, // Requester ID -- Used only when RID enable = 1
      ep_,    // Poisoned Req
      4'b0001,// Req Type for MWr Req
      (set_malformed ? (len_ + 11'h4) : len_),  // DWORD Count
      //64
      addr_[63:2], // Memory Write address 64-bits
      2'b00   // AT -> 00 : Untranslated Address
    };

  //-----------------------------------------------------------------------\\
  data_pcie_i = {
      DATA_STORE[0],
      DATA_STORE[1],
      DATA_STORE[2],
      DATA_STORE[3],
      DATA_STORE[4],
      DATA_STORE[5],
      DATA_STORE[6],
      DATA_STORE[7],
      DATA_STORE[8],
      DATA_STORE[9],
      DATA_STORE[10],
      DATA_STORE[11],
      DATA_STORE[12],
      DATA_STORE[13],
      DATA_STORE[14],
      DATA_STORE[15]
    };

  pcie_tlp_data <= #(Tcq) {
      3'b011, // Fmt for 64-bit MWr Req
      5'b00000, // Type for 64-bit MWr Req
      1'b0,  // *reserved*
      tc_,   // 3-bit Traffic Class
      1'b0,  // *reserved*
      1'b0,  // Attributes {ID Based Ordering}
      1'b0,  // *reserved*
      1'b0,  // TLP Processing Hints
      1'b0,  // TLP Digest Present
      ep_,   // Poisoned Req
      2'b00, // Attributes {Relaxed Ordering, No Snoop}
      2'b00, // Address Translation
      (set_malformed ? (len_[9:0] + 10'h4) : len_[9:0]),  // DWORD Count
      RP_BUS_DEV_FNS, // Requester ID
      (ATTR_AXISTEN_IF_ENABLE_CLIENT_TAG ? 8'hCC : tag_), // Tag
      last_dw_be_,   // Last DW Byte Enable
      first_dw_be_, // First DW Byte Enable
      //64
      addr_[63:2], // Memory Write address 64-bits
      2'b00,      // *reserved*
      //128
      data_pcie_i // Payload Data
      //256
    };

  pcie_tlp_rem  <= #(Tcq) (_len > 3) ? 3'b000 : (4-_len);
  set_malformed <= #(Tcq) 1'b0;
  _len = (_len > 3) ? (_len - 11'h4) : 11'h0;
  //-----------------------------------------------------------------------\\
  s_axis_rq_tvalid <= #(Tcq) 1'b1;

  if(len_i > 4 || AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") begin
    s_axis_rq_tlast <= #(Tcq) 1'b0;
    s_axis_rq_tkeep <= #(Tcq) 8'hFF;

    len_i = (AXISTEN_IF_RQ_ALIGNMENT_MODE == "FALSE") ? (len_i - 4) : len_i; // Don't subtract 4 in Address Aligned because
                                                                             // it's always padded with zeros on first beat

    // pcie_tlp_data doesn't append zero even in Address Aligned mode, so it should mark this cycle as the last beat if it has no more payload to log.
    // The AXIS RQ interface will need to execute the next cycle, but we're just not going to log that data beat in pcie_tlp_data
    if(_len == 0)
      TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
    else
      TSK_TX_SYNCHRONIZE(1, 1, 0, `SYNC_RQ_RDY);
  end else begin
    if     (len_i == 1) s_axis_rq_tkeep <= #(Tcq) 8'h1F;
    else if(len_i == 2) s_axis_rq_tkeep <= #(Tcq) 8'h3F;
    else if(len_i == 3) s_axis_rq_tkeep <= #(Tcq) 8'h7F;
    else                s_axis_rq_tkeep <= #(Tcq) 8'hFF;

    s_axis_rq_tlast <= #(Tcq) 1'b1;
    len_i = 0;

    TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_RQ_RDY);
  end

  // End of First Data Beat
  //-----------------------------------------------------------------------\\
  // Start of Second and Subsequent Data Beat
  if(len_i != 0 || AXISTEN_IF_RQ_ALIGNMENT_MODE == "TRUE") begin
    fork
    begin // Sequential group 1 - AXIS RQ
      for (_j = start_addr; len_i != 0; _j = _j + 32) begin
        if(_j == start_addr) begin
          aa_data = {
              DATA_STORE[_j + 31],
              DATA_STORE[_j + 30],
              DATA_STORE[_j + 29],
              DATA_STORE[_j + 28],
              DATA_STORE[_j + 27],
              DATA_STORE[_j + 26],
              DATA_STORE[_j + 25],
              DATA_STORE[_j + 24],
              DATA_STORE[_j + 23],
              DATA_STORE[_j + 22],
              DATA_STORE[_j + 21],
              DATA_STORE[_j + 20],
              DATA_STORE[_j + 19],
              DATA_STORE[_j + 18],
              DATA_STORE[_j + 17],
              DATA_STORE[_j + 16],
              DATA_STORE[_j + 15],
              DATA_STORE[_j + 14],
              DATA_STORE[_j + 13],
              DATA_STORE[_j + 12],
              DATA_STORE[_j + 11],
              DATA_STORE[_j + 10],
              DATA_STORE[_j +  9],
              DATA_STORE[_j +  8],
              DATA_STORE[_j +  7],
              DATA_STORE[_j +  6],
              DATA_STORE[_j +  5],
              DATA_STORE[_j +  4],
              DATA_STORE[_j +  3],
              DATA_STORE[_j +  2],
              DATA_STORE[_j +  1],
              DATA_STORE[_j +  0]
            } << (aa_dw*4*8);
        end else begin
          aa_data = {
              DATA_STORE[_j + 31 - (aa_dw*4)],
              DATA_STORE[_j + 30 - (aa_dw*4)],
              DATA_STORE[_j + 29 - (aa_dw*4)],
              DATA_STORE[_j + 28 - (aa_dw*4)],
              DATA_STORE[_j + 27 - (aa_dw*4)],
              DATA_STORE[_j + 26 - (aa_dw*4)],
              DATA_STORE[_j + 25 - (aa_dw*4)],
              DATA_STORE[_j + 24 - (aa_dw*4)],
              DATA_STORE[_j + 23 - (aa_dw*4)],
              DATA_STORE[_j + 22 - (aa_dw*4)],
              DATA_STORE[_j + 21 - (aa_dw*4)],
              DATA_STORE[_j + 20 - (aa_dw*4)],
              DATA_STORE[_j + 19 - (aa_dw*4)],
              DATA_STORE[_j + 18 - (aa_dw*4)],
              DATA_STORE[_j + 17 - (aa_dw*4)],
              DATA_STORE[_j + 16 - (aa_dw*4)],
              DATA_STORE[_j + 15 - (aa_dw*4)],
              DATA_STORE[_j + 14 - (aa_dw*4)],
              DATA_STORE[_j + 13 - (aa_dw*4)],
              DATA_STORE[_j + 12 - (aa_dw*4)],
              DATA_STORE[_j + 11 - (aa_dw*4)],
              DATA_STORE[_j + 10 - (aa_dw*4)],
              DATA_STORE[_j +  9 - (aa_dw*4)],
              DATA_STORE[_j +  8 - (aa_dw*4)],
              DATA_STORE[_j +  7 - (aa_dw*4)],
              DATA_STORE[_j +  6 - (aa_dw*4)],
              DATA_STORE[_j +  5 - (aa_dw*4)],
              DATA_STORE[_j +  4 - (aa_dw*4)],
              DATA_STORE[_j +  3 - (aa_dw*4)],
              DATA_STORE[_j +  2 - (aa_dw*4)],
              DATA_STORE[_j +  1 - (aa_dw*4)],
              DATA_STORE[_j +  0 - (aa_dw*4)]
            };
        end

        s_axis_rq_tdata <= #(Tcq) aa_data;

        if((len_i)/8 == 0) begin
          case ((len_i) % 8)
            1 : begin len_i = len_i - 1; s_axis_rq_tkeep <= #(Tcq) 8'h01; end  // D0---------------------
            2 : begin len_i = len_i - 2; s_axis_rq_tkeep <= #(Tcq) 8'h03; end  // D0-D1------------------
            3 : begin len_i = len_i - 3; s_axis_rq_tkeep <= #(Tcq) 8'h07; end  // D0-D1-D2---------------
            4 : begin len_i = len_i - 4; s_axis_rq_tkeep <= #(Tcq) 8'h0F; end  // D0-D1-D2-D3------------
            5 : begin len_i = len_i - 5; s_axis_rq_tkeep <= #(Tcq) 8'h1F; end  // D0-D1-D2-D3-D4---------
            6 : begin len_i = len_i - 6; s_axis_rq_tkeep <= #(Tcq) 8'h3F; end  // D0-D1-D2-D3-D4-D5------
            7 : begin len_i = len_i - 7; s_axis_rq_tkeep <= #(Tcq) 8'h7F; end  // D0-D1-D2-D3-D4-D5-D6---
            0 : begin len_i = len_i - 8; s_axis_rq_tkeep <= #(Tcq) 8'hFF; end  // D0-D1-D2-D3-D4-D5-D6-D7
          endcase
        end else begin
          len_i = len_i - 8; s_axis_rq_tkeep <= #(Tcq) 8'hFF;      // D0-D1-D2-D3-D4-D5-D6-D7
        end

        if(len_i == 0)
            s_axis_rq_tlast <= #(Tcq) 1'b1;
        else
            s_axis_rq_tlast <= #(Tcq) 1'b0;

        // Call this just to check for the tready, but don't log anything. That's the job for pcie_tlp_data
        // The reason for splitting the TSK_TX_SYNCHRONIZE task and distribute them in both sequential group
        // is that in address aligned mode, it's possible that the additional padded zeros cause the AXIS RQ
        // to be one beat longer than the actual PCIe TLP. When it happens do not log the last clock beat
        // but just send the packet on AXIS RQ interface
        TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_RQ_RDY);

      end // for loop
    end // End sequential group 1 - AXIS RQ

    begin // Sequential group 2 - pcie_tlp
      for (_j = 16; _len != 0; _j = _j + 32) begin
        pcie_tlp_data <= #(Tcq) {
            DATA_STORE[_j + 0],
            DATA_STORE[_j + 1],
            DATA_STORE[_j + 2],
            DATA_STORE[_j + 3],
            DATA_STORE[_j + 4],
            DATA_STORE[_j + 5],
            DATA_STORE[_j + 6],
            DATA_STORE[_j + 7],
            DATA_STORE[_j + 8],
            DATA_STORE[_j + 9],
            DATA_STORE[_j + 10],
            DATA_STORE[_j + 11],
            DATA_STORE[_j + 12],
            DATA_STORE[_j + 13],
            DATA_STORE[_j + 14],
            DATA_STORE[_j + 15],
            DATA_STORE[_j + 16],
            DATA_STORE[_j + 17],
            DATA_STORE[_j + 18],
            DATA_STORE[_j + 19],
            DATA_STORE[_j + 20],
            DATA_STORE[_j + 21],
            DATA_STORE[_j + 22],
            DATA_STORE[_j + 23],
            DATA_STORE[_j + 24],
            DATA_STORE[_j + 25],
            DATA_STORE[_j + 26],
            DATA_STORE[_j + 27],
            DATA_STORE[_j + 28],
            DATA_STORE[_j + 29],
            DATA_STORE[_j + 30],
            DATA_STORE[_j + 31]
          };

        if((_len)/8 == 0) begin
          case ((_len) % 8)
            1 : begin _len = _len - 1; pcie_tlp_rem <= #(Tcq) 3'b111; end  // D0---------------------
            2 : begin _len = _len - 2; pcie_tlp_rem <= #(Tcq) 3'b110; end  // D0-D1------------------
            3 : begin _len = _len - 3; pcie_tlp_rem <= #(Tcq) 3'b101; end  // D0-D1-D2---------------
            4 : begin _len = _len - 4; pcie_tlp_rem <= #(Tcq) 3'b100; end  // D0-D1-D2-D3------------
            5 : begin _len = _len - 5; pcie_tlp_rem <= #(Tcq) 3'b011; end  // D0-D1-D2-D3-D4---------
            6 : begin _len = _len - 6; pcie_tlp_rem <= #(Tcq) 3'b010; end  // D0-D1-D2-D3-D4-D5------
            7 : begin _len = _len - 7; pcie_tlp_rem <= #(Tcq) 3'b001; end  // D0-D1-D2-D3-D4-D5-D6---
            0 : begin _len = _len - 8; pcie_tlp_rem <= #(Tcq) 3'b000; end  // D0-D1-D2-D3-D4-D5-D6-D7
          endcase
        end else begin
          _len               = _len - 8; pcie_tlp_rem <= #(Tcq) 3'b000; // D0-D1-D2-D3-D4-D5-D6-D7
        end

        if(_len == 0)
          TSK_TX_SYNCHRONIZE(0, 1, 1, `SYNC_RQ_RDY);
        else
          TSK_TX_SYNCHRONIZE(0, 1, 0, `SYNC_RQ_RDY);
      end // for loop
    end // End sequential group 2 - pcie_tlp

    join
  end // if
  // End of Second and Subsequent Data Beat
  //-----------------------------------------------------------------------\\
  // Packet Complete - Drive 0s
  s_axis_rq_tvalid         <= #(Tcq) 1'b0;
  s_axis_rq_tlast          <= #(Tcq) 1'b0;
  s_axis_rq_tkeep          <= #(Tcq) 8'h00;
  s_axis_rq_tuser_wo_parity<= #(Tcq) 137'b0;
  s_axis_rq_tdata          <= #(Tcq) 512'b0;
  //-----------------------------------------------------------------------\\
  pcie_tlp_rem             <= #(Tcq) 3'b000;
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_MEMORY_WRITE_64

/************************************************************
Task : TSK_TX_COMPLETION_DATA
Inputs : Tag, TC, Length, Completion ID
Outputs : Transaction Tx Interface Signaling
Description : Generates a Completion TLP
*************************************************************/

task TSK_TX_COMPLETION_DATA;
  input   [15:0]   req_id_;      // Requester ID
  input   [7:0]    tag_;         // Tag
  input   [2:0]    tc_;          // Traffic Class
  input   [10:0]   len_;         // Length (in DW)
  input   [11:0]   byte_count_;  // Length (in bytes)
  input   [15:0]   lower_addr_;  // Lower 7-bits of Address of first valid data
  input [RP_BAR_SIZE:0] ram_ptr; // RP RAM Read Offset
  input   [2:0]    comp_status_; // Completion Status. 'b000: Success; 'b001: Unsupported Request; 'b010: Config Request Retry Status;'b100: Completer Abort
  input            ep_;          // Poisoned Data: Payload is invalid if set
  input   [2:0]    attr_;        // Attributes. {ID Based Ordering, Relaxed Ordering, No Snoop}
  reg     [10:0]   _len;         // Length Info on pcie_tlp_data -- Used to count how many times to loop
  reg     [10:0]   len_i;        // Length Info on s_axis_rq_tdata -- Used to count how many times to loop
  reg     [2:0]    aa_dw;        // Adjusted DW Count for Address Aligned Mode
  reg     [511:0]  aa_data;      // Adjusted Data for Address Aligned Mode
  reg     [415:0]  data_axis_i;  // Data Info for s_axis_rq_tdata
  reg     [415:0]  data_pcie_i;  // Data Info for pcie_tlp_data
  reg     [RP_BAR_SIZE:0]   _j;  // Byte Index for aa_data
  reg     [RP_BAR_SIZE:0]  _jj;  // Byte Index pcie_tlp_data
  integer          start_addr;   // Start Location for Payload DW0

begin
  //-----------------------------------------------------------------------\\
  $display(" ***** TSK_TX_COMPLETION_DATA ****** addr = %d., byte_count =%d, len = %d, comp_status = %d\n", lower_addr_, byte_count_, len_, comp_status_ ) ;
  //$display("[%t] : CC Data Completion Task Begin", $realtime);
  if(AXISTEN_IF_CC_ALIGNMENT_MODE=="TRUE") begin
      start_addr  = 0;
      aa_dw   = lower_addr_[4:2];
  end else begin
      start_addr  = 52;
      aa_dw   = 3'b000;
  end

  len_i = len_ + aa_dw;
  _len  = len_;
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end

  //-----------------------------------------------------------------------\\
  TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_CC_RDY);
  //-----------------------------------------------------------------------\\
  // Start of First Data Beat
  data_axis_i = {
      DATA_STORE[lower_addr_ +51], DATA_STORE[lower_addr_ +50], DATA_STORE[lower_addr_ +49],
      DATA_STORE[lower_addr_ +48], DATA_STORE[lower_addr_ +47], DATA_STORE[lower_addr_ +46],
      DATA_STORE[lower_addr_ +45], DATA_STORE[lower_addr_ +44], DATA_STORE[lower_addr_ +43],
      DATA_STORE[lower_addr_ +42], DATA_STORE[lower_addr_ +41], DATA_STORE[lower_addr_ +40],
      DATA_STORE[lower_addr_ +39], DATA_STORE[lower_addr_ +38], DATA_STORE[lower_addr_ +37],
      DATA_STORE[lower_addr_ +36], DATA_STORE[lower_addr_ +35], DATA_STORE[lower_addr_ +34],
      DATA_STORE[lower_addr_ +33], DATA_STORE[lower_addr_ +32], DATA_STORE[lower_addr_ +31],
      DATA_STORE[lower_addr_ +30], DATA_STORE[lower_addr_ +29], DATA_STORE[lower_addr_ +28],
      DATA_STORE[lower_addr_ +27], DATA_STORE[lower_addr_ +26], DATA_STORE[lower_addr_ +25],
      DATA_STORE[lower_addr_ +24], DATA_STORE[lower_addr_ +23], DATA_STORE[lower_addr_ +22],
      DATA_STORE[lower_addr_ +21], DATA_STORE[lower_addr_ +20], DATA_STORE[lower_addr_ +19],
      DATA_STORE[lower_addr_ +18], DATA_STORE[lower_addr_ +17], DATA_STORE[lower_addr_ +16],
      DATA_STORE[lower_addr_ +15], DATA_STORE[lower_addr_ +14], DATA_STORE[lower_addr_ +13],
      DATA_STORE[lower_addr_ +12], DATA_STORE[lower_addr_ +11], DATA_STORE[lower_addr_ +10],
      DATA_STORE[lower_addr_ + 9], DATA_STORE[lower_addr_ + 8], DATA_STORE[lower_addr_ + 7],
      DATA_STORE[lower_addr_ + 6], DATA_STORE[lower_addr_ + 5], DATA_STORE[lower_addr_ + 4],
      DATA_STORE[lower_addr_ + 3], DATA_STORE[lower_addr_ + 2], DATA_STORE[lower_addr_ + 1],
      DATA_STORE[lower_addr_ + 0]
    };

  data_pcie_i = {
      DATA_STORE[lower_addr_ + 0], DATA_STORE[lower_addr_ + 1], DATA_STORE[lower_addr_ + 2],
      DATA_STORE[lower_addr_ + 3], DATA_STORE[lower_addr_ + 4], DATA_STORE[lower_addr_ + 5],
      DATA_STORE[lower_addr_ + 6], DATA_STORE[lower_addr_ + 7], DATA_STORE[lower_addr_ + 8],
      DATA_STORE[lower_addr_ + 9], DATA_STORE[lower_addr_ +10], DATA_STORE[lower_addr_ +11],
      DATA_STORE[lower_addr_ +12], DATA_STORE[lower_addr_ +13], DATA_STORE[lower_addr_ +14],
      DATA_STORE[lower_addr_ +15], DATA_STORE[lower_addr_ +16], DATA_STORE[lower_addr_ +17],
      DATA_STORE[lower_addr_ +18], DATA_STORE[lower_addr_ +19], DATA_STORE[lower_addr_ +20],
      DATA_STORE[lower_addr_ +21], DATA_STORE[lower_addr_ +22], DATA_STORE[lower_addr_ +23],
      DATA_STORE[lower_addr_ +24], DATA_STORE[lower_addr_ +25], DATA_STORE[lower_addr_ +26],
      DATA_STORE[lower_addr_ +27], DATA_STORE[lower_addr_ +28], DATA_STORE[lower_addr_ +29],
      DATA_STORE[lower_addr_ +30], DATA_STORE[lower_addr_ +31], DATA_STORE[lower_addr_ +32],
      DATA_STORE[lower_addr_ +33], DATA_STORE[lower_addr_ +34], DATA_STORE[lower_addr_ +35],
      DATA_STORE[lower_addr_ +36], DATA_STORE[lower_addr_ +37], DATA_STORE[lower_addr_ +38],
      DATA_STORE[lower_addr_ +39], DATA_STORE[lower_addr_ +40], DATA_STORE[lower_addr_ +41],
      DATA_STORE[lower_addr_ +42], DATA_STORE[lower_addr_ +43], DATA_STORE[lower_addr_ +44],
      DATA_STORE[lower_addr_ +45], DATA_STORE[lower_addr_ +46], DATA_STORE[lower_addr_ +47],
      DATA_STORE[lower_addr_ +48], DATA_STORE[lower_addr_ +49], DATA_STORE[lower_addr_ +50],
      DATA_STORE[lower_addr_ +51]
    };

//s_axis_cc_tuser <= #(Tcq) {(AXISTEN_IF_CC_PARITY_CHECK ? s_axis_cc_tparity : 32'b0),1'b0};
  s_axis_cc_tuser <= #(Tcq) {/*(AXISTEN_IF_CC_PARITY_CHECK ? s_axis_cc_tparity :*/ 64'b0, // parity 64 bit -[80:17]
      1'b0,    // Discontinue
      4'b0000, // is_eop1_ptr
      4'b1010, // is_eop0_ptr  There are 11 Dwords 0-10, 0xA
      2'b01,   // is_eop[1:0]
      2'b00,   // is_sop1_ptr[1:0]
      2'b00,   // is_sop0_ptr[1:0]
      2'b01};  // is_sop[1:0]

  s_axis_cc_tdata <= #(Tcq) {
      ((AXISTEN_IF_CC_ALIGNMENT_MODE == "FALSE" ) ? data_axis_i : 416'h0), // 416-bit completion data
      1'b0,   // Force ECRC                                  //96
      attr_,  // Attributes {ID Based Ordering, Relaxed Ordering, No Snoop}
      tc_,    // Traffic Class
      1'b1,   // Completer ID to Control Selection of Client
      RP_BUS_DEV_FNS, // Completer ID
      tag_ ,  // Tag
      req_id_,// Requester ID                             //64
      1'b0,   // *reserved*
      ep_,    // Poisoned Completion
      comp_status_,  // Completion Status {0= SC, 1= UR, 2= CRS, 4= CA}
      len_,   // DWORD Count
      2'b0,   // *reserved*                               //32
      1'b0,   // Locked Read Completion
      1'b0,   // Byte Count MSB
      byte_count_, // Byte Count
      6'b0,   // *reserved*
      2'b0,   // Address Type
      1'b0,   // *reserved*
      lower_addr_[6:0] };  // Starting Address of the Completion Data Byte
  //-----------------------------------------------------------------------\\
  pcie_tlp_data     <= #(Tcq) {
       3'b010,   // Fmt for Completion with Data
       5'b01010, // Type for Completion with Data
       1'b0,     // *reserved*
       tc_,      // 3-bit Traffic Class
       1'b0,     // *reserved*
       attr_[2], // Attributes {ID Based Ordering}
       1'b0,     // *reserved*
       1'b0,     // TLP Processing Hints
       1'b0,     // TLP Digest Present
       ep_,      // Poisoned Req
       attr_[1:0], // Attributes {Relaxed Ordering, No Snoop}
       2'b00,    // Address Translation
       len_[9:0],// DWORD Count //32
       RP_BUS_DEV_FNS, // Completer ID
       comp_status_,   // Completion Status {0= SC, 1= UR, 2= CRS, 4= CA}
       1'b0,     // Byte Count Modified (only used in PCI-X)
       byte_count_,  // Byte Count  //64
       req_id_,  // Requester ID
       tag_,     // Tag
       1'b0,     // *reserved
       lower_addr_[6:0], // Starting Address of the Completion Data Byte //96
       data_pcie_i };  // 416-bit completion data //512

  pcie_tlp_rem <= #(Tcq) (_len > 12) ? 4'b0000 : (13-_len);
  _len = (_len > 12) ? (_len - 11'hD) : 11'h0;
  //-----------------------------------------------------------------------\\
  s_axis_cc_tvalid  <= #(Tcq) 1'b1;

  if(len_i > 13 || AXISTEN_IF_CC_ALIGNMENT_MODE == "TRUE") begin
    s_axis_cc_tlast          <= #(Tcq) 1'b0;
    s_axis_cc_tkeep          <= #(Tcq) 16'hFFFF;

    len_i = (AXISTEN_IF_CC_ALIGNMENT_MODE == "FALSE") ? (len_i - 11'hD) : len_i; // Don't subtract 13 in Address Aligned because
                                                                                // it's always padded with zeros on first beat

    // pcie_tlp_data doesn't append zero even in Address Aligned mode, so it should mark this cycle as the last beat if it has no more payload to log.
    // The AXIS CC interface will need to execute the next cycle, but we're just not going to log that data beat in pcie_tlp_data
    if(_len == 0)
      TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_CC_RDY);
    else
      TSK_TX_SYNCHRONIZE(1, 1, 0, `SYNC_CC_RDY);

  end else begin
    case (len_i)
      1 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h000F; end
      2 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h001F; end
      3 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h003F; end
      4 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h007F; end
      5 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h00FF; end
      6 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h01FF; end
      7 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h03FF; end
      8 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h07FF; end
      9 :  begin s_axis_cc_tkeep <= #(Tcq) 16'h0FFF; end
      10 : begin s_axis_cc_tkeep <= #(Tcq) 16'h1FFF; end
      11 : begin s_axis_cc_tkeep <= #(Tcq) 16'h3FFF; end
      12 : begin s_axis_cc_tkeep <= #(Tcq) 16'h7FFF; end
      default: begin s_axis_cc_tkeep <= #(Tcq) 16'hFFFF; end
    endcase

    s_axis_cc_tlast <= #(Tcq) 1'b1;

    len_i = 0;

    TSK_TX_SYNCHRONIZE(1, 1, 1, `SYNC_CC_RDY);
  end
  // End of First Data Beat
  //-----------------------------------------------------------------------\\
  // Start of Second and Subsequent Data Beat
  if(len_i != 0 || AXISTEN_IF_CC_ALIGNMENT_MODE == "TRUE") begin
    fork
    begin // Sequential group 1 - AXIS CC
      for (_j = start_addr; len_i != 0; _j = _j + 64) begin
        if(_j == start_addr) begin
          aa_data = {
              DATA_STORE[lower_addr_ + _j + 63], DATA_STORE[lower_addr_ + _j + 62], DATA_STORE[lower_addr_ + _j + 61],
              DATA_STORE[lower_addr_ + _j + 60], DATA_STORE[lower_addr_ + _j + 59], DATA_STORE[lower_addr_ + _j + 58],
              DATA_STORE[lower_addr_ + _j + 57], DATA_STORE[lower_addr_ + _j + 56], DATA_STORE[lower_addr_ + _j + 55],
              DATA_STORE[lower_addr_ + _j + 54], DATA_STORE[lower_addr_ + _j + 53], DATA_STORE[lower_addr_ + _j + 52],
              DATA_STORE[lower_addr_ + _j + 51], DATA_STORE[lower_addr_ + _j + 50], DATA_STORE[lower_addr_ + _j + 49],
              DATA_STORE[lower_addr_ + _j + 48], DATA_STORE[lower_addr_ + _j + 47], DATA_STORE[lower_addr_ + _j + 46],
              DATA_STORE[lower_addr_ + _j + 45], DATA_STORE[lower_addr_ + _j + 44], DATA_STORE[lower_addr_ + _j + 43],
              DATA_STORE[lower_addr_ + _j + 42], DATA_STORE[lower_addr_ + _j + 41], DATA_STORE[lower_addr_ + _j + 40],
              DATA_STORE[lower_addr_ + _j + 39], DATA_STORE[lower_addr_ + _j + 38], DATA_STORE[lower_addr_ + _j + 37],
              DATA_STORE[lower_addr_ + _j + 36], DATA_STORE[lower_addr_ + _j + 35], DATA_STORE[lower_addr_ + _j + 34],
              DATA_STORE[lower_addr_ + _j + 33], DATA_STORE[lower_addr_ + _j + 32], DATA_STORE[lower_addr_ + _j + 31],
              DATA_STORE[lower_addr_ + _j + 30], DATA_STORE[lower_addr_ + _j + 29], DATA_STORE[lower_addr_ + _j + 28],
              DATA_STORE[lower_addr_ + _j + 27], DATA_STORE[lower_addr_ + _j + 26], DATA_STORE[lower_addr_ + _j + 25],
              DATA_STORE[lower_addr_ + _j + 24], DATA_STORE[lower_addr_ + _j + 23], DATA_STORE[lower_addr_ + _j + 22],
              DATA_STORE[lower_addr_ + _j + 21], DATA_STORE[lower_addr_ + _j + 20], DATA_STORE[lower_addr_ + _j + 19],
              DATA_STORE[lower_addr_ + _j + 18], DATA_STORE[lower_addr_ + _j + 17], DATA_STORE[lower_addr_ + _j + 16],
              DATA_STORE[lower_addr_ + _j + 15], DATA_STORE[lower_addr_ + _j + 14], DATA_STORE[lower_addr_ + _j + 13],
              DATA_STORE[lower_addr_ + _j + 12], DATA_STORE[lower_addr_ + _j + 11], DATA_STORE[lower_addr_ + _j + 10],
              DATA_STORE[lower_addr_ + _j +  9], DATA_STORE[lower_addr_ + _j +  8], DATA_STORE[lower_addr_ + _j +  7],
              DATA_STORE[lower_addr_ + _j +  6], DATA_STORE[lower_addr_ + _j +  5], DATA_STORE[lower_addr_ + _j +  4],
              DATA_STORE[lower_addr_ + _j +  3], DATA_STORE[lower_addr_ + _j +  2], DATA_STORE[lower_addr_ + _j +  1],
              DATA_STORE[lower_addr_ + _j +  0]
            } << (aa_dw*4*8);
        end else begin
          aa_data = {
              DATA_STORE[lower_addr_ + _j + 63 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 62 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 61 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 60 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 59 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 58 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 57 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 56 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 55 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 54 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 53 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 52 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 51 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 50 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 49 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 48 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 47 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 46 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 45 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 44 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 43 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 42 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 41 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 40 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 39 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 38 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 37 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 36 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 35 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 34 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 33 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 32 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 31 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 30 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 29 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 28 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 27 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 26 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 25 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 24 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 23 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 22 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 21 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 20 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 19 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 18 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 17 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 16 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 15 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 14 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 13 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j + 12 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 11 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j + 10 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j +  9 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  8 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  7 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j +  6 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  5 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  4 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j +  3 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  2 - (aa_dw*4)], DATA_STORE[lower_addr_ + _j +  1 - (aa_dw*4)],
              DATA_STORE[lower_addr_ + _j +  0 - (aa_dw*4)]
            };
        end

        s_axis_cc_tdata <= #(Tcq) aa_data;

        if((len_i)/16 == 0) begin
          case (len_i % 16)
            1 :  begin len_i = len_i - 1;  s_axis_cc_tkeep <= #(Tcq) 16'h0001; end // D0---------------------------------------------------
            2 :  begin len_i = len_i - 2;  s_axis_cc_tkeep <= #(Tcq) 16'h0003; end // D0-D1------------------------------------------------
            3 :  begin len_i = len_i - 3;  s_axis_cc_tkeep <= #(Tcq) 16'h0007; end // D0-D1-D2---------------------------------------------
            4 :  begin len_i = len_i - 4;  s_axis_cc_tkeep <= #(Tcq) 16'h000F; end // D0-D1-D2-D3------------------------------------------
            5 :  begin len_i = len_i - 5;  s_axis_cc_tkeep <= #(Tcq) 16'h001F; end // D0-D1-D2-D3-D4---------------------------------------
            6 :  begin len_i = len_i - 6;  s_axis_cc_tkeep <= #(Tcq) 16'h003F; end // D0-D1-D2-D3-D4-D5------------------------------------
            7 :  begin len_i = len_i - 7;  s_axis_cc_tkeep <= #(Tcq) 16'h007F; end // D0-D1-D2-D3-D4-D5-D6---------------------------------
            8 :  begin len_i = len_i - 8;  s_axis_cc_tkeep <= #(Tcq) 16'h00FF; end // D0-D1-D2-D3-D4-D5-D6-D7------------------------------
            9 :  begin len_i = len_i - 9;  s_axis_cc_tkeep <= #(Tcq) 16'h01FF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8---------------------------
            10 : begin len_i = len_i - 10; s_axis_cc_tkeep <= #(Tcq) 16'h03FF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9------------------------
            11 : begin len_i = len_i - 11; s_axis_cc_tkeep <= #(Tcq) 16'h07FF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10--------------------
            12 : begin len_i = len_i - 12; s_axis_cc_tkeep <= #(Tcq) 16'h0FFF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11----------------
            13 : begin len_i = len_i - 13; s_axis_cc_tkeep <= #(Tcq) 16'h1FFF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12------------
            14 : begin len_i = len_i - 14; s_axis_cc_tkeep <= #(Tcq) 16'h3FFF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13--------
            15 : begin len_i = len_i - 15; s_axis_cc_tkeep <= #(Tcq) 16'h7FFF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14----
            0  : begin len_i = len_i - 16; s_axis_cc_tkeep <= #(Tcq) 16'hFFFF; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          endcase
        end else begin
          len_i = len_i - 16; s_axis_cc_tkeep <= #(Tcq) 16'hFFFF;     // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
        end

        if(len_i == 0)
          s_axis_cc_tlast <= #(Tcq) 1'b1;
        else
          s_axis_cc_tlast <= #(Tcq) 1'b0;

          // Call this just to check for the tready, but don't log anything. That's the job for pcie_tlp_data
          // The reason for splitting the TSK_TX_SYNCHRONIZE task and distribute them in both sequential group
          // is that in address aligned mode, it's possible that the additional padded zeros cause the AXIS CC
          // to be one beat longer than the actual PCIe TLP. When it happens do not log the last clock beat
          // but just send the packet on AXIS CC interface
          TSK_TX_SYNCHRONIZE(0, 0, 0, `SYNC_CC_RDY);

      end // for loop
    end // End sequential group 1 - AXIS CC

    begin // Sequential group 2 - pcie_tlp
      for (_jj = 52; _len != 0; _jj = _jj + 64) begin
        pcie_tlp_data <= #(Tcq) {
            DATA_STORE[lower_addr_ + _jj +  0], DATA_STORE[lower_addr_ + _jj +  1], DATA_STORE[lower_addr_ + _jj +  2],
            DATA_STORE[lower_addr_ + _jj +  3], DATA_STORE[lower_addr_ + _jj +  4], DATA_STORE[lower_addr_ + _jj +  5],
            DATA_STORE[lower_addr_ + _jj +  6], DATA_STORE[lower_addr_ + _jj +  7], DATA_STORE[lower_addr_ + _jj +  8],
            DATA_STORE[lower_addr_ + _jj +  9], DATA_STORE[lower_addr_ + _jj + 10], DATA_STORE[lower_addr_ + _jj + 11],
            DATA_STORE[lower_addr_ + _jj + 12], DATA_STORE[lower_addr_ + _jj + 13], DATA_STORE[lower_addr_ + _jj + 14],
            DATA_STORE[lower_addr_ + _jj + 15], DATA_STORE[lower_addr_ + _jj + 16], DATA_STORE[lower_addr_ + _jj + 17],
            DATA_STORE[lower_addr_ + _jj + 18], DATA_STORE[lower_addr_ + _jj + 19], DATA_STORE[lower_addr_ + _jj + 20],
            DATA_STORE[lower_addr_ + _jj + 21], DATA_STORE[lower_addr_ + _jj + 22], DATA_STORE[lower_addr_ + _jj + 23],
            DATA_STORE[lower_addr_ + _jj + 24], DATA_STORE[lower_addr_ + _jj + 25], DATA_STORE[lower_addr_ + _jj + 26],
            DATA_STORE[lower_addr_ + _jj + 27], DATA_STORE[lower_addr_ + _jj + 28], DATA_STORE[lower_addr_ + _jj + 29],
            DATA_STORE[lower_addr_ + _jj + 30], DATA_STORE[lower_addr_ + _jj + 31], DATA_STORE[lower_addr_ + _jj + 32],
            DATA_STORE[lower_addr_ + _jj + 33], DATA_STORE[lower_addr_ + _jj + 34], DATA_STORE[lower_addr_ + _jj + 35],
            DATA_STORE[lower_addr_ + _jj + 36], DATA_STORE[lower_addr_ + _jj + 37], DATA_STORE[lower_addr_ + _jj + 38],
            DATA_STORE[lower_addr_ + _jj + 39], DATA_STORE[lower_addr_ + _jj + 40], DATA_STORE[lower_addr_ + _jj + 41],
            DATA_STORE[lower_addr_ + _jj + 42], DATA_STORE[lower_addr_ + _jj + 43], DATA_STORE[lower_addr_ + _jj + 44],
            DATA_STORE[lower_addr_ + _jj + 45], DATA_STORE[lower_addr_ + _jj + 46], DATA_STORE[lower_addr_ + _jj + 47],
            DATA_STORE[lower_addr_ + _jj + 48], DATA_STORE[lower_addr_ + _jj + 49], DATA_STORE[lower_addr_ + _jj + 50],
            DATA_STORE[lower_addr_ + _jj + 51], DATA_STORE[lower_addr_ + _jj + 52], DATA_STORE[lower_addr_ + _jj + 53],
            DATA_STORE[lower_addr_ + _jj + 54], DATA_STORE[lower_addr_ + _jj + 55], DATA_STORE[lower_addr_ + _jj + 56],
            DATA_STORE[lower_addr_ + _jj + 57], DATA_STORE[lower_addr_ + _jj + 58], DATA_STORE[lower_addr_ + _jj + 59],
            DATA_STORE[lower_addr_ + _jj + 60], DATA_STORE[lower_addr_ + _jj + 61], DATA_STORE[lower_addr_ + _jj + 62],
            DATA_STORE[lower_addr_ + _jj + 63]
          };

        if((_len/16) == 0) begin
          case (_len % 16)
            1 :  begin _len = _len - 1;  pcie_tlp_rem  <= #(Tcq) 4'b1111; end // D0---------------------------------------------------
            2 :  begin _len = _len - 2;  pcie_tlp_rem  <= #(Tcq) 4'b1110; end // D0-D1------------------------------------------------
            3 :  begin _len = _len - 3;  pcie_tlp_rem  <= #(Tcq) 4'b1101; end // D0-D1-D2---------------------------------------------
            4 :  begin _len = _len - 4;  pcie_tlp_rem  <= #(Tcq) 4'b1100; end // D0-D1-D2-D3------------------------------------------
            5 :  begin _len = _len - 5;  pcie_tlp_rem  <= #(Tcq) 4'b1011; end // D0-D1-D2-D3-D4---------------------------------------
            6 :  begin _len = _len - 6;  pcie_tlp_rem  <= #(Tcq) 4'b1010; end // D0-D1-D2-D3-D4-D5------------------------------------
            7 :  begin _len = _len - 7;  pcie_tlp_rem  <= #(Tcq) 4'b1001; end // D0-D1-D2-D3-D4-D5-D6---------------------------------
            8 :  begin _len = _len - 8;  pcie_tlp_rem  <= #(Tcq) 4'b1000; end // D0-D1-D2-D3-D4-D5-D6-D7------------------------------
            9 :  begin _len = _len - 9;  pcie_tlp_rem  <= #(Tcq) 4'b0111; end // D0-D1-D2-D3-D4-D5-D6-D7-D8---------------------------
            10 : begin _len = _len - 10; pcie_tlp_rem  <= #(Tcq) 4'b0110; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9------------------------
            11 : begin _len = _len - 11; pcie_tlp_rem  <= #(Tcq) 4'b0101; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10--------------------
            12 : begin _len = _len - 12; pcie_tlp_rem  <= #(Tcq) 4'b0100; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11----------------
            13 : begin _len = _len - 13; pcie_tlp_rem  <= #(Tcq) 4'b0011; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12------------
            14 : begin _len = _len - 14; pcie_tlp_rem  <= #(Tcq) 4'b0010; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13--------
            15 : begin _len = _len - 15; pcie_tlp_rem  <= #(Tcq) 4'b0001; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14----
            0  : begin _len = _len - 16; pcie_tlp_rem  <= #(Tcq) 4'b0000; end // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
          endcase
        end else begin
          _len = _len - 16; pcie_tlp_rem  <= #(Tcq) 4'b0000;     // D0-D1-D2-D3-D4-D5-D6-D7-D8-D9-D10-D11-D12-D13-D14-D15
        end

        if(_len == 0)
          TSK_TX_SYNCHRONIZE(0, 1, 1, `SYNC_CC_RDY);
        else
          TSK_TX_SYNCHRONIZE(0, 1, 0, `SYNC_CC_RDY);
        end // for loop
      end // End sequential group 2 - pcie_tlp

    join
  end  // if
  // End of Second and Subsequent Data Beat
  //-----------------------------------------------------------------------\\
  // Packet Complete - Drive 0s
  s_axis_cc_tvalid <= #(Tcq) 1'b0;
  s_axis_cc_tlast  <= #(Tcq) 1'b0;
  s_axis_cc_tkeep  <= #(Tcq) 8'h00;
  s_axis_cc_tuser  <= #(Tcq) 83'b0;
  s_axis_cc_tdata  <= #(Tcq) 512'b0;
  //-----------------------------------------------------------------------\\
  pcie_tlp_rem <= #(Tcq) 4'b0000;
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_COMPLETION_DATA

/************************************************************
Task : TSK_TX_SYNCHRONIZE
Inputs : None
Outputs : None
Description : Synchronize with tx clock and handshake signals
*************************************************************/

task TSK_TX_SYNCHRONIZE;
  input first_;     // effectively sof
  input active_;    // in pkt -- for pcie_tlp_data signaling only
  input last_call_; // eof
  input tready_sw_; // A switch to select CC or RQ tready

begin
  //-----------------------------------------------------------------------\\
  if(user_lnk_up_n) begin
    $display("[%t] :  interface is MIA", $realtime);
    $finish(1);
  end
  //-----------------------------------------------------------------------\\

  @(posedge user_clk);
  if(tready_sw_ == `SYNC_CC_RDY) begin
    while (s_axis_cc_tready == 1'b0) begin
      @(posedge user_clk);
    end
  end else begin // tready_sw_ == `SYNC_RQ_RDY
    while (s_axis_rq_tready == 1'b0) begin
      @(posedge user_clk);
    end
  end
  //-----------------------------------------------------------------------\\
  if(active_ == 1'b1) begin
    // read data driven into memory
    board.RP.com_usrapp.TSK_READ_DATA_512(first_, last_call_,`TX_LOG,pcie_tlp_data,pcie_tlp_rem);
  end
  //-----------------------------------------------------------------------\\
  if(last_call_)
    board.RP.com_usrapp.TSK_PARSE_FRAME(`TX_LOG);
  //-----------------------------------------------------------------------\\
end
endtask // TSK_TX_SYNCHRONIZE

/************************************************************
Task : TSK_USR_DATA_SETUP_SEQ
Inputs : None
Outputs : None
Description : Populates scratch pad data area with known good data.
*************************************************************/

task TSK_USR_DATA_SETUP_SEQ;
  integer        i_;
begin
  for (i_ = 0; i_ <= 4095; i_ = i_ + 1)
    DATA_STORE[i_] = i_;
  for (i_ = 0; i_ <= (2**(RP_BAR_SIZE+1))-1; i_ = i_ + 1)
    DATA_STORE_2[i_] = i_;
end
endtask // TSK_USR_DATA_SETUP_SEQ

/************************************************************
Task : TSK_TX_CLK_EAT
Inputs : None
Outputs : None
Description : Consume clocks.
*************************************************************/

task TSK_TX_CLK_EAT;
  input [31:0] clock_count;
  integer i_;
begin
  for (i_ = 0; i_ < clock_count; i_ = i_ + 1) 
    @(posedge user_clk);    
end
endtask // TSK_TX_CLK_EAT

/************************************************************
Task: TSK_SIMULATION_TIMEOUT
Description: Set simulation timeout value
*************************************************************/
task TSK_SIMULATION_TIMEOUT;
  input [31:0] timeout;
begin
    force board.RP.rx_usrapp.sim_timeout = timeout;
  end
endtask

/************************************************************
Task : TSK_SET_READ_DATA
Inputs : Data
Outputs : None
Description : Called from common app. Common app hands read
              data to usrapp_tx.
*************************************************************/

task TSK_SET_READ_DATA;
  input   [3:0]   be_;   // not implementing be's yet
  input   [63:0]  data_; // might need to change this to byte
begin
  P_READ_DATA   = data_[31:0];
  P_READ_DATA_2 = data_[63:32];
  P_READ_DATA_VALID = 1;
end
endtask // TSK_SET_READ_DATA

/************************************************************
Task : TSK_WAIT_FOR_READ_DATA
Inputs : None
Outputs : Read data P_READ_DATA will be valid
Description : Called from tx app. Common app hands read
              data to usrapp_tx. This task must be executed
              immediately following a call to
              TSK_TX_TYPE0_CONFIGURATION_READ in order for the
              read process to function correctly. Otherwise
              there is a potential race condition with
              P_READ_DATA_VALID.
*************************************************************/

task TSK_WAIT_FOR_READ_DATA;
  integer j;
begin
  j = 30;
  P_READ_DATA_VALID = 0;
  fork
    while ((!P_READ_DATA_VALID) && (cpld_to == 0)) @(posedge user_clk);
    begin // second process
      while ((j > 0) && (!P_READ_DATA_VALID))
      begin
        TSK_TX_CLK_EAT(500);
        j = j - 1;
      end
      if(!P_READ_DATA_VALID) begin
        cpld_to = 1;
        if(cpld_to_finish == 1) begin
          $display("TEST FAIL: TIMEOUT ERROR in usrapp_tx:TSK_WAIT_FOR_READ_DATA. Completion data never received.");
          board.RP.tx_usrapp.test_state =1;
          $finish;
        end
      else begin
        $display("TEST FAIL: TIMEOUT WARNING in usrapp_tx:TSK_WAIT_FOR_READ_DATA. Completion data never received.");
        board.RP.tx_usrapp.test_state = 1;
      end
    end
  end
  join
end
endtask // TSK_WAIT_FOR_READ_DATA

/************************************************************
Function : TSK_DISPLAY_PCIE_MAP
Inputs : none
Outputs : none
Description : Displays the Memory Manager's P_MAP calculations
              based on range values read from PCI_E device.
*************************************************************/

task TSK_DISPLAY_PCIE_MAP;
  reg[2:0] ii;
begin
  for (ii=0; ii <= 6; ii = ii + 1) begin
    if(ii !=6) begin
      $display("\tBAR %x: VALUE = %x RANGE = %x TYPE = %s", ii, BAR_INIT_P_BAR[ii][31:0],
          BAR_INIT_P_BAR_RANGE[ii], BAR_INIT_MESSAGE[BAR_INIT_P_BAR_ENABLED[ii]]);
    end
    else begin
      $display("\tEROM : VALUE = %x RANGE = %x TYPE = %s", BAR_INIT_P_BAR[6][31:0],
          BAR_INIT_P_BAR_RANGE[6], BAR_INIT_MESSAGE[BAR_INIT_P_BAR_ENABLED[6]]);
    end
  end
end
endtask

/************************************************************
Task : TSK_BUILD_PCIE_MAP
Inputs :
Outputs :
Description : Looks at range values read from config space and
              builds corresponding mem/io map
*************************************************************/

task TSK_BUILD_PCIE_MAP;
  reg[2:0] ii;
begin
  $display("[%t] PCI EXPRESS BAR MEMORY/IO MAPPING PROCESS BEGUN...",$realtime);

  // handle bars 0-6 (including erom)
  for(ii = 0; ii <= 6; ii = ii + 1) begin
    if(BAR_INIT_P_BAR_RANGE[ii] != 32'h0000_0000) begin
      if((ii != 6) && (BAR_INIT_P_BAR_RANGE[ii] & 32'h0000_0001)) begin // if not erom and io bit set
        // bar is io mapped
        NUMBER_OF_IO_BARS = NUMBER_OF_IO_BARS + 1;
      //if(pio_check_design && (~BAR_ENABLED[ii])) begin
        if(pio_check_design && (NUMBER_OF_IO_BARS > 6)) begin
          $display("[%t] Testbench will disable BAR %x",$realtime, ii);
              BAR_INIT_P_BAR_ENABLED[ii] = 2'h0; // disable BAR
        end
        else begin
          BAR_INIT_P_BAR_ENABLED[ii] = 2'h1;
          $display("[%t] Testbench is enabling IO BAR %x",$realtime, ii);
        end //BAR_INIT_P_BAR_ENABLED[ii] = 2'h1;

        if(!OUT_OF_IO) begin
          // We need to calculate where the next BAR should start based on the BAR's range
          BAR_INIT_TEMP = BAR_INIT_P_IO_START & {1'b1,(BAR_INIT_P_BAR_RANGE[ii] & 32'hffff_fff0)};

          if(BAR_INIT_TEMP < BAR_INIT_P_IO_START) begin
            // Current BAR_INIT_P_IO_START is NOT correct start for new base
            BAR_INIT_P_BAR[ii] = BAR_INIT_TEMP + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
            BAR_INIT_P_IO_START = BAR_INIT_P_BAR[ii] + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
          end
          else begin
            // Initial BAR case and Current BAR_INIT_P_IO_START is correct start for new base
            BAR_INIT_P_BAR[ii] = BAR_INIT_P_IO_START;
            BAR_INIT_P_IO_START = BAR_INIT_P_IO_START + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
          end
          OUT_OF_IO = BAR_INIT_P_BAR[ii][32];
          if(OUT_OF_IO) begin
            $display("\tOut of PCI EXPRESS IO SPACE due to BAR %x", ii);
          end
        end
        else begin
          $display("\tOut of PCI EXPRESS IO SPACE due to BAR %x", ii);
        end
     end // bar is io mapped
     else begin
      // bar is mem mapped
      if((ii != 5) && (BAR_INIT_P_BAR_RANGE[ii] & 32'h0000_0004)) begin
        // bar is mem64 mapped - memManager is not handling out of 64bit memory
        NUMBER_OF_MEM64_BARS = NUMBER_OF_MEM64_BARS + 1;

      //if(pio_check_design && (~BAR_ENABLED[ii])) begin
        if(pio_check_design && (NUMBER_OF_MEM64_BARS > 6)) begin
          $display("[%t] Testbench will disable BAR %x",$realtime, ii);
          BAR_INIT_P_BAR_ENABLED[ii] = 2'h0; // disable BAR
        end
        else begin
          BAR_INIT_P_BAR_ENABLED[ii] = 2'h3; // bar is mem64 mapped
          $display("[%t] Testbench is enabling MEM64 BAR %x",$realtime, ii);
        end
        if((BAR_INIT_P_BAR_RANGE[ii] & 32'hFFFF_FFF0) == 32'h0000_0000) begin
          // Mem64 space has range larger than 2 Gigabytes
          // calculate where the next BAR should start based on the BAR's range
          BAR_INIT_TEMP = BAR_INIT_P_MEM64_HI_START & BAR_INIT_P_BAR_RANGE[ii+1];

          if(BAR_INIT_TEMP < BAR_INIT_P_MEM64_HI_START) begin
            // Current MEM32_START is NOT correct start for new base
            BAR_INIT_P_BAR[ii+1] =      BAR_INIT_TEMP + FNC_CONVERT_RANGE_TO_SIZE_HI32(ii+1);
            BAR_INIT_P_BAR[ii] =        32'h0000_0000;
            BAR_INIT_P_MEM64_HI_START = BAR_INIT_P_BAR[ii+1] + FNC_CONVERT_RANGE_TO_SIZE_HI32(ii+1);
            BAR_INIT_P_MEM64_LO_START = 32'h0000_0000;
          end
          else begin
            // Initial BAR case and Current MEM32_START is correct start for new base
            BAR_INIT_P_BAR[ii] =        32'h0000_0000;
            BAR_INIT_P_BAR[ii+1] =      BAR_INIT_P_MEM64_HI_START;
            BAR_INIT_P_MEM64_HI_START = BAR_INIT_P_MEM64_HI_START + FNC_CONVERT_RANGE_TO_SIZE_HI32(ii+1);
          end
       end
       else begin
        // Mem64 space has range less than/equal 2 Gigabytes
        // calculate where the next BAR should start based on the BAR's range
        BAR_INIT_TEMP = BAR_INIT_P_MEM64_LO_START & (BAR_INIT_P_BAR_RANGE[ii] & 32'hffff_fff0);

        if(BAR_INIT_TEMP < BAR_INIT_P_MEM64_LO_START) begin
          // Current MEM32_START is NOT correct start for new base
          BAR_INIT_P_BAR[ii] =        BAR_INIT_TEMP + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
          BAR_INIT_P_BAR[ii+1] =      BAR_INIT_P_MEM64_HI_START;
          BAR_INIT_P_MEM64_LO_START = BAR_INIT_P_BAR[ii] + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
        end
        else begin
          // Initial BAR case and Current MEM32_START is correct start for new base
          BAR_INIT_P_BAR[ii] =        BAR_INIT_P_MEM64_LO_START;
          BAR_INIT_P_BAR[ii+1] =      BAR_INIT_P_MEM64_HI_START;
          BAR_INIT_P_MEM64_LO_START = BAR_INIT_P_MEM64_LO_START + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
        end
      end
      // skip over the next bar since it is being used by the 64bit bar
      ii = ii + 1;
    end
    else begin
      if( (ii != 6) || ((ii == 6) && (BAR_INIT_P_BAR_RANGE[ii] & 32'h0000_0001)) ) begin
        // handling general mem32 case and erom case
        // bar is mem32 mapped
        if(ii != 6) begin
           NUMBER_OF_MEM32_BARS = NUMBER_OF_MEM32_BARS + 1; // not counting erom space

          //if(pio_check_design && (~BAR_ENABLED[ii])) begin
            if(pio_check_design && (NUMBER_OF_MEM32_BARS > 6)) begin
                $display("[%t] Testbench will disable BAR %x",$realtime, ii);
                BAR_INIT_P_BAR_ENABLED[ii] = 2'h0; // disable BAR
            end
            else begin
                BAR_INIT_P_BAR_ENABLED[ii] = 2'h2; // bar is mem32 mapped
                $display("[%t] Testbench is enabling MEM32 BAR %x",$realtime, ii);
            end
          end
        else BAR_INIT_P_BAR_ENABLED[ii] = 2'h2; // erom bar is mem32 mapped
          if(!OUT_OF_LO_MEM) begin
            // We need to calculate where the next BAR should start based on the BAR's range
            BAR_INIT_TEMP = BAR_INIT_P_MEM32_START & {1'b1,(BAR_INIT_P_BAR_RANGE[ii] & 32'hffff_fff0)};

            if(BAR_INIT_TEMP < BAR_INIT_P_MEM32_START) begin
                // Current MEM32_START is NOT correct start for new base
                BAR_INIT_P_BAR[ii] =     BAR_INIT_TEMP + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
                BAR_INIT_P_MEM32_START = BAR_INIT_P_BAR[ii] + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
              end
              else begin
                // Initial BAR case and Current MEM32_START is correct start for new base
                BAR_INIT_P_BAR[ii] =     BAR_INIT_P_MEM32_START;
                BAR_INIT_P_MEM32_START = BAR_INIT_P_MEM32_START + FNC_CONVERT_RANGE_TO_SIZE_32(ii);
              end
              if(ii == 6) begin
                // make sure to set enable bit if we are mapping the erom space
                BAR_INIT_P_BAR[ii] = BAR_INIT_P_BAR[ii] | 33'h1;
              end
              OUT_OF_LO_MEM = BAR_INIT_P_BAR[ii][32];
              if(OUT_OF_LO_MEM) begin
                $display("\tOut of PCI EXPRESS MEMORY 32 SPACE due to BAR %x", ii);
              end
            end
            else begin
              $display("\tOut of PCI EXPRESS MEMORY 32 SPACE due to BAR %x", ii);
            end
          end
        end
      end
    end
  end
  if( (OUT_OF_IO) | (OUT_OF_LO_MEM) | (OUT_OF_HI_MEM)) begin
    TSK_DISPLAY_PCIE_MAP;
    $display("ERROR: Ending simulation: Memory Manager is out of memory/IO to allocate to PCI Express device");
    $finish;
  end
end

endtask // TSK_BUILD_PCIE_MAP

/************************************************************
  Task : TSK_BAR_SCAN
  Inputs : None
  Outputs : None
  Description : Scans PCI core's configuration registers.
*************************************************************/

task TSK_BAR_SCAN;
begin
  //--------------------------------------------------------------------------
  // Write PCI_MASK to bar's space via PCIe fabric interface to find range
  //--------------------------------------------------------------------------
  P_ADDRESS_MASK          = 32'hffff_ffff;
  DEFAULT_TAG         = 0;
  DEFAULT_TC          = 0;

  $display("[%t] : Inspecting Core Configuration Space...", $realtime);

  // Determine Range for BAR0
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h10, P_ADDRESS_MASK, 4'hF);
    DEFAULT_TAG = DEFAULT_TAG + 1;
    TSK_TX_CLK_EAT(100);

  // Read BAR0 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h10, 4'hF);
    DEFAULT_TAG = DEFAULT_TAG + 1;
    TSK_WAIT_FOR_READ_DATA;
    BAR_INIT_P_BAR_RANGE[0] = P_READ_DATA;

  // Determine Range for BAR1
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h14, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read BAR1 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h14, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[1] = P_READ_DATA;

  // Determine Range for BAR2
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h18, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read BAR2 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h18, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[2] = P_READ_DATA;

  // Determine Range for BAR3
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h1C, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read BAR3 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h1C, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[3] = P_READ_DATA;

  // Determine Range for BAR4
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h20, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read BAR4 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h20, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[4] = P_READ_DATA;

  // Determine Range for BAR5
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h24, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read BAR5 Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h24, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[5] = P_READ_DATA;

  // Determine Range for Expansion ROM BAR
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h30, P_ADDRESS_MASK, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Read Expansion ROM BAR Range
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h30, 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  BAR_INIT_P_BAR_RANGE[6] = P_READ_DATA;

 end
endtask // TSK_BAR_SCAN
//
//
/************************************************************
Task : TSK_BAR_PROGRAM
Inputs : None
Outputs : None
Description : Program's PCI core's configuration registers.
*************************************************************/

task TSK_BAR_PROGRAM;
begin
  //--------------------------------------------------------------------------
  // Write core configuration space via PCIe fabric interface
  //--------------------------------------------------------------------------

  DEFAULT_TAG     = 0;

  $display("[%t] : Setting Core Configuration Space...", $realtime);

  // Program BAR0
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h10, BAR_INIT_P_BAR[0][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program BAR1
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h14, BAR_INIT_P_BAR[1][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program BAR2
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h18, BAR_INIT_P_BAR[2][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program BAR3
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h1C, BAR_INIT_P_BAR[3][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program BAR4
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h20, BAR_INIT_P_BAR[4][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program BAR5
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h24, BAR_INIT_P_BAR[5][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program Expansion ROM BAR
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h30, BAR_INIT_P_BAR[6][31:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program PCI Command Register
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, 12'h04, 32'h00000007, 4'h1);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(100);

  // Program PCIe Device Control Register
  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, DEV_CTRL_REG_ADDR, 32'h0000005f, 4'h1);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(1000);

end
endtask // TSK_BAR_PROGRAM

task TSK_MSIX_EN;
  reg [31:0] msix_vec_offset;
  reg [2:0] msix_vec_bar;

begin
  $display("[%t] :MSIX enable task.", $realtime);
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, MSIX_CTRL_REG_ADDR[11:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;

  TSK_TX_TYPE0_CONFIGURATION_WRITE(DEFAULT_TAG, MSIX_CTRL_REG_ADDR[11:0], (32'h80000000 | P_READ_DATA), 4'hC);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_TX_CLK_EAT(1000);

  // Get the offset of MSIX vector table
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, MSIX_VEC_TABLE_A[11:0], 4'hF);
  DEFAULT_TAG = DEFAULT_TAG + 1;
  TSK_WAIT_FOR_READ_DATA;
  msix_vec_offset = {P_READ_DATA[31:3], 3'b0};
  msix_vec_bar = P_READ_DATA[2:0];
  $display("[%t] :   MSIX Vector table offset is %x on BAR %0d", $realtime, msix_vec_offset, msix_vec_bar);

//MSIX_VEC_OFFSET[0] = msix_vec_offset;
  MSIX_VEC_OFFSET[pfTestIteration] = 32'h0003_0000;
  MSIX_VEC_BAR[pfTestIteration] = msix_vec_bar;
end
endtask

/************************************************************
Task : TSK_PROGRAM_MSIX_VEC_TABLE
Inputs : function number
Outputs : None
Description : Program the MSIX vector table
*************************************************************/
task TSK_PROGRAM_MSIX_VEC_TABLE;
  input [7:0] fnc_i;
  integer    i;
begin
  EP_BUS_DEV_FNS = {8'b0000_0001, fnc_i};

  for (i=0; i<7; i=i+1) begin
    TSK_REG_WRITE(xdma_bar, MSIX_VEC_OFFSET[fnc_i]+16*i+0*4, 32'hADD00000 + i*4, 4'hF);
    TSK_REG_WRITE(xdma_bar, MSIX_VEC_OFFSET[fnc_i]+16*i+1*4, 32'h00000000 + i,   4'hF);
    TSK_REG_WRITE(xdma_bar, MSIX_VEC_OFFSET[fnc_i]+16*i+2*4, 32'hDEAD0000 + i,   4'hF);
    TSK_REG_WRITE(xdma_bar, MSIX_VEC_OFFSET[fnc_i]+16*i+3*4, 32'h00000000,       4'hF);
  end
end
endtask // TSK_PROGRAM_MSIX_VEC_TABLE

/************************************************************
Task : TSK_BAR_INIT
Inputs : None
Outputs : None
Description : Initialize PCI core based on core's configuration.
*************************************************************/

task TSK_BAR_INIT;
begin
  TSK_BAR_SCAN;
  TSK_BUILD_PCIE_MAP;
  TSK_DISPLAY_PCIE_MAP;
  TSK_BAR_PROGRAM;
  TSK_MSIX_EN;
end
endtask // TSK_BAR_INIT

/************************************************************
Function : FNC_CONVERT_RANGE_TO_SIZE_32
Inputs : BAR index for 32 bit BAR
Outputs : 32 bit BAR size
Description : Called from tx app. Note that the smallest range
          supported by this function is 16 bytes.
*************************************************************/

function [31:0] FNC_CONVERT_RANGE_TO_SIZE_32;
  input [31:0] bar_index;
  reg   [32:0] return_value;
begin
  case (BAR_INIT_P_BAR_RANGE[bar_index] & 32'hFFFF_FFF0) // AND off control bits
    32'hFFFF_FFF0 : return_value = 33'h0000_0010;
    32'hFFFF_FFE0 : return_value = 33'h0000_0020;
    32'hFFFF_FFC0 : return_value = 33'h0000_0040;
    32'hFFFF_FF80 : return_value = 33'h0000_0080;
    32'hFFFF_FF00 : return_value = 33'h0000_0100;
    32'hFFFF_FE00 : return_value = 33'h0000_0200;
    32'hFFFF_FC00 : return_value = 33'h0000_0400;
    32'hFFFF_F800 : return_value = 33'h0000_0800;
    32'hFFFF_F000 : return_value = 33'h0000_1000;
    32'hFFFF_E000 : return_value = 33'h0000_2000;
    32'hFFFF_C000 : return_value = 33'h0000_4000;
    32'hFFFF_8000 : return_value = 33'h0000_8000;
    32'hFFFF_0000 : return_value = 33'h0001_0000;
    32'hFFFE_0000 : return_value = 33'h0002_0000;
    32'hFFFC_0000 : return_value = 33'h0004_0000;
    32'hFFF8_0000 : return_value = 33'h0008_0000;
    32'hFFF0_0000 : return_value = 33'h0010_0000;
    32'hFFE0_0000 : return_value = 33'h0020_0000;
    32'hFFC0_0000 : return_value = 33'h0040_0000;
    32'hFF80_0000 : return_value = 33'h0080_0000;
    32'hFF00_0000 : return_value = 33'h0100_0000;
    32'hFE00_0000 : return_value = 33'h0200_0000;
    32'hFC00_0000 : return_value = 33'h0400_0000;
    32'hF800_0000 : return_value = 33'h0800_0000;
    32'hF000_0000 : return_value = 33'h1000_0000;
    32'hE000_0000 : return_value = 33'h2000_0000;
    32'hC000_0000 : return_value = 33'h4000_0000;
    32'h8000_0000 : return_value = 33'h8000_0000;
    default :      return_value = 33'h0000_0000;
  endcase
  FNC_CONVERT_RANGE_TO_SIZE_32 = return_value;
end
endfunction // FNC_CONVERT_RANGE_TO_SIZE_32

/************************************************************
Function : FNC_CONVERT_RANGE_TO_SIZE_HI32
Inputs : BAR index for upper 32 bit BAR of 64 bit address
Outputs : upper 32 bit BAR size
Description : Called from tx app.
*************************************************************/

function [31:0] FNC_CONVERT_RANGE_TO_SIZE_HI32;
  input [31:0] bar_index;
  reg   [32:0] return_value;
begin
  case (BAR_INIT_P_BAR_RANGE[bar_index])
    32'hFFFF_FFFF : return_value = 33'h00000_0001;
    32'hFFFF_FFFE : return_value = 33'h00000_0002;
    32'hFFFF_FFFC : return_value = 33'h00000_0004;
    32'hFFFF_FFF8 : return_value = 33'h00000_0008;
    32'hFFFF_FFF0 : return_value = 33'h00000_0010;
    32'hFFFF_FFE0 : return_value = 33'h00000_0020;
    32'hFFFF_FFC0 : return_value = 33'h00000_0040;
    32'hFFFF_FF80 : return_value = 33'h00000_0080;
    32'hFFFF_FF00 : return_value = 33'h00000_0100;
    32'hFFFF_FE00 : return_value = 33'h00000_0200;
    32'hFFFF_FC00 : return_value = 33'h00000_0400;
    32'hFFFF_F800 : return_value = 33'h00000_0800;
    32'hFFFF_F000 : return_value = 33'h00000_1000;
    32'hFFFF_E000 : return_value = 33'h00000_2000;
    32'hFFFF_C000 : return_value = 33'h00000_4000;
    32'hFFFF_8000 : return_value = 33'h00000_8000;
    32'hFFFF_0000 : return_value = 33'h00001_0000;
    32'hFFFE_0000 : return_value = 33'h00002_0000;
    32'hFFFC_0000 : return_value = 33'h00004_0000;
    32'hFFF8_0000 : return_value = 33'h00008_0000;
    32'hFFF0_0000 : return_value = 33'h00010_0000;
    32'hFFE0_0000 : return_value = 33'h00020_0000;
    32'hFFC0_0000 : return_value = 33'h00040_0000;
    32'hFF80_0000 : return_value = 33'h00080_0000;
    32'hFF00_0000 : return_value = 33'h00100_0000;
    32'hFE00_0000 : return_value = 33'h00200_0000;
    32'hFC00_0000 : return_value = 33'h00400_0000;
    32'hF800_0000 : return_value = 33'h00800_0000;
    32'hF000_0000 : return_value = 33'h01000_0000;
    32'hE000_0000 : return_value = 33'h02000_0000;
    32'hC000_0000 : return_value = 33'h04000_0000;
    32'h8000_0000 : return_value = 33'h08000_0000;
    default :       return_value = 33'h00000_0000;
  endcase
  FNC_CONVERT_RANGE_TO_SIZE_HI32 = return_value;
end
endfunction // FNC_CONVERT_RANGE_TO_SIZE_HI32

/************************************************************
Task : TSK_REG_WRITE
Input : BAR Number
Input : Register Address
Input : data value
Input : byte_en
Outputs : None
Description : Register Writes to any BAR
*************************************************************/

task TSK_REG_WRITE;
  input integer bar_num;
  input [31:0] addr;
  input [31:0] data;
  input [3:0] byte_en;
begin
  // Store the 32 bit data into the global variable DATA_STORE
  DATA_STORE[0] = data[7:0];
  DATA_STORE[1] = data[15:8];
  DATA_STORE[2] = data[23:16];
  DATA_STORE[3] = data[31:24];

  $display("[%t] : Sending Data write task at address %h with data %h" ,$realtime, addr, data);

  // Check if it mus perform a 32 or 64 write
  if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[bar_num] == 2'b10) 
  begin
    board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG,   // Tag
                                              board.RP.tx_usrapp.DEFAULT_TC,    // Traffic Class
                                              11'd1,                            // Length (in DW)
                                              board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num][31:0]+addr[20:0],// Address
                                              4'h0,                             // Last DW Byte Enable
                                              byte_en,                          // First DW Byte Enable
                                              1'b0);               // Poisoned Data: Payload is invalid if set
  end 
  else if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[bar_num] == 2'b11) 
  begin
    board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG,
    board.RP.tx_usrapp.DEFAULT_TC, 11'd1,{board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num+1][31:0],
    board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num][31:0]+addr[20:0]}, 4'h0, byte_en, 1'b0);
  end
  board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
  board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

  $display("[%t] : Done register write!!" ,$realtime);
end
endtask

/************************************************************
Task : TSK_REG_READ
Input : BAR number
Input : Register address
Outputs : None
Description : Register Reads to any bar
*************************************************************/

task TSK_REG_READ;
  input integer bar_num;
  input [15:0] read_addr;
begin
  board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
  fork
    if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[bar_num] == 2'b10) begin
      board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG,
      board.RP.tx_usrapp.DEFAULT_TC, 11'd1,
      board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num][31:0]+read_addr[15:0], 4'h0, 4'hF);
    end else if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[bar_num] == 2'b11) begin
      board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG,
      board.RP.tx_usrapp.DEFAULT_TC, 11'd1,{board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num+1][31:0],
      board.RP.tx_usrapp.BAR_INIT_P_BAR[bar_num][31:0]+read_addr[15:0]}, 4'h0, 4'hF);
    end
    board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
  join
  board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
  board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
  $display ("[%t] : Data read %h from Address %h",$realtime , board.RP.tx_usrapp.P_READ_DATA, read_addr);
end
endtask


/************************************************************
Task : TSK_INIT_QDMA_MM_DATA_H2C
Inputs : None
Outputs : None
Description : Initialize Descriptor and Data
*************************************************************/

task TSK_INIT_QDMA_MM_DATA_H2C;
  //input logic [63:0] src_addr;
  //input logic [63:0] dst_addr;
  //input logic [15:0] byte_cnt;
  integer i, j, k;
  int fp, temp;
begin
  $display(" **** TASK QDMA MM H2C DSC POLYBENCH at address 0x%h ***\n", H2C_ADDR);

  $display(" **** Initialize Descriptor data ***\n");  
  
  for (i = 0; i<16384; i++)
    DATA_STORE[i] = 8'h00;

  for (k=0;k<12;k=k+1) begin
    DATA_STORE[H2C_ADDR+(k*32)+0] = 8'h00; //-- Src_add [31:0] x300
    DATA_STORE[H2C_ADDR+(k*32)+1] = 8'h03;
    DATA_STORE[H2C_ADDR+(k*32)+2] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+3] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+4] = 8'h00; //-- Src add [63:32]
    DATA_STORE[H2C_ADDR+(k*32)+5] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+6] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+7] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+8] = DMA_BYTE_CNT[7:0]; // [71:64] len [7:0] 28bits
    DATA_STORE[H2C_ADDR+(k*32)+9] = DMA_BYTE_CNT[15:8];// [79:72] len [15:8]
    DATA_STORE[H2C_ADDR+(k*32)+10] = 8'h00;            // [87:80] len [23:16]
    DATA_STORE[H2C_ADDR+(k*32)+11] = 8'h40;            // [96:88] {Rsvd, SDI, EOP, SOP, len[27:24]}. last dsc send S
    DATA_STORE[H2C_ADDR+(k*32)+12] = 8'h00; // [104:97] Reserved 32bits
    DATA_STORE[H2C_ADDR+(k*32)+13] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+14] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+15] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+16] = 8'h00; // Dst add 64bits [31:0] 0x0000
    DATA_STORE[H2C_ADDR+(k*32)+17] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+18] = 8'h01;
    DATA_STORE[H2C_ADDR+(k*32)+19] = 8'h40*k;
    DATA_STORE[H2C_ADDR+(k*32)+20] = k/4; // Dst add 64 bits [63:32]
    DATA_STORE[H2C_ADDR+(k*32)+21] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+22] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+23] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+24] = 8'h00; // 64 bits Reserved [31:0]
    DATA_STORE[H2C_ADDR+(k*32)+25] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+26] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+27] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+28] = 8'h00; // Reserved [63:32]
    DATA_STORE[H2C_ADDR+(k*32)+29] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+30] = 8'h00;
    DATA_STORE[H2C_ADDR+(k*32)+31] = 8'h00;
  end // for (k=0;k<8;k=k+1)

  //Initialize Status write back location to 0's
  DATA_STORE[H2C_ADDR + (32*15) +0] = 8'h00;
  DATA_STORE[H2C_ADDR + (32*15) +1] = 8'h00;
  DATA_STORE[H2C_ADDR + (32*15) +2] = 8'h00;
  DATA_STORE[H2C_ADDR + (32*15) +3] = 8'h00;

//for (k = 0; k < 32; k = k + 1)  begin
//  $display(" **** Descriptor data *** data = %h, addr= %d\n", DATA_STORE[H2C_ADDR+k], H2C_ADDR+k);
//  #(Tcq);
//end
 for (k = 0; k < DMA_BYTE_CNT; k = k + 1)  begin
   #(Tcq) DATA_STORE[768+k] = k;  // 0x1200
 end
//$display("MEMORY CONTENT\n");
//for (int i=0; i<4096; i++)
//    $display("%x:\t%x", i, DATA_STORE[i]);
end
endtask


/************************************************************
Task : TSK_INIT_QDMA_MM_DATA_C2H
Inputs : None
Outputs : None
Description : Initialize Descriptor
*************************************************************/

task TSK_INIT_QDMA_MM_DATA_C2H;
  integer k;
begin

  $display(" **** TASK QDMA MM C2H DSC at address 0x0800 ***\n");

  $display(" **** Initialize Descriptor data ***\n");
  for (k=0;k<8;k=k+1) begin
    DATA_STORE[C2H_ADDR+(k*32)+0] = 8'h00; //-- Src_add [31:0]
    DATA_STORE[C2H_ADDR+(k*32)+1] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+2] = 8'h01;
    DATA_STORE[C2H_ADDR+(k*32)+3] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+4] = 8'h00; //-- Src add [63:32]
    DATA_STORE[C2H_ADDR+(k*32)+5] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+6] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+7] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+8] = DMA_BYTE_CNT[7:0]; // [71:64] len [7:0] 28bits
    DATA_STORE[C2H_ADDR+(k*32)+9] = DMA_BYTE_CNT[15:8];// [79:72] len [15:8]
    DATA_STORE[C2H_ADDR+(k*32)+10] = 8'h00;            // [87:80] len [23:16]
    DATA_STORE[C2H_ADDR+(k*32)+11] = 8'h40;            // [96:88] {Rsvd, SDI, EOP, SOP, len[27:24]}. last dsc send SDI to make DMA send comnpletion
    DATA_STORE[C2H_ADDR+(k*32)+12] = 8'h00; // [104:97] Reserved 32bits
    DATA_STORE[C2H_ADDR+(k*32)+13] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+14] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+15] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+16] = 8'h00;//8'h00; // Dst add 64bits [31:0] 0x1600
    DATA_STORE[C2H_ADDR+(k*32)+17] = 8'h00;//8'h0A;
    DATA_STORE[C2H_ADDR+(k*32)+18] = 8'h01;//8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+19] = 8'h00;//8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+20] = 8'h00; // Dst add 64 bits [63:32]
    DATA_STORE[C2H_ADDR+(k*32)+21] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+22] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+23] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+24] = 8'h00; // 64 bits Reserved [31:0]
    DATA_STORE[C2H_ADDR+(k*32)+25] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+26] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+27] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+28] = 8'h00; // Reserved [63:32]
    DATA_STORE[C2H_ADDR+(k*32)+29] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+30] = 8'h00;
    DATA_STORE[C2H_ADDR+(k*32)+31] = 8'h00;
  end

  //Initialize Status write back location to 0's
  DATA_STORE[C2H_ADDR + (32*15) +0] = 8'h00;
  DATA_STORE[C2H_ADDR + (32*15) +1] = 8'h00;
  DATA_STORE[C2H_ADDR + (32*15) +2] = 8'h00;
  DATA_STORE[C2H_ADDR + (32*15) +3] = 8'h00;

//for (k = 0; k < 32; k = k + 1)  begin
//  $display(" **** Descriptor data *** data = %h, addr= %d\n", DATA_STORE[C2H_ADDR+k], C2H_ADDR+k);
//  #(Tcq);
//end
  //for (k = 0; k < DMA_BYTE_CNT; k = k + 1)  begin
  //  #(Tcq) DATA_STORE[2560+k] = 8'h00;
  //end
  for (k = 0; k < DMA_BYTE_CNT; k = k + 1)  begin
  #(Tcq) DATA_STORE[4096+k] = 8'h00;
  end
end
endtask

/************************************************************
Task : COMPARE_DATA_H2C
Inputs : Number of Payload Bytes
Outputs : None
Description : Compare Data received at out of DMA with data sent from RP - user TB
*************************************************************/

task COMPARE_DATA_H2C;
  input [31:0]payload_bytes ;
  input integer address;

  reg [511:0] READ_DATA [(DMA_BYTE_CNT/8):0];
  reg [511:0] DATA_STORE_512 [(DMA_BYTE_CNT/8):0];

  integer matched_data_counter;
  integer i, j, k;
  integer data_beat_count;
begin
  matched_data_counter = 0;

  //Calculate number of beats for payload to DMA
  case (board.C_DATA_WIDTH)
    64:		data_beat_count = ((payload_bytes % 32'h8) == 0) ? (payload_bytes/32'h8) : ((payload_bytes/32'h8)+32'h1);
    128:	data_beat_count = ((payload_bytes % 32'h10) == 0) ? (payload_bytes/32'h10) : ((payload_bytes/32'h10)+32'h1);
    256:	data_beat_count = ((payload_bytes % 32'h20) == 0) ? (payload_bytes/32'h20) : ((payload_bytes/32'h20)+32'h1);
    512:	data_beat_count = ((payload_bytes % 32'h40) == 0) ? (payload_bytes/32'h40) : ((payload_bytes/32'h40)+32'h1);
  endcase

  $display ("Enters into compare read data task at %gns\n", $realtime);
  $display ("payload bytes=%h, data_beat_count =%d\n", payload_bytes, data_beat_count);

  for (i=0; i<data_beat_count; i=i+1)   begin
    DATA_STORE_512[i] = 512'b0;
  end

  //Sampling data payload on XDMA
  @(posedge board.EP.i_hbm_interface.qdma_0_M_AXI_WVALID) ; //valid data comes at wvalid
  for(i=0; i<data_beat_count; i=i+1) begin
    @(negedge board.EP.i_hbm_interface.qdma_0_axi_aclk); //samples data wvalid and negedge of user_clk

    if( board.EP.i_hbm_interface.qdma_0_M_AXI_WREADY && board.EP.i_hbm_interface.qdma_0_M_AXI_WVALID) begin			//check for wready is high before sampling data
      case (board.C_DATA_WIDTH)
        64: READ_DATA[i] = {((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[7] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[63:56] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[6] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[55:48] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[5] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[47:40] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[4] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[39:32] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[3] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[31:24] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[2] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[23:16] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[1] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[15:8] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[0] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[7:0] : 8'h00)};
        128: READ_DATA[i] = {((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[15] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[127:120] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[14] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[119:112] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[13] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[111:104] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[12] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[103:96] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[11] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[95:88] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[10] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[87:80] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[9] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[79:72] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[8] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[71:64] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[7] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[63:56] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[6] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[55:48] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[5] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[47:40] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[4] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[39:32] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[3] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[31:24] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[2] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[23:16] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[1] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[15:8] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[0] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[7:0] : 8'h00)};
        256: READ_DATA[i] = {((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[31] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[255:248] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[30] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[247:240] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[29] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[239:232] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[28] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[231:224] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[27] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[223:216] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[26] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[215:208] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[25] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[207:200] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[24] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[199:192] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[23] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[191:184] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[22] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[183:176] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[21] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[175:168] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[20] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[167:160] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[19] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[159:152] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[18] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[151:144] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[17] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[143:136] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[16] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[135:128] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[15] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[127:120] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[14] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[119:112] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[13] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[111:104] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[12] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[103:96] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[11] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[95:88] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[10] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[87:80] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[9] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[79:72] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[8] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[71:64] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[7] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[63:56] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[6] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[55:48] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[5] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[47:40] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[4] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[39:32] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[3] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[31:24] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[2] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[23:16] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[1] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[15:8] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[0] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[7:0] : 8'h00)};
        512: READ_DATA[i] = {((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[63] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[511:504] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[62] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[503:496] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[61] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[495:488] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[60] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[487:480] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[59] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[479:472] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[58] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[471:464] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[57] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[463:456] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[56] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[455:448] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[55] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[447:440] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[54] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[439:432] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[53] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[431:424] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[52] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[423:416] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[51] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[415:408] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[50] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[407:400] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[49] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[399:392] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[48] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[391:384] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[47] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[383:376] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[46] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[375:368] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[45] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[367:360] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[44] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[359:352] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[43] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[351:344] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[42] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[343:336] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[41] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[335:328] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[40] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[327:320] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[39] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[319:312] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[38] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[311:304] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[37] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[303:296] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[36] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[295:288] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[35] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[287:280] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[34] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[279:272] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[33] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[271:264] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[32] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[263:256] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[31] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[255:248] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[30] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[247:240] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[29] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[239:232] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[28] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[231:224] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[27] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[223:216] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[26] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[215:208] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[25] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[207:200] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[24] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[199:192] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[23] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[191:184] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[22] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[183:176] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[21] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[175:168] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[20] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[167:160] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[19] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[159:152] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[18] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[151:144] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[17] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[143:136] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[16] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[135:128] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[15] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[127:120] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[14] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[119:112] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[13] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[111:104] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[12] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[103:96] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[11] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[95:88] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[10] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[87:80] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[9] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[79:72] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[8] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[71:64] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[7] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[63:56] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[6] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[55:48] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[5] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[47:40] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[4] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[39:32] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[3] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[31:24] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[2] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[23:16] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[1] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[15:8] : 8'h00),
            ((board.EP.i_hbm_interface.qdma_0_M_AXI_WSTRB[0] == 1'b1) ? board.EP.i_hbm_interface.qdma_0_M_AXI_WDATA[7:0] : 8'h00)};
      endcase
      $display ("--- H2C data at QDMA = %h ---\n", READ_DATA[i]);
    end
    else begin
      i=i-1;
    end
  end

  //Sampling stored data from User TB in reg
  k = 0;
  case (board.C_DATA_WIDTH)
    64:
    begin
      for (i = 0; i < data_beat_count; i = i + 1) begin
        for (j=7; j>=0; j=j-1) begin
          DATA_STORE_512[i] = {DATA_STORE_512[i], DATA_STORE[address+k+j]};
        end
        k=k+8;
        $display ("--- Data Stored in TB for H2C Transfer = %h ---\n", DATA_STORE_512[i]);
      end
    end

    128:
    begin
      for (i = 0; i < data_beat_count; i = i + 1)   begin
        for (j=15; j>=0; j=j-1) begin
          DATA_STORE_512[i] = {DATA_STORE_512[i], DATA_STORE[address+k+j]};
        end
        k=k+16;
        $display ("-- Data Stored in TB for H2C Transfer = %h--\n", DATA_STORE_512[i]);
      end
    end

    256:
    begin
      for (i = 0; i < data_beat_count; i = i + 1)   begin
        for (j=31; j>=0; j=j-1) begin
          DATA_STORE_512[i] = {DATA_STORE_512[i], DATA_STORE[address+k+j]};
        end
        k=k+32;
        $display ("-- Data Stored in TB for H2C Transfer = %h--\n", DATA_STORE_512[i]);
      end
    end

    512:
    begin
      for (i = 0; i < data_beat_count; i = i + 1)   begin
        for (j=63; j>=0; j=j-1) begin
          DATA_STORE_512[i] = {DATA_STORE_512[i], DATA_STORE[address+k+j]};
        end
        k=k+64;
        $display ("-- Data Stored in TB for H2C Transfer = %h--\n", DATA_STORE_512[i]);
      end
    end
  endcase

  //Compare sampled data from QDMA with stored TB data
  for (i=0; i<data_beat_count; i=i+1)   begin
    if(READ_DATA[i] == DATA_STORE_512[i]) begin
      matched_data_counter = matched_data_counter + 1;
    end else
      matched_data_counter = matched_data_counter;
  end

  if(matched_data_counter == data_beat_count) begin
    $display ("*** H2C Transfer Data MATCHES ***\n");
    $display("[%t] : QDMA H2C Test Completed Successfully",$realtime);
  end else begin
    $display ("ERROR: [%t] : TEST FAILED ---***ERROR*** H2C Transfer Data MISMATCH ---\n",$realtime);
    board.RP.tx_usrapp.test_state =1;
  end

end
$display("Exiting task COMPARE_DATA_H2C");
endtask

/************************************************************
Task : COMPARE_DATA_C2H_
Inputs : Number of Payload Bytes
Outputs : None
Description : Compare Data received and stored at RP - user TB with the data sent for H2C transfer from RP - user TB
*************************************************************/

task COMPARE_DATA_C2H;
  input [31:0] payload_bytes ;
  input integer  address;

  reg [511:0] READ_DATA_C2H_512 [(DMA_BYTE_CNT/8):0];
  reg [511:0] DATA_STORE_512 [(DMA_BYTE_CNT/8):0];

  integer matched_data_counter;
  integer i, j, k,t;
  integer data_beat_count;
  integer cq_data_beat_count;
  integer cq_valid_wait_cnt;
begin

  matched_data_counter = 0; t = 0;

//for (k = 0; k < DMA_BYTE_CNT; k = k + 1)  begin
//  $display(" **** H2C data *** data = %h, addr= %d\n", DATA_STORE[address+k], address+k);
//end

  //Calculate number of beats for payload sent
  data_beat_count = ((payload_bytes % 32'h40) == 0) ? (payload_bytes/32'h40) : ((payload_bytes/32'h40)+32'h1);
  cq_data_beat_count = ((((payload_bytes-32'h30) % 32'h40) == 0) ? ((payload_bytes-32'h30)/32'h40) : (((payload_bytes-32'h30)/32'h40)+32'h1)) + 32'h1;
  $display ("payload_bytes = %h, data_beat_count = %h  cq_data_beat_count = %h\n", payload_bytes, data_beat_count, cq_data_beat_count);

  //Sampling CQ data payload on RP
  if(testname =="dma_stream0") begin
    cq_valid_wait_cnt = 3;
  end else begin
    cq_valid_wait_cnt = 1;
  end

  for (i=0; i<cq_valid_wait_cnt; i=i+1) begin
    @(posedge board.RP.m_axis_cq_tvalid); //1st tvalid - Descriptor Read Request
  end
  @(posedge board.RP.m_axis_cq_tvalid); //2nd tvalid - CQ on RP receives Data from QDMA
  for (i=0; i<cq_data_beat_count; i=i+1) begin
    // $display ("-------------------------starting i = %d--------------------------------------------------------------\n", i);
    @(negedge user_clk); //Samples data at negedge of user_clk
    if(board.RP.m_axis_cq_tready && board.RP.m_axis_cq_tvalid) begin	//Samples data when tready is high
    //$display ("--m_axis_cq_tvalid = %d, m_axis_cq_tready = %d, i = %d--\n", board.RP.m_axis_cq_tvalid, board.RP.m_axis_cq_tready, i);
      if(i == 0 || t == 1) begin					//First Data Beat
        if(i != 0 && t == 1)
        begin
          i=i-1;
        end
        t=0;
        READ_DATA_C2H_512[i][511:0] = board.RP.m_axis_cq_tdata [511:128];
      end else begin //Second and Subsequent Data Beat
      //$display ("m_axis_cq_tkeep = %h\n", board.RP.m_axis_cq_tkeep);
        case (board.RP.m_axis_cq_tkeep)
          16'h0001: begin READ_DATA_C2H_512[i-1][511:384] = {96'b0,board.RP.m_axis_cq_tdata [31:0]};  /* $display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[2*i-1], i , t);*/ end
          16'h0003: begin READ_DATA_C2H_512[i-1][511:384] = {64'b0,board.RP.m_axis_cq_tdata [63:0]};  /* $display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[2*i-1], i , t);*/ end
          16'h0007: begin READ_DATA_C2H_512[i-1][511:384] = {32'b0,board.RP.m_axis_cq_tdata [95:0]};  /* $display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[2*i-1], i , t);*/ end
          16'h000F: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0];         /* $display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[2*i-1], i , t);*/ end
          16'h001F: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {480'b0,board.RP.m_axis_cq_tdata [159:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h003F: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {448'b0,board.RP.m_axis_cq_tdata [191:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h007F: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {416'b0,board.RP.m_axis_cq_tdata [223:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h00FF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {384'b0,board.RP.m_axis_cq_tdata [255:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h01FF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {352'b0,board.RP.m_axis_cq_tdata [287:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h03FF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {320'b0,board.RP.m_axis_cq_tdata [319:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h07FF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {288'b0,board.RP.m_axis_cq_tdata [351:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h0FFF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {256'b0,board.RP.m_axis_cq_tdata [383:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h1FFF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {224'b0,board.RP.m_axis_cq_tdata [415:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h3FFF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {192'b0,board.RP.m_axis_cq_tdata [447:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'h7FFF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {160'b0,board.RP.m_axis_cq_tdata [479:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          16'hFFFF: begin READ_DATA_C2H_512[i-1][511:384] = board.RP.m_axis_cq_tdata [127:0]; READ_DATA_C2H_512[i] = {128'b0,board.RP.m_axis_cq_tdata [511:128]}; /*$display ("-- CHECKING C2H data at RP = %h-- i = %d t = %d \n", READ_DATA_C2H_512[i-1], i , t);*/ end
          default: begin READ_DATA_C2H_512[i] = 512'b0;/* $display ("-- C2H data at RP = %h--\n", READ_DATA_C2H_512[2*i]);*/ end
        endcase

      //$display ("------------------------------------------------------------------------------------------");
      //$display ("-- CHECKING m_axis_cq_tdata = %h   and i = %d--\n", board.RP.m_axis_cq_tdata [511:0] , i);
      //$display ("-- CHECKING READ_DATA_C2H_512 = %h   and i = %d--\n", READ_DATA_C2H_512[i-1][511:384] , i);
      //$display ("-- CHECKING m_axis_cq_tkeep = %h   and i = %d--\n", board.RP.m_axis_cq_tkeep[15:0] , i);
        if(board.RP.m_axis_cq_tlast)
        begin
          t=1;
        end
      end
    end
    else begin
      i=i-1;
    //$display ("-------------------------ending i = %d--------------------------------------------------------------\n", i);
    end
  end

  //Sampling stored data from User TB in 256 bit reg
  k = 0;
  for (i = 0; i < data_beat_count; i = i + 1)   begin
    $display ("-- C2H data at RP = %h--\n", READ_DATA_C2H_512[i]);
  end

  for (i = 0; i < data_beat_count; i = i + 1)   begin
    for (j=63; j>=0; j=j-1) begin
      DATA_STORE_512[i] = {DATA_STORE_512[i], DATA_STORE[address+k+j]};
    //$display ("-- DATA_STORE_512[i] = %h,-- DATA_STORE[address+k+j] = %h,  address = %h, i = %d, j = %d, k = %d\n", DATA_STORE_512[i],DATA_STORE[address+k+j], address+k+j,i,j,k);
    end
    k=k+64;
    $display ("-- Data Stored in TB = %h--\n", DATA_STORE_512[i]);
  end

  //Compare sampled data from CQ with stored TB data

  for (i=0; i<data_beat_count; i=i+1)   begin
    if(READ_DATA_C2H_512[i] == DATA_STORE_512[i]) begin
      matched_data_counter = matched_data_counter + 1;
    end else
      matched_data_counter = matched_data_counter;
  end

  if(matched_data_counter == data_beat_count) begin
    $display ("*** C2H Transfer Data MATCHES ***\n");
    $display("[%t] : QDMA C2H Test Completed Successfully",$realtime);
  end else begin
    $display ("ERROR: [%t] : TEST FAILED ---***ERROR*** C2H Transfer Data MISMATCH ---\n",$realtime);
    board.RP.tx_usrapp.test_state =1;
  end
end
endtask

/************************************************************
Task : COMPARE_TRANS_STATUS
Inputs : Number of Payload Bytes
Outputs : None
Description : Compare Data received and stored at RP - user TB with the data sent for H2C transfer from RP - user TB
*************************************************************/

task COMPARE_TRANS_STATUS;
  input [31:0] status_addr ;
  input [16:0] exp_cidx;
  integer 	i, j, k;
  integer 	status_found;
  integer 	loop_count;
  reg [15:0] 	cidx;
begin
  status_found = 0;
  loop_count = 0;
  cidx = 0;
  while((exp_cidx != cidx) && (loop_count < 10))begin
    $display("Entered while loop in COMPARE_TRANS_STATUS");
    $display("Values: cidx=%d, exp_cidx=%d, loop_count=%d, board.RP.m_axis_cq_tvalid=%d", cidx, exp_cidx, loop_count, board.RP.m_axis_cq_tvalid);
    loop_count = loop_count +1;
    wait (board.RP.m_axis_cq_tvalid == 1'b1) ; //1st tvalid after data
    $display("Overcome wait statement in COMPARE_TRANS_STATUS");
    @(negedge user_clk); //Samples data at negedge of user_clk
    $display("Overcome negedge of user_clk in COMPARE_TRANS_STATUS");
    if(board.RP.m_axis_cq_tready) begin
      if(board.RP.m_axis_cq_tdata [31:0] == status_addr[31:0]) begin  // Address match
        cidx = cidx + board.RP.m_axis_cq_tdata [159:144];
      end
    end
  end
  $display("Exited while loop in COMPARE_TRANS_STATUS");
  if(exp_cidx == cidx )
    $display ("[%t] : Write Back Status matches expected value : %h\n", $realtime, cidx);
  else begin
    $display ("ERROR: [%t] : TEST FAILED ---***ERROR*** Write Back Status NO matches expected value : %h, got %h \n",$realtime, exp_cidx, cidx);
    board.RP.tx_usrapp.test_state =1;
  end
end
endtask

/************************************************************
Task : TSK_FIND_USR_BAR
Description : Find User BAR
*************************************************************/

task TSK_FIND_USR_BAR;
begin
  board.RP.tx_usrapp.TSK_REG_READ(xdma_bar, 16'h10C);
  case (P_READ_DATA[5:0])
    6'b000001 : user_bar =0;
    6'b000010 : user_bar =1;
    6'b000100 : user_bar =2;
    6'b001000 : user_bar =3;
    6'b010000 : user_bar =4;
    6'b100000 : user_bar =5;
    default : user_bar = 0;
  endcase // case (P_READ_DATA[5:0])
  $display (" ***** User BAR = %d *****\n", user_bar);
end
endtask // TSK_FIND_USR_BAR

// Include all the initialization tasks from a separate file
`include "initialization.svh"

endmodule // pci_exp_usrapp_tx
