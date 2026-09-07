# CSCib - Control of Cyber-Physical Systems

IST · DEEC / Systems, Decision and Control · 2026/2027, 1st semester · 6 ECTS
**Shift: CSCibL03**

- **Coordinator:** Sérgio Pequito
- **Lecturer:** José Gaspar
- **Teaching monitor:** Rita Mota

## Dates

- **Report deadline (CSCibL03):** 23:59 on **7 December** (day of session L12, week 14)
- **Exam:** 15 January 2027, 10:30

## Assessment

- 5 MAP30 tests: **60%** (best 3 grades count)
- Project / laboratory: **40%** (collective validation factor + individual term)
- Full rules, minimum grades, absences, resit periods and AI policy: `CCPS_Metodos_de_Avaliacao_2026-27_PT.pdf` / `..._EN.pdf` (Fénix)

## Laboratory

- **Guide:** `Laboratories_Control_of_CPS_semester.pdf` (this repo)
- 13 sessions of 1h30 (L1-L13), mapped to lecture modules
- Part I - Identification (Q1, Q2, Q3) · Part II - LQG control (Q4)
- **Report template:** `Template_report.zip` (this repo, LaTeX)
- Max. 15 pages from Introduction to Conclusions. Cover, table of contents, declaration pages and code appendix don't count
- Every function you create goes in the appendix. AI and originality declarations are mandatory

## Laboratory sessions

One link per session. Replace `_` with the Google Docs URL. Weeks below are for shift **CSCibL03**.

| Session | Week | Focus | Notes |
|---|---|---|---|
| L1  | 1  | Group formation, safety briefing, walkthrough of the guide | [Doc](https://docs.google.com/document/d/1_0-e44QuGS5KOAtqIu-X_EtNi_SHTo455gdAAcgwZ2s/edit?usp=sharing) |
| L2  | 2  | Simulink, signal generation, D/A, first motor command | _ |
| L3  | 3  | A/D, sensor readings, calibration of `Kp` and `Ke` | _ |
| L4  | 4  | Excitation signal design and collection of identification data | _ |
| L5  | 6  | Data processing, ARMAX identification, model order selection | _ |
| L6  | 7  | Integrator, state-space conversion, model validation | _ |
| L7  | 9  | Review of the identification: filter pole, orders, sampling interval | _ |
| L8  | 10 | LQ design, root-square locus in `R` | _ |
| L9  | 11 | Kalman filter, LTR, LQG simulation | _ |
| L10 | 12 | Real-time LQG diagram, pre-filter, first tests on the plant | _ |
| L11 | 13 | Tuning on the plant: effect of `R` and `Rv` | _ |
| L12 | 14 | Final closed-loop measurements. **Report due 23:59 (7 Dec)** | _ |
| L13 | 15 | Final laboratory assessment: collective and individual validation | _ |

## Companion text

- Summary of state feedback design, referenced in Section 5 of the guide. Supplementary reading, not required
- **EN:** `ApontamentosRLVEen.pdf` (this repo)
- **PT:** available on Fénix

## ccpsGPT (course tutor)

- **Link:** https://tinyurl.com/ccpsGPT
- Knows the syllabus, the modules and the laboratory work. Generates exercises with solutions
- Useful ways to use it: ask for the same explanation twice, typical problems per module, worked solutions with a deliberate error to find, challenge assumptions (`R -> 0`?), common errors and their symptoms, a timed 30-minute problem
- **Limits:** can be confidently wrong. Lectures, videos and the lab guide take precedence
- **Prohibited** in MAP30s, the exam and the final laboratory assessment (red-level components)

## Supplementary material (optional, Module 5 / session L9)

- Random disturbance models: `Random Disturbances - Models and Analysis.pdf` (Modules 3.5 and 5.1)
- Kalman filter optimality, minimum-variance: `dtKFopt.pdf` (Module 5.6)
- Discrete-time Kalman filter, recursive derivation: `Derivation of the discrete-time Kalman filter.pdf` (Module 5.6)
- Estimator survey, Kalman to particle filters: `Bayesian Filtering From Kalman Filters to Particle Filters, and Beyond.pdf` (beyond the syllabus)

## Learning outcomes

- **LO1** Structure and components of computer-controlled systems
- **LO2** Discrete-time modelling: difference equations, transfer functions, state-space
- **LO3** System identification from input-output data
- **LO4** Stability, controllability and observability, continuous vs. discrete
- **LO5** Digital controllers: pole placement, LQR, LQG
- **LO6** Digital estimators: pole placement, Kalman filters
- **LO7** Model Predictive Control (MPC)
