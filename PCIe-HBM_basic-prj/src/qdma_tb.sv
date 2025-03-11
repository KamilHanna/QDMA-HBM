
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
// File       : board.v
// Version    : 5.0
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//
// Project    : Ultrascale FPGA Gen3 Integrated Block for PCI Express
// File       : board.v
// Version    : 5.0
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//
// Description: Top level testbench
//
//------------------------------------------------------------------------------

`timescale 1ps/1ps

`include "board_common.vh"
`define SIMULATION
`define LINKWIDTH 16
`define LINKSPEED 4

module board;
  
  parameter          REF_CLK_FREQ       = 0 ;      // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz
  localparam         REF_CLK_HALF_CYCLE = (REF_CLK_FREQ == 0) ? 5000 :
                                          (REF_CLK_FREQ == 1) ? 4000 :
                                          (REF_CLK_FREQ == 2) ? 2000 : 0;
  localparam   [2:0] PF0_DEV_CAP_MAX_PAYLOAD_SIZE = 3'b011;
  localparam   [4:0] LINK_WIDTH = 5'd`LINKWIDTH;
  localparam   [2:0] LINK_SPEED = 3'h`LINKSPEED;

//  defparam board.EP.qdma_0_i.inst.pcie4c_ip_i.inst.PL_SIM_FAST_LINK_TRAINING=2'h3;
  localparam EXT_PIPE_SIM = "FALSE";
  parameter C_DATA_WIDTH = 512;

  integer            i;

  // System-level clock and reset
  logic                sys_rst_n;

  logic               ep_sys_clk;
  logic               rp_sys_clk;
  logic               ep_sys_clk_p;
  logic               ep_sys_clk_n;
  logic               rp_sys_clk_p;
  logic               rp_sys_clk_n;

  //
  // PCI-Express Serial Interconnect
  //
  logic  [(LINK_WIDTH-1):0]  ep_pci_exp_txn;
  logic  [(LINK_WIDTH-1):0]  ep_pci_exp_txp;
  logic  [(LINK_WIDTH-1):0]  rp_pci_exp_txn;
  logic  [(LINK_WIDTH-1):0]  rp_pci_exp_txp;

  // Control signals
  logic phy_ready;
  logic user_lnk_up;



  //------------------------------------------------------------------------------//
  // Generate system clock
  //------------------------------------------------------------------------------//
  sys_clk_gen_ds # (
    .halfcycle(REF_CLK_HALF_CYCLE),
    .offset(0)
  )
  CLK_GEN_RP (
    .sys_clk_p(rp_sys_clk_p),
    .sys_clk_n(rp_sys_clk_n)
  );

  sys_clk_gen_ds # (
    .halfcycle(REF_CLK_HALF_CYCLE),
    .offset(0)
  )
  CLK_GEN_EP (
    .sys_clk_p(ep_sys_clk_p),
    .sys_clk_n(ep_sys_clk_n)
  );



  //------------------------------------------------------------------------------//
  // Generate system-level reset
  //------------------------------------------------------------------------------//
  parameter ON=3, OFF=4, UNIQUE=32, UNIQUE0=64, PRIORITY=128;

  initial begin
    `ifndef XILINX_SIMULATOR
    // Disable UNIQUE, UNIQUE0, and PRIORITY analysis during reset because signal can be at unknown value during reset
    $assertcontrol( OFF , UNIQUE | UNIQUE0 | PRIORITY);
    `endif

    $display("[%t] : System Reset Is Asserted...", $realtime);
    sys_rst_n = 1'b0;
    repeat (500) @(posedge rp_sys_clk_p);
    $display("[%t] : System Reset Is De-asserted...", $realtime);
    sys_rst_n = 1'b1;

    `ifndef XILINX_SIMULATOR
    // Re-enable UNIQUE, UNIQUE0, and PRIORITY analysis
    $assertcontrol( ON , UNIQUE | UNIQUE0 | PRIORITY);
    `endif
  end
  //------------------------------------------------------------------------------//

  //------------------------------------------------------------------------------//
  // EndPoint DUT with PIO Slave
  //------------------------------------------------------------------------------//
  //
  // PCI-Express Endpoint Instance
  //


  top
    EP (
    // Clock and reset
    .aresetn (sys_rst_n),
    .qdma_clk_n (ep_sys_clk_n),
    .qdma_clk_p (ep_sys_clk_p),
    .hbm_clk_n (ep_sys_clk_n), // Right now, both clocks go at 100MHz
    .hbm_clk_p (ep_sys_clk_p),
    // PCIe lanes
    .pci_express_x16_rxn (rp_pci_exp_txn),
    .pci_express_x16_rxp (rp_pci_exp_txp),
    .pci_express_x16_txn (ep_pci_exp_txn),
    .pci_express_x16_txp (ep_pci_exp_txp)
  );



  //------------------------------------------------------------------------------//
  // Simulation Root Port Model
  // (Comment out this module to interface EndPoint with BFM)
  //------------------------------------------------------------------------------//
  //
  // PCI-Express Model Root Port Instance
  //

  xilinx_pcie4_uscale_rp
  #(
     .PF0_DEV_CAP_MAX_PAYLOAD_SIZE(PF0_DEV_CAP_MAX_PAYLOAD_SIZE)
     //ONLY FOR RP
  ) RP (

    // SYS Inteface
    .sys_clk_n(rp_sys_clk_n),
    .sys_clk_p(rp_sys_clk_p),
    .sys_rst_n                  ( sys_rst_n ),
    // PCI-Express Serial Interface
    .pci_exp_txn(rp_pci_exp_txn),
    .pci_exp_txp(rp_pci_exp_txp),
    .pci_exp_rxn(ep_pci_exp_txn),
    .pci_exp_rxp(ep_pci_exp_txp)

  );


  initial begin

    if ($test$plusargs ("dump_all")) begin

  `ifdef NCV // Cadence TRN dump

      $recordsetup("design=board",
                   "compress",
                   "wrapsize=100M",
                   "version=1",
                   "run=1");
      $recordvars();

  `elsif VCS //Synopsys VPD dump

      $vcdplusfile("board.vpd");
      $vcdpluson;
      $vcdplusglitchon;
      $vcdplusflush;

  `else

      // Verilog VC dump
      $dumpfile("board.vcd");
      $dumpvars(0, board);

  `endif

    end

  end

//--------------------MAIN TEST-------------------\\
initial begin
  board.RP.tx_usrapp.pfIndex     = 0;
  board.RP.tx_usrapp.pfTestIteration = 0;
  board.RP.tx_usrapp.pf_loop_index   = 0;
  board.RP.tx_usrapp.expect_status   = 0;
  board.RP.tx_usrapp.expect_finish_check = 0;
  board.RP.tx_usrapp.testError = 1'b0;
  // Tx transaction interface signal initialization.
  board.RP.tx_usrapp.pcie_tlp_data = 0;
  board.RP.tx_usrapp.pcie_tlp_rem  = 0;

  // Payload data initialization.
  board.RP.tx_usrapp.TSK_USR_DATA_SETUP_SEQ;

  board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(10050);
  for (board.RP.tx_usrapp.pfIndex = 0; board.RP.tx_usrapp.pfIndex < board.RP.tx_usrapp.NUMBER_OF_PFS; board.RP.tx_usrapp.pfIndex = board.RP.tx_usrapp.pfIndex + 1)
  begin
    board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfIndex;
    if( board.RP.tx_usrapp.pfIndex == 0) board.RP.tx_usrapp.EP_DEV_ID1 = 16'h903F;
    if( board.RP.tx_usrapp.pfIndex == 1) board.RP.tx_usrapp.EP_DEV_ID1 = 16'h913F;
    if( board.RP.tx_usrapp.pfIndex == 2) board.RP.tx_usrapp.EP_DEV_ID1 = 16'h923F;
    if( board.RP.tx_usrapp.pfIndex == 3) board.RP.tx_usrapp.EP_DEV_ID1 = 16'h933F;

    board.RP.tx_usrapp.DEV_VEN_ID = (board.RP.tx_usrapp.EP_DEV_ID1 << 16) | (32'h10EE);
    board.RP.tx_usrapp.EP_BUS_DEV_FNS = {board.RP.tx_usrapp.EP_BUS_DEV_FNS_INIT[15:2], board.RP.tx_usrapp.pfIndex[1:0]};

    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
    board.RP.tx_usrapp.TSK_BAR_INIT;

    // Find which BAR is XDMA BAR and assign 'xdma_bar' variable
    board.RP.tx_usrapp.TSK_XDMA_FIND_BAR;

    // Find which BAR is USR BAR and assign 'user_bar' variable
    board.RP.tx_usrapp.TSK_REG_READ(board.RP.tx_usrapp.xdma_bar, 16'h00);
    if(board.RP.tx_usrapp.P_READ_DATA[31:16] == 16'h1fd3) begin    // QDMA
      board.RP.tx_usrapp.TSK_FIND_USR_BAR;
    end

    board.RP.tx_usrapp.testname = "qdma_mm_test0";
    //Test starts here
    if(board.RP.tx_usrapp.testname == "dummy_test") begin
      $display("[%t] %m: Invalid TESTNAME: %0s", $realtime, board.RP.tx_usrapp.testname);
      $finish(2);
    end
    `include "tests.vh"
    else begin
      $display("[%t] %m: Error: Unrecognized TESTNAME: %0s", $realtime, board.RP.tx_usrapp.testname);
      $finish(2);
    end
    wait (board.RP.tx_usrapp.pfTestIteration == (board.RP.tx_usrapp.pfIndex +1));



    #100
    board.RP.tx_usrapp.OUT_OF_LO_MEM       = 1'b0;
    board.RP.tx_usrapp.OUT_OF_IO           = 1'b0;
    board.RP.tx_usrapp.OUT_OF_HI_MEM       = 1'b0;
    // Disable variables to start
    for (int ii = 0; ii <= 6; ii = ii + 1) begin
      board.RP.tx_usrapp.BAR_INIT_P_BAR[ii]         = 33'h00000_0000;
      board.RP.tx_usrapp.BAR_INIT_P_BAR_RANGE[ii]   = 32'h0000_0000;
      board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[ii] = 2'b00;
    end

    board.RP.tx_usrapp.BAR_INIT_P_MEM64_HI_START =  32'h0000_0001;  // hi 32 bit start of 64bit memory
    board.RP.tx_usrapp.BAR_INIT_P_MEM64_LO_START =  32'h0000_0000;  // low 32 bit start of 64bit memory
    board.RP.tx_usrapp.BAR_INIT_P_MEM32_START    =  33'h00000_0000; // start of 32bit memory
    board.RP.tx_usrapp.BAR_INIT_P_IO_START       =  33'h00000_0000; // start of 32bit io
    board.RP.tx_usrapp.NUMBER_OF_IO_BARS    = 0;
    board.RP.tx_usrapp.NUMBER_OF_MEM32_BARS = 0;
    board.RP.tx_usrapp.NUMBER_OF_MEM64_BARS = 0;

    board.RP.tx_usrapp.cpld_to = 0;        // By default time out has not occured
    board.RP.tx_usrapp.cpld_to_finish = 1; // By default end simulation on time out
    board.RP.tx_usrapp.verbose = 0;        // turned off by default
  end
  $finish;
end

endmodule // BOARD
