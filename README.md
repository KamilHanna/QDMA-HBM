### Data Transmission Between the HBM and the Host

The data transmission pipeline, **{Host <-> PCIe <-> QDMA <-> Smart Connect <-> HBM}**, enables communication between the host memory (main memory) and the HBM (High Bandwidth Memory).

Initially, the host issues transaction that go through the PCIe, which acts as an intermediary between the host and the QDMA (Queue Direct Memory Access) module. The PCIe serves as the communication link, transferring data in a serial stream from/to host/device. The QDMA module, an optimized version of the standard DMA (Direct Memory Access), facilitates the data transfers between two parties without CPU involvement. DMA is typically used to move data between a memory and a peripheral or between two memory regions. The key improvement in QDMA is its queuing mechanism, which enables concurrent scheduling of multiple transfers. This enhances throughput despite the PCIe being a serial bus, by effectively overlapping transfers and eliminating latency. 

In simpler terms, the parallelism in this setup refers to how many transfer requests can be prepared and ready at once, ensuring that no time is wasted between transfers.

To initiate a data transfer over PCIe, a **a descriptor** must be initialized. A descriptor is a 32-byte data structure that typically contains:
- Address of structure (pointer where the script resides)
- Destination address in HBM (where the data is being moved to)
- Amount of data to be moved

Each descriptor acts as a small instruction set for the QDMA, guiding the data movement process. Decriptors are always set up by the host, regardless of the direction of the intended transfer. The QDMA can support up to 2048 queues, each containing addresses for the descriptors. Furthermore, the QDMA module is configured to operate in memory-mapped mode, rather than AXI stream mode. This means the QDMA converts PCIe packets into AXI transactions, specifically AXI4 memory-mapped transactions, which include address data, control information, and data. These transactions are special due to their random access pattern and precise memory control. These AXI-4 transactions are then forwarded to the **Smart Connect** vhich acts as an arbiter, routing the AXI4 transactions to the HBM banks. One of the important roles of the Smart Connect is to convert AXI4 transactions into AXI3 transactions, matching the HBM interface type.  This configuration leverages the HBM's parallel access capabilities, allowing each transaction to target a specific memory region.

## PCIE AND HBM SIMULATION

This folder contains the necessary sources and scripts to generate a Vivado project targeting an Alveo U55C board and launch a Questa simulation of a system containing a set of Snitch cores connected with an HBM and a QDMA interface for PCIe. The simulation consists in loading the binary file of a Polybench into the HBM memory, and then running such program with the Snitch cores.

### What you need to do:

- Make sure to have Vivado in your path (launch `source /<Vivado_Install_Path>/<Vivado_Version>/settings64.sh` in the Linux terminal)
- Set Vivado version in `./tcl/qdma_hbm_bd.tcl`
- Set the path to the compiled Vivado libraries for Questa in `./tcl/gen_sim_prj.tcl`
- Launch the generation of the Vivado project running the project TCL script with Vivado (from the current folder, launch `vivado -mode batch -source ./tcl/gen_sim_prj.tcl`. The Vivado GUI will open automatically.
- Run the simulation from the Vivado GUI.

### What you will see:

The testbench launches two tasks: *TSK_QDMA_MM_H2C_TEST* and *TSK_QDMA_MM_C2H_TEST*, which have the goal, respectively, to write a bunch of data from the simulated host memory to the HBM and to read that data back from the HBM to the host memory.
This functions use a single queue which is populated with various descriptors generated in the initialization functions.

### Folder organization

- **flist:** it contains just a file with a list of all the sources files used for the simulation
- **src:** it contains all the source files.
    - *include:* contains a set of header files used by the project, including the `sample_tests.vh` which contains the main functions called by the top testbench file
    - *RP_model:* contains the sources describing the root port model
    - *usrapp:* contains the tx, rx, cfg and com parts of the testbench. In particular, the tx source file contains most of the functions used by the testbench
    - `qdma_tb.sv:` top testbench source file
    - `qdma_top.sv:` top synthesizable file, containing the block design
- **tcl:** it contains two tcl scripts, one to generate the project and one to generate the block design.
