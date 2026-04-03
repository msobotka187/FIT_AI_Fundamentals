# 🧩 AI Sudoku Solver: Integer Programming

[![Julia](https://img.shields.io/badge/Language-Julia_1.11+-9558B2?style=flat&logo=julia)](https://julialang.org/)
[![Optimization](https://img.shields.io/badge/Solver-HiGHS_via_JuMP-blue)](https://jump.dev/)
[![Graphics](https://img.shields.io/badge/Graphics-GLMakie-orange)](https://makie.juliaplots.org/)

This project explores the limits of heuristic search algorithms and the absolute power of mathematical optimization by solving generalized $N \times N$ Sudoku puzzles. Originally developed for the **Introduction to Artificial Intelligence** course, it demonstrates how shifting a problem from local search / backtracking to **Integer Linear Programming (ILP)** allows us to solve massive, computationally intractable grids (up to $25 \times 25$) in seconds.

## ✨ Key Features

* **Generalized $N \times N$ Architecture:** Fully supports standard $9 \times 9$ puzzles, as well as massive $16 \times 16$ and $25 \times 25$ generalized grids.
* **100% Guaranteed Exact Solver:** Utilizes `JuMP.jl` and the `HiGHS` optimizer to model Sudoku as an **Integer Programming Constraint Satisfaction Problem** (CSP).
* **Smart Puzzle Generation:** Uses highly optimized, memory-efficient backtracking (with bit-matrix state tracking) for standard grids, and an "IP Hack" (leveraging the solver itself) to generate massive $25 \times 25$ puzzles without falling into deep recursive traps.
* **Interactive Visualizations:** Built-in graphical interface using `GLMakie` to visualize the unsolved and solved states, automatically highlighting solver-deduced cells vs. original clues.
* **Academic Benchmarking:** Integrated `BenchmarkTools` suite to empirically measure and compare the exponential time complexity of puzzle generation vs. the polynomial scaling of the IP solver.

## 📂 Project Structure

```text
.
├── Project.toml & Manifest.toml  # Isolated Julia environment and dependencies
├── src/
│   ├── Sudoku.jl                 # Main module entry point
│   ├── Generator.jl              # Puzzle generation (Backtracking & IP methods)
│   ├── Solver.jl                 # Integer Programming formulation (JuMP)
│   ├── Visualizer.jl             # GLMakie graphical rendering
│   ├── Benchmark.jl              # Performance measurement suite
│   └── main.jl                   # Executable script showcasing the pipeline
└── test/
    └── runtests.jl               # Comprehensive test suite (edge cases, math proofs)
