# Project Proposal: FPGA-Based RSU Controller for Autonomous Intersection Reservation

## 1. Project Title

FPGA-Based RSU Intersection Reservation Controller for Autonomous Vehicles

## 2. Motivation

Autonomous vehicles require safe and deterministic coordination when passing through an intersection. In a conventional system, traffic lights control human drivers. In this project, the control is performed by an RSU controller that sends direct permission signals to autonomous cars.

The goal is to design a hardware-level RSU controller in VHDL and validate the logic on an FPGA board. The system focuses on timing, priority, fairness, and conflict-free access to the intersection square.

## 3. System Scenario

The system represents a four-way intersection with four possible incoming directions:

* North
* South
* East
* West

The North-South road is considered the main road.
The East-West road is considered the side road.

The center of the intersection is modeled as a square-shaped critical zone. A vehicle must receive permission from the RSU before entering this critical zone.

## 4. System Inputs

The RSU receives four request inputs:

```text
N_req = request from North vehicle
S_req = request from South vehicle
E_req = request from East vehicle
W_req = request from West vehicle
```

Grouped requests:

```text
Main_req = N_req OR S_req
Side_req = E_req OR W_req
```

## 5. System Outputs

The RSU produces four grant outputs:

```text
N_grant = permission for North vehicle
S_grant = permission for South vehicle
E_grant = permission for East vehicle
W_grant = permission for West vehicle
```

Grouped grants:

```text
Main_grant = N_grant OR S_grant
Side_grant = E_grant OR W_grant
```

## 6. Timing Requirements

The following timing parameters are used:

```text
T_cross = 5 s
T_main = 20 s
T_side = 10 s
W_side_max = 20 s
```

Meaning:

* A vehicle needs 5 seconds to clear the intersection square.
* The main road can be served for a maximum of 20 seconds.
* The side road can be served for a maximum of 10 seconds.
* The side road must not wait more than 20 seconds.

## 7. Functional Requirements

FR1: The RSU shall receive vehicle request signals from North, South, East, and West.

FR2: The RSU shall group North and South as the main road.

FR3: The RSU shall group East and West as the side road.

FR4: The RSU shall grant the main road first when both main and side roads request access.

FR5: The RSU shall grant the side road immediately when the main road has no waiting vehicle.

FR6: The RSU shall ensure that the side road does not wait more than 20 seconds.

FR7: The RSU shall not allow main road and side road vehicles to enter the intersection square at the same time.

FR8: The RSU shall use a 5-second crossing time before allowing a conflicting road group.

FR9: The RSU shall serve the main road for a maximum of 20 seconds when the side road is waiting.

FR10: The RSU shall serve the side road for a maximum of 10 seconds before returning to the main road if main vehicles are waiting.

## 8. Non-Functional Requirements

NFR1: The design shall be implemented in VHDL.

NFR2: The design shall be suitable for FPGA implementation.

NFR3: The design shall be readable and modular.

NFR4: The design shall be testable using a VHDL testbench.

NFR5: The design shall be observable on FPGA using LEDs or seven-segment display.

NFR6: The design shall be simple enough to be transferred later to a custom PCB/evaluation board concept.

## 9. Main Safety Equation

The main safety rule is:

```text
(N_grant OR S_grant) AND (E_grant OR W_grant) = 0
```

This means that the RSU must never grant the main road and side road at the same time.

## 10. Main Fairness Equation

The side road waiting time must satisfy:

```text
side_wait_timer <= 20 s
```

To guarantee this, the last main road grant when the side road is waiting must occur at:

```text
latest_main_grant = W_side_max - T_cross
latest_main_grant = 20 s - 5 s = 15 s
```

Therefore, if the side road has already waited 15 seconds, the RSU must stop granting new main road vehicles and allow the current main vehicle to clear the intersection.

## 11. Proposed FSM States

The RSU controller will use the following finite state machine states:

```text
IDLE
MAIN_SERVICE
MAIN_CLEAR
SIDE_SERVICE
SIDE_CLEAR
```

State meaning:

* `IDLE`: No vehicle request is active.
* `MAIN_SERVICE`: RSU grants main road vehicles.
* `MAIN_CLEAR`: RSU stops new main grants and waits for the intersection to clear.
* `SIDE_SERVICE`: RSU grants side road vehicles.
* `SIDE_CLEAR`: RSU stops new side grants and waits for the intersection to clear.

## 12. FPGA Prototype Plan

The FPGA prototype will use:

* Switches or buttons for vehicle requests
* LEDs for grant outputs
* Clock divider for visible timing
* Reset button for restarting the controller
* Optional seven-segment display for state or timer debugging

## 13. Verification Plan

The design will be verified in QuestaSim using a VHDL testbench. The testbench will apply different input combinations and check output behavior.

Important test cases:

1. No car request
2. Only North request
3. Only South request
4. Only East request
5. Only West request
6. North and South request together
7. East and West request together
8. Main and side request together
9. Side road waiting reaches 15 seconds
10. Side road receives grant before or at 20 seconds
11. Main and side grants are never active together

## 14. PCB Concept

The future PCB/evaluation board concept will include only the required hardware components:

* FPGA
* Clock source
* Reset circuit
* Power supply
* Programming interface
* Input switches or buttons
* Output LEDs
* Optional debug display

The PCB design deliverables will include schematic, layout, BOM, 3D view, and Gerber files.

## 15. Expected Outcome

At the end of the project, the RSU controller should be implemented and validated on FPGA. The system should demonstrate safe and timed reservation logic for autonomous vehicles at a four-way intersection.
