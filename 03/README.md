# 🧱 PDDL Block Stacking Visualizer

A complete pipeline for generating, solving, and visualizing **3D block stacking problems** using **PDDL** (Planning Domain Definition Language). This project features a custom Python generator, a logic-perfect PDDL domain, and an interactive HTML/JS dashboard that lets you step through the robot's generated plan.

## ✨ Features
* **Interactive Step-by-Step Dashboard**: A self-contained HTML visualizer that renders the initial state, the target goal state, and allows you to animate the robot's generated plan forward and backward.
* **Smart Problem Generator**: A Python script (`generator.py`) that instantly builds valid PDDL problem files. It supports custom grid sizes, random block scattering, random target locations, and dynamic tower heights.
* **PDDL Domain**: A highly refined `domain.pddl` file that correctly abstracts the Z-axis using logical predicates (`on`, `clear`, `on-ground`) instead of rigid 3D coordinates, making it quite fast for automated planners to solve.
* **Zero-Dependency Visualization**: The visualizer relies purely on standard HTML/CSS/JS. No heavy libraries or external web frameworks are required.

## 🛠 The Pipeline
1. **Generation (`generator.py`)**: Defines a 2D grid of size $X \times Y$. It randomly scatters a set of blocks across the floor, assigns the necessary predicates (like `clear` and `free-ground`), and sets a logical goal state (a tower of height $H$ at a random coordinate).
2. **Planning**: Take the `domain.pddl` and the generated `problem.pddl` and use a solver to get a generated plan.
3. **Visualization (`visualizer.py`)**: Parses the raw text output of the solver, reconstructs the grid state at every single timestamp, and injects the history into a reactive HTML dashboard.

## 📋 Requirements & Dependencies
* **Python 3.x**: Required to run the generator and visualizer scripts.
* **PDDL Solver**: An external planner to process the generated files.
* **Web Browser**: Any modern browser (Chrome, Brave, Firefox) to view the generated HTML dashboard.

## 🚀 How to Run
Follow one of these two methods to get the visualizer up and running:

### Option 1: Use included files
When you clone this repository, you should see `problem1.pddl`, `problem2.pddl`, `problem3.pddl`, `plan1.txt`, `plan2.txt`, `plan3.txt` as well as `domain.pddl`, `generator.py` and `visualizer.py`. You can use the visualizer with corresponding problem and plan files. Like:
  ```bash
  python3 visualizer.py problem1.pddl plan1.pddl
  ```

### Option 2: Build it from scratch:
1. **Generate the Problem File**:
  Open your terminal and run the Python generator to create a custom problem (e.g., a 5x5 grid with a 4-block tower).
  ```bash
  python3 generator.py
  ```
  *(Without changes this will create three example files: `problem1.pddl`, `problem2.pddl`, `problem3.pddl` in your directory).*

2. **Solve the Problem:**
  Feed `domain.pddl` and a generated problem file into a PDDL solver of your choice (e.g. [Web Solver](https://editor.planning.domains/#)).\
  Save the result as something like `plan.txt`.

3. **Run the Visualization:**
  Run the script, passing the problem file and generated plan.
  ```bash
  python3 visualizer.py problem.pddl plan.txt
  ```

4. **Watch the Simulation:**
  Open the newly created `visualizer.html` file in your web browser.\
  Use the **Next** and **Previous** buttons to watch the robot navigate the grid, pick up the blocks and build the tower.
  ```bash
  google-chrome visualizer.html
  brave-browser visualizer.html
  firefox visualizer.html
  ```
