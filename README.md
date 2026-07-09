# AHB_SingleMaster_SingleSlave
Implementation and Functional Verification of AMBA AHB Single Master–Single Slave Protocol using Verilog

# AMBA AHB Single Master–Single Slave Protocol

## Overview

This project implements the **AMBA Advanced High-performance Bus (AHB)** Single Master–Single Slave architecture in **Verilog HDL**. The design models communication between one AHB master and one AHB slave following the AMBA AHB protocol.

The master generates address, control, and data signals, while the slave responds to read and write requests through an internal memory. Functional verification is performed using a custom Verilog testbench to validate the protocol behavior.

---

## Objectives

- Implement an AHB Single Master–Single Slave architecture in Verilog.
- Design FSM-based master and slave controllers.
- Support read and write transactions.
- Verify protocol functionality through simulation.
- Generate waveforms for timing and functional analysis.

---

## Project Specifications

| Parameter | Value |
|-----------|-------|
| Bus Protocol | ARM AMBA AHB |
| Architecture | Single Master – Single Slave |
| HDL | Verilog |
| Data Width | 32-bit |
| Address Width | 32-bit |
| Verification | Verilog Testbench |
| Simulation | Vivado |

---

# Features

- FSM-based AHB Master
- FSM-based AHB Slave
- Address Phase
- Read Transactions
- Write Transactions
- Internal Slave Memory
- Ready and Response Signal Handling
- Functional Verification using Custom Testbench
- Waveform Generation (.vcd)

---

# Design Architecture

```
                +----------------------+
                |      AHB Master      |
                |----------------------|
                | Address Generation   |
                | Read/Write Control   |
                | FSM Controller       |
                +----------+-----------+
                           |
                           | AHB Bus
                           |
                +----------v-----------+
                |       AHB Slave      |
                |----------------------|
                | Memory Array         |
                | Read Logic           |
                | Write Logic          |
                | FSM Controller       |
                +----------------------+
```

---

# RTL Modules

## ahb_master

Implements the AHB Master responsible for:

- Address generation
- Read/Write control
- AHB control signal generation
- Data transfer
- FSM implementation

### Master States

- Idle
- Address Phase
- Write Phase
- Read Phase

---

## ahb_slave

Implements the AHB Slave responsible for:

- Receiving AHB transactions
- Internal memory operations
- Read data generation
- Ready signal generation
- Response generation

### Slave States

- Idle
- Address Transfer
- Write Phase
- Read Phase

---

## Top Module

The top module integrates:

- One AHB Master
- One AHB Slave

and connects all AHB interface signals between them.

---
# Signals Used

## Master Interface

- HCLK
- HRESETn
- HADDR
- HWRITE
- HSIZE
- HBURST
- HTRANS
- HREADY
- HWDATA
- HPROT
- HMASTLOCK

---

## Slave Interface

- HREADYOUT
- HRESP
- HRDATA

---

# State Machines

## Master FSM

```
Idle

↓

Address Phase

↓

Write Phase

or

Read Phase
```

---

## Slave FSM

```
Idle

↓

Address Transfer

↓

Write Phase

or

Read Phase
```

---

# Future Improvements

- Multiple Masters
- Multiple Slaves
- AHB Arbiter
- Address Decoder
- Burst Transfer Verification
- SystemVerilog/UVM Testbench
- AHB to APB Bridge

---# License

This project is licensed under the MIT License.
