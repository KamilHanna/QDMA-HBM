// A collection of all the initialization tasks (previously part of the main usrapp_tx file)

/************************************************************
Task : TSK_XDMA_FIND_BAR
Inputs : input BAR1 address
Outputs : None
Description : Read XDMA configuration register
*************************************************************/
task TSK_XDMA_FIND_BAR;
  integer jj;
  integer xdma_bar_found;
begin
  jj = 0;
  xdma_bar_found = 0;
  while (xdma_bar_found == 0 && (jj < 6)) begin   // search QDMA bar from 0 to 5 only
    board.RP.tx_usrapp.P_READ_DATA = 32'hffff_ffff;
    fork
      if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[jj] == 2'b10) begin
        board.RP.tx_usrapp.TSK_TX_MEMORY_READ_32(board.RP.tx_usrapp.DEFAULT_TAG,
        board.RP.tx_usrapp.DEFAULT_TC, 11'd1,
        board.RP.tx_usrapp.BAR_INIT_P_BAR[jj][31:0]+16'h0, 4'h0, 4'hF);
        board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
      end else if(board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[jj] == 2'b11) begin
        board.RP.tx_usrapp.TSK_TX_MEMORY_READ_64(board.RP.tx_usrapp.DEFAULT_TAG,
        board.RP.tx_usrapp.DEFAULT_TC, 11'd1,{board.RP.tx_usrapp.BAR_INIT_P_BAR[jj+1][31:0],
        board.RP.tx_usrapp.BAR_INIT_P_BAR[jj][31:0]+16'h0}, 4'h0, 4'hF);
        board.RP.tx_usrapp.TSK_WAIT_FOR_READ_DATA;
      end
    join
    board.RP.tx_usrapp.TSK_TX_CLK_EAT(10);

    if((board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[jj] == 2'b10) || (board.RP.tx_usrapp.BAR_INIT_P_BAR_ENABLED[jj] == 2'b11)) begin
      board.RP.tx_usrapp.DEFAULT_TAG = board.RP.tx_usrapp.DEFAULT_TAG + 1;

      $display ("[%t] : Data read %h from Address 0x0000",$realtime , board.RP.tx_usrapp.P_READ_DATA);
      if(board.RP.tx_usrapp.P_READ_DATA[31:16] == 16'h1FD3 ) begin  //Mask [15:0] which will have revision number.
        xdma_bar = jj;
        xdma_bar_found = 1;
        $display (" QDMA BAR found : BAR %d is QDMA BAR\n", xdma_bar);
      end
      else if(board.RP.tx_usrapp.P_READ_DATA[31:16] == 16'h1FC0) begin  // XDMA Mask [15:0] which will have revision number.
        xdma_bar = jj;
        xdma_bar_found = 1;
        $display (" XDMA BAR found : BAR %d is XDMA BAR\n", xdma_bar);
      end
      else begin
        $display (" QDMA BAR : BAR %d is NOT QDMA BAR\n", jj);
      end
    end
    jj = jj + 1;
  end
  if(xdma_bar_found == 0) begin
    $display (" Not able to find QDMA BAR **ERROR** \n");
  end
end
endtask

/************************************************************
Task : TSK_SYSTEM_INITIALIZATION
Inputs : None
Outputs : None
Description : Waits for Transaction Interface Reset and Link-Up
*************************************************************/

task TSK_SYSTEM_INITIALIZATION;
begin
  //--------------------------------------------------------------------------
  // Event # 1: Wait for Transaction reset to be de-asserted...
  //--------------------------------------------------------------------------
  wait (reset == 0);
  $display("[%t] : Transaction Reset Is De-asserted...", $realtime);
  //--------------------------------------------------------------------------
  // Event # 2: Wait for Transaction link to be asserted...
  //--------------------------------------------------------------------------
  board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(32'h01, 32'h00000007, 4'h1);
  board.RP.cfg_usrapp.TSK_READ_CFG_DW(DEV_CTRL_REG_ADDR/4);
  board.RP.cfg_usrapp.TSK_WRITE_CFG_DW(DEV_CTRL_REG_ADDR/4,( board.RP.cfg_usrapp.cfg_rd_data | (DEV_CAP_MAX_PAYLOAD_SUPPORTED * 32)) , 4'h1);

  board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
  wait (board.RP.pcie_4_0_rport.user_lnk_up == 1);
  board.RP.tx_usrapp.TSK_TX_CLK_EAT(100);
  $display("[%t] : Transaction Link Is Up...", $realtime);
  //TSK_SYSTEM_CONFIGURATION_CHECK;
end
endtask
//
/************************************************************
Task : TSK_SYSTEM_CONFIGURATION_CHECK
Inputs : None
Outputs : None
Description : Check that options selected from Coregen GUI are
              set correctly.
              Checks - Max Link Speed/Width, Device/Vendor ID, CMPS
*************************************************************/
task TSK_SYSTEM_CONFIGURATION_CHECK;
begin
  error_check = 0;

  // Check Link Speed/Width
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, LINK_CTRL_REG_ADDR, 4'hF); // 12'hD0
  TSK_WAIT_FOR_READ_DATA;

  if(P_READ_DATA[19:16] == MAX_LINK_SPEED) begin
    if     (P_READ_DATA[19:16] == 1) $display("[%t] :    Check Max Link Speed = 2.5GT/s - PASSED", $realtime);
    else if(P_READ_DATA[19:16] == 2) $display("[%t] :    Check Max Link Speed = 5.0GT/s - PASSED", $realtime);
    else if(P_READ_DATA[19:16] == 3) $display("[%t] :    Check Max Link Speed = 8.0GT/s - PASSED", $realtime);
    else if(P_READ_DATA[19:16] == 4) $display("[%t] :    Check Max Link Speed = 16.0GT/s - PASSED", $realtime);
    else if(P_READ_DATA[19:16] == 5) $display("[%t] :    Check Max Link Speed = 32.0GT/s - PASSED", $realtime);
  end else begin
    $display("ERROR: [%t] :    Check Max Link Speed - FAILED", $realtime);
    $display("[%t] :    Data Error Mismatch, Parameter Data %x != Read Data %x", $realtime, MAX_LINK_SPEED, P_READ_DATA[19:16]);
    board.RP.tx_usrapp.test_state =1;
  end

  if(P_READ_DATA[24:20] == LINK_CAP_MAX_LINK_WIDTH)
    $display("[%t] :    Check Negotiated Link Width = 5'h%x - PASSED", $realtime, LINK_CAP_MAX_LINK_WIDTH);
  else
    $display("[%t] :    Data Error Mismatch, Parameter Data %x != Read Data %x", $realtime, LINK_CAP_MAX_LINK_WIDTH, P_READ_DATA[24:20]);

  // Check Device/Vendor ID
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, 12'h0, 4'hF);
  TSK_WAIT_FOR_READ_DATA;

  if(P_READ_DATA[31:16] != EP_DEV_ID1) begin
    $display("ERROR: [%t] :    Check Device/Vendor ID - FAILED", $realtime);
    $display("[%t] :    Data Error Mismatch, Parameter Data %x != Read Data %x", $realtime, EP_DEV_ID1, P_READ_DATA);
    board.RP.tx_usrapp.test_state =1;
  //error_check = 1;
  end else begin
    $display("[%t] :    Check Device/Vendor ID - PASSED", $realtime);
  end

  // Check CMPS
  TSK_TX_TYPE0_CONFIGURATION_READ(DEFAULT_TAG, PCIE_DEV_CAP_ADDR, 4'hF); //12'hC4
  TSK_WAIT_FOR_READ_DATA;

  if(P_READ_DATA[2:0] != DEV_CAP_MAX_PAYLOAD_SUPPORTED) begin
    $display("ERROR: [%t] :    Check CMPS ID - FAILED", $realtime);
    $display("[%t] :    Data Error Mismatch, Parameter Data %x != Read data %x", $realtime, DEV_CAP_MAX_PAYLOAD_SUPPORTED, P_READ_DATA[2:0]);
    board.RP.tx_usrapp.test_state =1;
  //error_check = 1;
  end else begin
    $display("[%t] :    Check CMPS ID - PASSED", $realtime);
  end

  if(error_check == 0) begin
    $display("[%t] :    SYSTEM CHECK PASSED", $realtime);
  end else begin
    $display("ERROR: [%t] :    SYSTEM CHECK FAILED", $realtime);
    board.RP.tx_usrapp.test_state =1;
    $finish;
  end
end
endtask 
