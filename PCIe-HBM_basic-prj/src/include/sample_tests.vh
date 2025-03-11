
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
// File       : sample_tests.vh
// Version    : 5.0
//-----------------------------------------------------------------------------
//
//------------------------------------------------------------------------------


//else if(board.RP.tx_usrapp.testname =="irq_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h0;
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   #1000;
//   board.RP.tx_usrapp.TSK_USR_IRQ_TEST;   
//
//end
else if(board.RP.tx_usrapp.testname =="qdma_mm_test0")
begin
   // Choose the queue id
   board.RP.tx_usrapp.qid = 11'h1;
   // QDMA H2C test
   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 1);
   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 0, 1);
   $display("\n\nCOMPLETED QDMA TEST\n\n");
   //#1000;
   //board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
   //if (board.RP.tx_usrapp.test_state == 1 )
   //  $display ("ERROR: TEST FAILED \n");
   //#1000;
   //$finish;
end
//else if(board.RP.tx_usrapp.testname =="qdma_mm_cmpt_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h0;
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   board.RP.tx_usrapp.TSK_QDMA_IMM_TEST(board.RP.tx_usrapp.qid);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//   if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//
//else if(board.RP.tx_usrapp.testname == "qdma_st_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h3;
//   board.RP.tx_usrapp.TSK_QDMA_ST_C2H_TEST(board.RP.tx_usrapp.qid, 0);
//   board.RP.tx_usrapp.TSK_QDMA_ST_H2C_TEST(board.RP.tx_usrapp.qid, 0);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//else if(board.RP.tx_usrapp.testname == "qdma_st_c2h_simbyp_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h3;
//   board.RP.tx_usrapp.TSK_QDMA_ST_C2H_SIMBYP_TEST(board.RP.tx_usrapp.qid, 1);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//else if(board.RP.tx_usrapp.testname == "qdma_imm_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h2;
//   board.RP.tx_usrapp.TSK_QDMA_IMM_TEST(board.RP.tx_usrapp.qid);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//
//else if(board.RP.tx_usrapp.testname == "qdma_mm_st_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h3;
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 1);
//   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 0, 1);
//   board.RP.tx_usrapp.TSK_QDMA_ST_H2C_TEST(board.RP.tx_usrapp.qid, 0);
//   board.RP.tx_usrapp.TSK_QDMA_ST_C2H_TEST(board.RP.tx_usrapp.qid, 0);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//
//else if(board.RP.tx_usrapp.testname == "qdma_h2c_lp_c2h_imm_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h1;
//   board.RP.tx_usrapp.TSK_QDMA_H2C_LP_C2H_IMM_TEST(board.RP.tx_usrapp.qid, 0);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//
//else if(board.RP.tx_usrapp.testname == "qdma_mm_st_dsc_byp_test0")
//begin
//   board.RP.tx_usrapp.qid = 11'h4;
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 1, 0);
//   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 1, 0);
//   board.RP.tx_usrapp.TSK_QDMA_ST_C2H_TEST(board.RP.tx_usrapp.qid, 1);
//   board.RP.tx_usrapp.TSK_QDMA_ST_H2C_TEST(board.RP.tx_usrapp.qid, 1);
//   #1000;
//   board.RP.tx_usrapp.pfTestIteration = board.RP.tx_usrapp.pfTestIteration + 1;
//    if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//   #1000;
//   $finish;
//end
//else if(board.RP.tx_usrapp.testname =="qdma_mm_user_reset_test0")
//begin
//   board.RP.tx_usrapp.qid = 0;
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   #1000;
//   board.RP.tx_usrapp.TSK_REG_WRITE(board.RP.tx_usrapp.user_bar,32'h98, 32'h640001, 4'hF);
//   #30000000  
//   board.RP.tx_usrapp.TSK_QDMA_MM_H2C_TEST(board.RP.tx_usrapp.qid, 0, 0);
//   board.RP.tx_usrapp.TSK_QDMA_MM_C2H_TEST(board.RP.tx_usrapp.qid, 0, 0);
//    if (board.RP.tx_usrapp.test_state == 1 )
//      $display ("ERROR: TEST FAILED \n");
//
//   $finish;
//end
//
//
//
//else if(board.RP.tx_usrapp.testname == "sample_smoke_test0")
//begin
//
//
//    board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(5050);
//
//    //System Initialization
//    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
//
//
//
//
//    
//    $display("[%t] : Expected Device/Vendor ID = %x", $realtime, board.RP.tx_usrapp.DEV_VEN_ID); 
//    
//    //--------------------------------------------------------------------------
//    // Read core configuration space via PCIe fabric interface
//    //--------------------------------------------------------------------------
//
//    $display("[%t] : Reading from PCI/PCI-Express Configuration Register 0x00", $realtime);
//
//    board.RP.tx_usrapp.TSK_TX_TYPE0_CONFIGURATION_READ(board.RP.tx_usrapp.DEFAULT_TAG, 12'h0, 4'hF);
//    board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
//    if  (board.RP.tx_usrapp.P_READ_DATA != board.RP.tx_usrapp.DEV_VEN_ID) begin
//        $display("ERROR: [%t] : TEST FAILED --- Data Error Mismatch, Write Data %x != Read Data %x", $realtime, 
//                                    board.RP.tx_usrapp.DEV_VEN_ID, board.RP.tx_usrapp.P_READ_DATA);
//    end
//    else begin
//        $display("[%t] : TEST PASSED --- Device/Vendor ID %x successfully received", $realtime, board.RP.tx_usrapp.P_READ_DATA);
//        $display("[%t] : Test Completed Successfully",$realtime);
//    end
//
//    //--------------------------------------------------------------------------
//    // Direct Root Port to allow upstream traffic by enabling Mem, I/O and
//    // BusMstr in the command register
//    //--------------------------------------------------------------------------
//
//    board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
//    board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h00000001, 32'h00000007, 4'b0001);
//    board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
//    
//     if (board.RP.tx_usrapp.test_state == 1 )
//     $display ("ERROR: TEST FAILED \n");
//
//  $finish;
//end
//
//
//else if(board.RP.tx_usrapp.testname == "sample_smoke_test1")
//begin
//
//    // This test use tlp expectation tasks.
//
//    board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(5050);
//
//    // System Initialization
//    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
//    // Program BARs (Required so Completer ID at the Endpoint is updated)
//    board.RP.tx_usrapp.TSK_BAR_INIT;
//
//fork
//  begin
//    //--------------------------------------------------------------------------
//    // Read core configuration space via PCIe fabric interface
//    //--------------------------------------------------------------------------
//
//    $display("[%t] : Reading from PCI/PCI-Express Configuration Register 0x00", $realtime);
//
//    board.RP.tx_usrapp.TSK_TX_TYPE0_CONFIGURATION_READ(board.RP.tx_usrapp.DEFAULT_TAG, 12'h0, 4'hF);
//    board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//    board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
//  end
//    //---------------------------------------------------------------------------
//    // List Rx TLP expections
//    //---------------------------------------------------------------------------
//  begin
//    board.RP.tx_usrapp.test_vars[0] = 0;                                                                                                                         
//                                          
//    $display("[%t] : Expected Device/Vendor ID = %x", $realtime, board.RP.tx_usrapp.DEV_VEN_ID);                                              
//
//    board.RP.tx_usrapp.expect_cpld_payload[0] = board.RP.tx_usrapp.DEV_VEN_ID[31:24];
//    board.RP.tx_usrapp.expect_cpld_payload[1] = board.RP.tx_usrapp.DEV_VEN_ID[23:16];
//    board.RP.tx_usrapp.expect_cpld_payload[2] = board.RP.tx_usrapp.DEV_VEN_ID[15:8];
//    board.RP.tx_usrapp.expect_cpld_payload[3] = board.RP.tx_usrapp.DEV_VEN_ID[7:0];
//    @(posedge board.RP.tx_usrapp.pcie_rq_tag_vld);
//    board.RP.tx_usrapp.exp_tag = board.RP.tx_usrapp.pcie_rq_tag;
//
//    board.RP.com_usrapp.TSK_EXPECT_CPLD(
//      3'h0, //traffic_class;
//      1'b0, //td;
//      1'b0, //ep;
//      2'h0, //attr;
//      10'h1, //length;
//      board.RP.tx_usrapp.EP_BUS_DEV_FNS, //completer_id;
//      3'h0, //completion_status;
//      1'b0, //bcm;
//      12'h4, //byte_count;
//      board.RP.tx_usrapp.RP_BUS_DEV_FNS, //requester_id;
//      board.RP.tx_usrapp.exp_tag ,
//      7'b0, //address_low;
//      board.RP.tx_usrapp.expect_status //expect_status;
//    );
//
//    if (board.RP.tx_usrapp.expect_status) 
//      board.RP.tx_usrapp.test_vars[0] = board.RP.tx_usrapp.test_vars[0] + 1;      
//  end
//join
//  
//  board.RP.tx_usrapp.expect_finish_check = 1;
//
//  if (board.RP.tx_usrapp.test_vars[0] == 1) begin
//    $display("[%t] : TEST PASSED --- Finished transmission of PCI-Express TLPs", $realtime);
//    $display("[%t] : Test Completed Successfully",$realtime);
//  end else begin
//    $display("ERROR: [%t] : TEST FAILED --- Haven't Received All Expected TLPs", $realtime);
//
//    //--------------------------------------------------------------------------
//    // Direct Root Port to allow upstream traffic by enabling Mem, I/O and
//    // BusMstr in the command register
//    //--------------------------------------------------------------------------
//
//    board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
//    board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h00000001, 32'h00000007, 4'b0001);
//    board.RP.cfg_usrapp.TSK_READ_CFG_DW(32'h00000001);
//
//  end
//
//  $finish;
//end
//
//else if(board.RP.tx_usrapp.testname == "pio_writeReadBack_test0")
//begin
//
//    // This test performs a 32 bit write to a 32 bit Memory space and performs a read back
//
//    board.RP.tx_usrapp.TSK_SIMULATION_TIMEOUT(10050);
//
//    board.RP.tx_usrapp.TSK_SYSTEM_INITIALIZATION;
//
//    board.RP.tx_usrapp.TSK_BAR_INIT;
//
////--------------------------------------------------------------------------
//// Event : Testing BARs
////--------------------------------------------------------------------------
//
//        for (board.RP.tx_usrapp.ii = 0; board.RP.tx_usrapp.ii <= 6; board.RP.tx_usrapp.ii =
//            board.RP.tx_usrapp.ii + 1) begin
//            if ((board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii] > 2'b00)) // bar is enabled
//               case(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[board.RP.tx_usrapp.ii])
//                   2'b01 : // IO SPACE
//                        begin
//
//                          $display("[%t] : Transmitting TLPs to IO Space BAR %x", $realtime, board.RP.tx_usrapp.ii);
//
//                          //--------------------------------------------------------------------------
//                          // Event : IO Write bit TLP
//                          //--------------------------------------------------------------------------
//
//
//
//                          board.RP.tx_usrapp.TSK_TX_IO_WRITE(board.RP.tx_usrapp.DEFAULT_TAG,
//                             board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], 4'hF, 32'hdead_beef);
//                             @(posedge board.RP.tx_usrapp.pcie_rq_tag_vld);
//                             board.RP.tx_usrapp.exp_tag = board.RP.tx_usrapp.pcie_rq_tag;
//
//
//                          board.RP.com_usrapp.TSK_EXPECT_CPL(3'h0, 1'b0, 1'b0, 2'b0,
//                             board.RP.tx_usrapp.EP_BUS_DEV_FNS, 3'h0, 1'b0, 12'h4,
//                             board.RP.tx_usrapp.RP_BUS_DEV_FNS, board.RP.tx_usrapp.exp_tag,
//                             board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], board.RP.tx_usrapp.test_vars[0]);
//
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//                          //--------------------------------------------------------------------------
//                          // Event : IO Read bit TLP
//                          //--------------------------------------------------------------------------
//
//
//                          // make sure P_READ_DATA has known initial value
//                          board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
//                          fork
//                             board.RP.tx_usrapp.TSK_TX_IO_READ(board.RP.tx_usrapp.DEFAULT_TAG,
//                                board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0], 4'hF);
//                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
//                          join
//                          if  (board.RP.tx_usrapp.P_READ_DATA != 32'hdead_beef)
//                             begin
//			       board.RP.tx_usrapp.testError=1'b1;
//                               $display("ERROR:  [%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
//                                   $realtime, 32'hdead_beef, board.RP.tx_usrapp.P_READ_DATA);
//                             end
//                          else
//                             begin
//                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
//                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
//                             end
//
//
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//
//                        end
//
//                   2'b10 : // MEM 32 SPACE
//                        begin
//
//
//                          $display("[%t] : Transmitting TLPs to Memory 32 Space BAR %x", $realtime,
//                              board.RP.tx_usrapp.ii);
//
//                          //--------------------------------------------------------------------------
//                          // Event : Memory Write 32 bit TLP
//                          //--------------------------------------------------------------------------
//
//                          board.RP.tx_usrapp.DATA_STORE[0] = 8'h04;
//                          board.RP.tx_usrapp.DATA_STORE[1] = 8'h03;
//                          board.RP.tx_usrapp.DATA_STORE[2] = 8'h02;
//                          board.RP.tx_usrapp.DATA_STORE[3] = 8'h01;
//
//                          board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_32(board.RP.tx_usrapp.DEFAULT_TAG,
//                              board.RP.tx_usrapp.DEFAULT_TC, 11'd1,
//                              board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h10, 4'h0, 4'hF, 1'b0);
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//                          //--------------------------------------------------------------------------
//                          // Event : Memory Read 32 bit TLP
//                          //--------------------------------------------------------------------------
//
//
//                         // make sure P_READ_DATA has known initial value
//                         board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
//                          fork
//                             board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG,
//                                 board.RP.tx_usrapp.DEFAULT_TC, 11'd1,
//                                 board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h10, 4'h0, 4'hF);
//                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
//                          join
//                          if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[3],
//                             board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
//                             board.RP.tx_usrapp.DATA_STORE[0] })
//                             begin
//			       board.RP.tx_usrapp.testError=1'b1;
//                               $display("ERROR: [%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
//                                    $realtime, {board.RP.tx_usrapp.DATA_STORE[3],board.RP.tx_usrapp.DATA_STORE[2],
//                                     board.RP.tx_usrapp.DATA_STORE[1],board.RP.tx_usrapp.DATA_STORE[0]},
//                                     board.RP.tx_usrapp.P_READ_DATA);
//
//                             end
//                          else
//                             begin
//                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
//                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
//                             end
//
//
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//                     end
//                2'b11 : // MEM 64 SPACE
//                     begin
//
//
//                          $display("[%t] : Transmitting TLPs to Memory 64 Space BAR %x", $realtime,
//                              board.RP.tx_usrapp.ii);
//
//
//                          //--------------------------------------------------------------------------
//                          // Event : Memory Write 64 bit TLP
//                          //--------------------------------------------------------------------------
//
//                          board.RP.tx_usrapp.DATA_STORE[0] = 8'h64;
//                          board.RP.tx_usrapp.DATA_STORE[1] = 8'h63;
//                          board.RP.tx_usrapp.DATA_STORE[2] = 8'h62;
//                          board.RP.tx_usrapp.DATA_STORE[3] = 8'h61;
//
//                          board.RP.tx_usrapp.TSK_TX_MEMORY_WRITE_64(board.RP.tx_usrapp.DEFAULT_TAG,
//                              board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
//                              {board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii+1][31:0],
//                              board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h20}, 4'h0, 4'hF, 1'b0);
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//                          //--------------------------------------------------------------------------
//                          // Event : Memory Read 64 bit TLP
//                          //--------------------------------------------------------------------------
//
//
//                          // make sure P_READ_DATA has known initial value
//                          board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
//                          fork
//                             board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG,
//                                 board.RP.tx_usrapp.DEFAULT_TC, 10'd1,
//                                 {board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii+1][31:0],
//                                 board.RP.tx_usrapp.BAR_INIT_P_BAR[board.RP.tx_usrapp.ii][31:0]+8'h20}, 4'h0, 4'hF);
//                             board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
//                          join
//                          if  (board.RP.tx_usrapp.P_READ_DATA != {board.RP.tx_usrapp.DATA_STORE[3],
//                             board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
//                             board.RP.tx_usrapp.DATA_STORE[0] })
//
//                             begin
//			       board.RP.tx_usrapp.testError=1'b1;
//                               $display("ERROR: [%t] : Test FAILED --- Data Error Mismatch, Write Data %x != Read Data %x",
//                                   $realtime, {board.RP.tx_usrapp.DATA_STORE[3],
//                                   board.RP.tx_usrapp.DATA_STORE[2], board.RP.tx_usrapp.DATA_STORE[1],
//                                   board.RP.tx_usrapp.DATA_STORE[0]}, board.RP.tx_usrapp.P_READ_DATA);
//
//                             end
//                          else
//                             begin
//                               $display("[%t] : Test PASSED --- Write Data: %x successfully received",
//                                   $realtime, board.RP.tx_usrapp.P_READ_DATA);
//                             end
//
//
//                          board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);
//                          board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;
//
//
//                     end
//                default : $display("Error case in usrapp_tx\n");
//            endcase
//
//         end
//    if(board.RP.tx_usrapp.testError==1'b0)
//      $display("[%t] : Test Completed Successfully",$realtime);
//
//    $display("[%t] : Finished transmission of PCI-Express TLPs", $realtime);
//    $finish;
//end
