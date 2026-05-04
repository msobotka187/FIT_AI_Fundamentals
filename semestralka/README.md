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

First, download the project repository to your local machine:

### Step 1:
```bash
git clone https://gitlab.fit.cvut.cz/sobotma8/bi-zum-ls2026-sobotma8.git
```
```bash
cd bi-zum-ls2026-sobotma8/semestralka
```

From this point forward, all commands should be executed inside the Julia REPL. Start Julia in your terminal by typing:
```bash
julia
```

Once inside the Julia REPL, activate the project environment and instantiate the packages. This ensures all heavy math and graphics dependencies (JuMP, HiGHS, GLMakie) are properly installed:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

## 🎮 Usage
To run the interactive visualizer and test the solver, simply include the main script and call the `run()` function.
- Note on TTFX (Time To First Execution): The first time you run the visualizer or solver, Julia will precompile the heavy math and graphics libraries. This may take 10-30 seconds. Subsequent runs in the same session will be nearly instantaneous.

```julia
include("src/main.jl")

# Run different sizes by passing the dimension as an integer:
run(9)  # Default 9x9 - Super fast
run(16) # 16x16 puzzle - Still fast
run(25) # 25x25 puzzle - Takes around a minute to solve
```
*(Larger puzzles are not recommended if you have limited computational capacity or RAM, as the graphics rendering becomes highly demanding).*

## 🧪 Testing
The project includes a robust test suite that verifies data structure integrity, handles edge cases (e.g., negative matrix sizes, unsolvable constraints), and mathematically proves that the solver's output is a legally valid Sudoku.

To run the automated tests, simply use Julia's package manager:
```julia
using Pkg
Pkg.activate(".")
Pkg.test()
```

## 📊 Benchmarks & The 25x25 Challenge
A standard $9 \times 9$ Sudoku has $6.67 \times 10^{21}$ valid grids. A $25 \times 25$ grid pushes the limits of standard computer science hardware due to Combinatorial Explosion.\
Using the Integer Programming Solver to generate the initial grid via mathematical constraints, the $25 \times 25$ puzzle was generated and solved in **~100 seconds**.

To run the benchmarking suite and observe performance metrics locally:
```julia
using Pkg
Pkg.activate(".")
include("src/Benchmark.jl")

using .SudokuBenchmark
run_benchmarks()
```
