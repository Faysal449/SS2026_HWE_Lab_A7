# FPGA-Based RSU Intersection Reservation Controller

## Project Overview

This project implements a hardware-level Roadside Unit (RSU) controller for a four-way autonomous vehicle intersection. The intersection contains a square-shaped critical zone where vehicles from the main road and side road may conflict. The RSU does not operate as a traffic light. Instead, it provides digital permission signals to driverless cars.

The system is designed and implemented in VHDL on an FPGA board. The design will later be considered for a simplified custom PCB/evaluation board according to the Hardware Engineering Lab project guidance.

## Scenario

The intersection has four incoming directions:

* North
* South
* East
* West

The North-South direction is defined as the main road.
The East-West direction is defined as the side road.

Each autonomous vehicle sends a request signal to the RSU. The RSU decides which road group is allowed to enter the intersection square.

## Main Idea

The RSU grants permission to one non-conflicting road group at a time.

* Main road: North and South vehicles
* Side road: East and West vehicles
* Main road has priority
* Side road must not wait more than 20 seconds
* One vehicle needs 5 seconds to cross the intersection square
* Main road can be served for up to 20 seconds
* Side road can be served for up to 10 seconds

## Key Timing Parameters

| Parameter    | Value | Meaning                                               |
| ------------ | ----: | ----------------------------------------------------- |
| `T_cross`    |   5 s | Time for one vehicle to clear the intersection square |
| `T_main`     |  20 s | Maximum main road service window                      |
| `T_side`     |  10 s | Maximum side road service window                      |
| `W_side_max` |  20 s | Maximum allowed side road waiting time                |

## Safety Rule

The RSU must never grant the main road and side road at the same time.

```text
(N_grant OR S_grant) AND (E_grant OR W_grant) = 0
```

## Fairness Rule

The side road must not wait more than 20 seconds.

```text
side_wait_timer <= 20 s
```

## Planned Implementation

The FPGA design will contain the following modules:

* Clock divider
* Input synchronization and debounce
* Request grouping logic
* Timer unit
* RSU finite state machine
* Grant output decoder
* Debug output using LEDs or seven-segment display

## Planned Verification

The design will be verified using a VHDL testbench in QuestaSim. The testbench will check:

* No car request
* Only main road request
* Only side road request
* Both roads requesting at the same time
* Side road waiting limit
* Main road maximum service time
* Side road maximum service time
* No conflicting grants

## Planned Hardware Validation

The FPGA board will be used to validate the design. Switches or buttons will represent vehicle request inputs. LEDs will represent RSU grant outputs.

## Future PCB Concept

For the PCB concept, only the required hardware components will be considered:

* FPGA
* Clock source
* Reset circuit
* Power supply
* Programming interface
* Request input buttons/switches
* Grant output LEDs
* Optional seven-segment display for debugging

