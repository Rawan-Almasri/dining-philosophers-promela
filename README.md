# Dining Philosophers Problem
Dining Philosophers Problem modeled in Promela and verified with the SPIN Model Checker using the Butler algorithm.

# Dining Philosophers Problem – Promela & SPIN

This project models and verifies the classic **Dining Philosophers Problem** using **Promela** and the **SPIN Model Checker**, as part of a Formal Methods course project (M.Sc. Software Engineering – University of Damascus).

##Project Overview

The goal of this project is not only to implement a solution, but to **formally verify its correctness** under concurrent execution.

Instead of relying on testing, we use **model checking** to explore all possible system states and ensure correctness under concurrency constraints.

The solution is based on the **Butler Algorithm**, where a controller (butler) manages access to shared resources (forks) to prevent synchronization issues.

---

## 🍽️ Problem Description

The Dining Philosophers Problem consists of:
- 5 philosophers sitting around a circular table
- 5 forks placed between them
- Each philosopher needs 2 forks (left and right) to eat
- Philosophers alternate between **thinking** and **eating**

---

## ⚠️ Concurrency Issues Addressed

This problem is used to illustrate common concurrency problems:

- Deadlock
- Livelock
- Starvation
- Race Condition
- Mutual Exclusion
- Synchronization

---

##Approach

We model the system using:
- **Promela (Process Meta Language)**
- **SPIN Model Checker**

The system is modeled as concurrent processes interacting over shared resources.

We verify the following properties:
- Termination
- Deadlock Freedom
- Starvation Freedom (Fairness)
- Mutual Exclusion
- Safety

---

##Verification

Using SPIN, we exhaustively explored all reachable states of the system to ensure that:

✔ No deadlock occurs  
✔ No race conditions exist  
✔ All philosophers eventually get a chance to eat  
✔ Shared resources are accessed safely  

---

##Faulty Scenarios (for educational purposes)

To better understand concurrency issues, additional models were created:

- `deadlock.pml` → Deadlock scenario
- `livelock.pml` → Livelock scenario
- `starvation.pml` → Starvation scenario
- `race_condition.pml` → Race condition scenario

---

## 📁 Project Structure
├── Philosophers-Solution.pml # Correct solution (Butler algorithm)
├── Philosophers-Deadlock.pml # Deadlock simulation
├── Philosophers-Livelock.pml # Livelock simulation
├── Philosophers-Starvation.pml # Starvation simulation
├── Philosophers-Race.pml # Race condition simulation
├── requirements.txt               # Project requirements
└── README.md





---

##Tools Used

- Promela
- SPIN Model Checker

---

##Academic Context

This project was developed as part of the **Formal Methods / Modeling and Formal Techniques** course in the Master's program in Software Engineering at the University of Damascus.

---

## Key Insight

Instead of asking:  
> “Does the program work in tests?”

We ask:  
> “Can we prove that it is correct for all possible executions?”

---

## Author

Developed as a university project (team work) focusing on formal verification of concurrent systems.
