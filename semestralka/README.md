# 🧩 Sudoku Solver: Integer Programming

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
```


## 🚀 Installation & Setup

This project uses Julia's built-in package manager to guarantee a reproducible environment. You do not need to install heavy libraries manually.

### Step 1:
```bash
git clone https://gitlab.fit.cvut.cz/sobotma8/bi-zum-ls2026-sobotma8.git
```
```bash
cd bi-zum-ls2026-sobotma8/semestralka
```

### Step 2:
```bash
julia
```

### Step 3:
```julia
using Revise
includet("src/main.jl")
run()
```
Note: `includet` is not a typo, the **t** at the end is intended.\
You can then try different sizes just by passing the size as a parameter:

```julia
run(9)  # Default - Super fast
run(16) # 16x16 puzzle - Still fast
run(25) # 25x25 - takes around a minute to solve
```
Larger puzzles are not recommended due to computational capacity.

## 🎮 Usage

To run the full demonstration (Generates a puzzle -> Opens GUI -> Solves via IP -> Opens Solved GUI):
```bash
julia --project=. src/main.jl
```

> Note on **TTFX** (Time To First Execution): The first time you run the visualizer or solver, Julia will precompile the heavy math and graphics libraries. This may take 10-30 seconds. Subsequent runs in the same REPL session are nearly instantaneous.

## 🧪 Testing
The project includes a robust test suite that verifies data structure integrity, handles edge cases (e.g., negative matrix sizes, unsolvable constraints), and mathematically proves that the solver's output is a legally valid Sudoku.

To run the tests:
```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

## 📊 Benchmarks & The 25x25 Challenge
A standard $9 \times 9$ Sudoku has $6.67 \times 10^{21}$ valid grids. A $25 \times 25$ grid pushes the limits of standard computer science hardware due to Combinatorial Explosion.\
Using the Integer Programming Solver to generate the initial grid via mathematical constraints, the $25 \times 25$ puzzle was generated and solved in **~100 seconds**.

> Note: $25 \times 25$ only runs in console, the visuals are not able to handle the calculations simultaneously.


To run the benchmarks locally:
```bash
julia --project=. -e 'using Sudoku.SudokuBenchmark; run_benchmarks()'
```
