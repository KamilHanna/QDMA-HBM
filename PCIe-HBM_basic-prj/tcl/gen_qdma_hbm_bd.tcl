
################################################################
# This is a generated script based on design: qdma_hbm_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_xdma_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu55c-fsvh2892-2L-e
   set_property BOARD_PART xilinx.com:au55c:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name qdma_hbm_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:hbm:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:qdma:5.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pci_express_x16 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x16 ]


  # Create ports
  set hbm_clk_n [ create_bd_port -dir I -type clk -freq_hz 100000000 hbm_clk_n ]
  set hbm_clk_p [ create_bd_port -dir I -type clk -freq_hz 100000000 hbm_clk_p ]
  set aresetn [ create_bd_port -dir I -type rst aresetn ]
  set qdma_clk [ create_bd_port -dir I -type clk qdma_clk ]
  set qdma_clk_gt [ create_bd_port -dir I -type clk qdma_clk_gt ]

  # Create instance: hbm_0, and set properties
  set hbm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:hbm:1.0 hbm_0 ]
  set_property -dict [list \
    CONFIG.USER_APB_EN {false} \
    CONFIG.USER_AXI_INPUT_CLK1_FREQ {250} \
    CONFIG.USER_AXI_INPUT_CLK_FREQ {250} \
    CONFIG.USER_HBM_DENSITY {16GB} \
    CONFIG.USER_MC0_USER_PARITY_EN {false} \
    CONFIG.USER_SAXI_00 {false} \
    CONFIG.USER_SAXI_01 {false} \
    CONFIG.USER_SAXI_02 {false} \
    CONFIG.USER_SAXI_03 {false} \
    CONFIG.USER_SAXI_04 {false} \
    CONFIG.USER_SAXI_05 {false} \
    CONFIG.USER_SAXI_06 {false} \
    CONFIG.USER_SAXI_07 {false} \
    CONFIG.USER_SAXI_08 {false} \
    CONFIG.USER_SAXI_09 {false} \
    CONFIG.USER_SAXI_10 {false} \
    CONFIG.USER_SAXI_11 {false} \
    CONFIG.USER_SAXI_12 {false} \
    CONFIG.USER_SAXI_13 {false} \
    CONFIG.USER_SAXI_14 {false} \
    CONFIG.USER_SAXI_17 {false} \
    CONFIG.USER_SAXI_18 {false} \
    CONFIG.USER_SAXI_19 {false} \
    CONFIG.USER_SAXI_20 {false} \
    CONFIG.USER_SAXI_21 {false} \
    CONFIG.USER_SAXI_22 {false} \
    CONFIG.USER_SAXI_23 {false} \
    CONFIG.USER_SAXI_24 {false} \
    CONFIG.USER_SAXI_25 {false} \
    CONFIG.USER_SAXI_26 {false} \
    CONFIG.USER_SAXI_27 {false} \
    CONFIG.USER_SAXI_28 {false} \
    CONFIG.USER_SAXI_29 {false} \
    CONFIG.USER_SAXI_30 {false} \
    CONFIG.USER_SAXI_31 {false} \
  ] $hbm_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $clk_wiz_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: qdma_0, and set properties
  set qdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:5.0 qdma_0 ]
  set_property -dict [list \
    CONFIG.dma_intf_sel_qdma {AXI_MM} \
    CONFIG.en_gt_selection {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.num_queues {2048} \
    CONFIG.pcie_blk_locn {PCIE4C_X1Y0} \
    CONFIG.pf0_bar2_enabled_qdma {true} \
    CONFIG.pf0_msix_enabled_qdma {false} \
    CONFIG.pl_link_cap_max_link_width {X16} \
  ] $qdma_0


  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property -dict [list \
    CONFIG.PROTOCOL {AXI4LITE} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $axi_bram_ctrl_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net qdma_0_M_AXI [get_bd_intf_pins qdma_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net qdma_0_M_AXI_LITE [get_bd_intf_pins qdma_0/M_AXI_LITE] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net qdma_0_pcie_mgt [get_bd_intf_ports pci_express_x16] [get_bd_intf_pins qdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins hbm_0/SAXI_15_8HI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins hbm_0/SAXI_16_8HI]

  # Create port connections
  connect_bd_net -net aclk_n_1 [get_bd_ports hbm_clk_n] [get_bd_pins clk_wiz_0/clk_in1_n]
  connect_bd_net -net aclk_p_1 [get_bd_ports hbm_clk_p] [get_bd_pins clk_wiz_0/clk_in1_p]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hbm_0/HBM_REF_CLK_0] [get_bd_pins hbm_0/HBM_REF_CLK_1] [get_bd_pins hbm_0/APB_0_PCLK] [get_bd_pins hbm_0/APB_1_PCLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins hbm_0/APB_0_PRESET_N] [get_bd_pins hbm_0/APB_1_PRESET_N]
  connect_bd_net -net resetn_0_1 [get_bd_ports aresetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins qdma_0/sys_rst_n] [get_bd_pins qdma_0/soft_reset_n]
  connect_bd_net -net sys_clk_0_1 [get_bd_ports qdma_clk] [get_bd_pins qdma_0/sys_clk]
  connect_bd_net -net sys_clk_gt_0_1 [get_bd_ports qdma_clk_gt] [get_bd_pins qdma_0/sys_clk_gt]
  connect_bd_net -net qdma_0_axi_aclk [get_bd_pins qdma_0/axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins hbm_0/AXI_15_ACLK] [get_bd_pins hbm_0/AXI_16_ACLK] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
  connect_bd_net -net qdma_0_axi_aresetn [get_bd_pins qdma_0/axi_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins hbm_0/AXI_15_ARESET_N] [get_bd_pins hbm_0/AXI_16_ARESET_N] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins qdma_0/tm_dsc_sts_rdy] [get_bd_pins qdma_0/qsts_out_rdy]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM00] -force
  assign_bd_address -offset 0x20000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM01] -force
  assign_bd_address -offset 0x40000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM02] -force
  assign_bd_address -offset 0x60000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM03] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM04] -force
  assign_bd_address -offset 0xA0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM05] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM06] -force
  assign_bd_address -offset 0xE0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM07] -force
  assign_bd_address -offset 0x000100000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM08] -force
  assign_bd_address -offset 0x000120000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM09] -force
  assign_bd_address -offset 0x000140000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM10] -force
  assign_bd_address -offset 0x000160000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM11] -force
  assign_bd_address -offset 0x000180000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM12] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM13] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM14] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM15] -force
  assign_bd_address -offset 0x000200000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM16] -force
  assign_bd_address -offset 0x000220000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM17] -force
  assign_bd_address -offset 0x000240000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM18] -force
  assign_bd_address -offset 0x000260000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM19] -force
  assign_bd_address -offset 0x000280000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM20] -force
  assign_bd_address -offset 0x0002A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM21] -force
  assign_bd_address -offset 0x0002C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM22] -force
  assign_bd_address -offset 0x0002E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM23] -force
  assign_bd_address -offset 0x000300000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM24] -force
  assign_bd_address -offset 0x000320000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM25] -force
  assign_bd_address -offset 0x000340000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM26] -force
  assign_bd_address -offset 0x000360000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM27] -force
  assign_bd_address -offset 0x000380000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM28] -force
  assign_bd_address -offset 0x0003A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM29] -force
  assign_bd_address -offset 0x0003C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM30] -force
  assign_bd_address -offset 0x0003E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM31] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI_LITE] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM00]
  exclude_bd_addr_seg -offset 0x000420000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM01]
  exclude_bd_addr_seg -offset 0x000440000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM02]
  exclude_bd_addr_seg -offset 0x000460000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM03]
  exclude_bd_addr_seg -offset 0x000480000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM04]
  exclude_bd_addr_seg -offset 0x0004A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM05]
  exclude_bd_addr_seg -offset 0x0004C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM06]
  exclude_bd_addr_seg -offset 0x0004E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM07]
  exclude_bd_addr_seg -offset 0x000500000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM08]
  exclude_bd_addr_seg -offset 0x000520000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM09]
  exclude_bd_addr_seg -offset 0x000540000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM10]
  exclude_bd_addr_seg -offset 0x000560000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM11]
  exclude_bd_addr_seg -offset 0x000580000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM12]
  exclude_bd_addr_seg -offset 0x0005A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM13]
  exclude_bd_addr_seg -offset 0x0005C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM14]
  exclude_bd_addr_seg -offset 0x0005E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_16_8HI/HBM_MEM15]
  exclude_bd_addr_seg -offset 0x000600000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM16]
  exclude_bd_addr_seg -offset 0x000620000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM17]
  exclude_bd_addr_seg -offset 0x000640000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM18]
  exclude_bd_addr_seg -offset 0x000660000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM19]
  exclude_bd_addr_seg -offset 0x000680000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM20]
  exclude_bd_addr_seg -offset 0x0006A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM21]
  exclude_bd_addr_seg -offset 0x0006C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM22]
  exclude_bd_addr_seg -offset 0x0006E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM23]
  exclude_bd_addr_seg -offset 0x000700000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM24]
  exclude_bd_addr_seg -offset 0x000720000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM25]
  exclude_bd_addr_seg -offset 0x000740000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM26]
  exclude_bd_addr_seg -offset 0x000760000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM27]
  exclude_bd_addr_seg -offset 0x000780000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM28]
  exclude_bd_addr_seg -offset 0x0007A0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM29]
  exclude_bd_addr_seg -offset 0x0007C0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM30]
  exclude_bd_addr_seg -offset 0x0007E0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs hbm_0/SAXI_15_8HI/HBM_MEM31]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


