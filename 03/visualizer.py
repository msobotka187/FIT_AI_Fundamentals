import re
import json
import sys
import os

def parse_problem(problem_file):
    with open(problem_file, 'r') as f:
        content = f.read()

        # Get locations
        locs = re.findall(r'loc_(\d+)_(\d+)', content)
        max_x = max([int(x) for x, y in locs]) + 1
        max_y = max([int(y) for x, y in locs]) + 1

        # Safely split the file into Initial State and Goal State sections
        if '(:goal' in content:
            init_text, goal_text = content.split('(:goal', 1)
        else:
            init_text = content
            goal_text = ""

        # Get initial state
        init_state = {
            'robot': None,
            'holding': None,
            'grid': {
                f"{x},{y}": [] for x in range(max_x) for y in range(max_y)
            }
        }

        robot_match = re.search(r'\(at-robot loc_(\d+)_(\d+)\)', init_text)
        if robot_match:
            init_state['robot'] = [int(robot_match.group(1)), int(robot_match.group(2))]

        for block, x, y in re.findall(r'\(at-block (\w+) loc_(\d+)_(\d+)\)', init_text):
            init_state['grid'][f"{x},{y}"].append(block)

        # Get goal state
        goal_state = {
            'robot': None,
            'holding': None,
            'grid': {
                f"{x},{y}": [] for x in range(max_x) for y in range(max_y)
            }
        }

        for block, x, y in re.findall(r'\(at-block (\w+) loc_(\d+)_(\d+)\)', goal_text):
            goal_state['grid'][f"{x},{y}"].append(block)

        return max_x, max_y, init_state, goal_state

def parse_plan_and_simulate(plan_file, max_x, max_y, init_state):
    with open(plan_file, 'r') as f:
        lines = f.readlines()

        # Deep copy init_state
        curr_state = json.loads(json.dumps(init_state))
        history = [json.loads(json.dumps(curr_state))]
        steps = ["Start"]

        for line in lines:
            line = line.strip().lower()
            if not line or line.startswith(';'): continue

            action_str: str = re.sub(r'^\(|\).*$', '', line).strip()
            parts: list[str] = action_str.split()
            if not parts: continue

            action = parts[0]
            steps.append(action_str)

            if action == "move":
                _, _from, to = parts
                tx, ty = map(int, to.replace('loc_', '').split('_'))
                curr_state['robot'] = [tx, ty]
            elif action == "pick-up-from-ground":
                _, b, loc, _ = parts
                lx, ly = map(int, loc.replace('loc_', '').split('_'))
                curr_state['grid'][f"{lx},{ly}"].remove(b)
                curr_state['holding'] = b
            elif action == "pick-up-from-block":
                _, top, _bottom, loc, _ = parts
                lx, ly = map(int, loc.replace('loc_', '').split('_'))
                curr_state['grid'][f"{lx},{ly}"].remove(top)
                curr_state['holding'] = top
            elif action == "put-down-on-ground" or action == "put-down-on-block":
                b = curr_state['holding']
                loc = parts[-2]
                lx, ly = map(int, loc.replace('loc_', '').split('_'))
                curr_state['grid'][f"{lx},{ly}"].append(b)
                curr_state['holding'] = None
            else:
                print(f"action: {action} is not a valid action.")

            history.append(json.loads(json.dumps(curr_state)))

        return steps, history

def generate_html(output_file, max_x, max_y, init_state, goal_state, steps, history):
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>PDDL Plan Visualizer</title>
        <style>
            body {{ font-family: Arial, sans-serif; background: #f4f4f9; margin: 0; padding: 20px; display: flex; flex-direction: column; align-items: center; }}
            .container {{ display: flex; gap: 20px; width: 100%; max-width: 1200px; }}
            .window {{ background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); flex: 1; }}
            h2 {{ text-align: center; font-size: 1.2em; color: #333; }}
            .grid {{ display: grid; grid-template-columns: repeat({max_x}, 50px); grid-template-rows: repeat({max_y}, 50px); gap: 5px; justify-content: center; margin-top: 20px; }}
            .cell {{ width: 50px; height: 50px; background: #eee; border: 1px solid #ccc; display: flex; align-items: center; justify-content: flex-start; flex-direction: column-reverse; position: relative; font-size: 10px; font-weight: bold; padding-bottom: 2px; }}
            .block {{ background: #4CAF50; color: white; width: 40px; border-radius: 3px; text-align: center; margin-top: 2px; padding: 2px 0; }}
            .robot {{ position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #FF5722; color: white; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; z-index: 10; font-size: 12px; }}
            .holding {{ color: #FF5722; font-weight: bold; text-align: center; height: 20px; margin-top: 10px; }}
            .controls {{ display: flex; justify-content: center; gap: 10px; margin-top: 20px; }}
            button {{ padding: 10px 15px; cursor: pointer; border: none; background: #2196F3; color: white; border-radius: 4px; }}
            button:disabled {{ background: #ccc; }}
            #step-info {{ text-align: center; margin-top: 15px; font-style: italic; color: #555; height: 40px; }}
        </style>
    </head>
    <body>
        <h1>Robot Block Stacking Visualizer</h1>
        <div class="container">
            <div class="window">
                <h2>Initial State</h2>
                <div class="grid" id="grid-init"></div>
            </div>

            <div class="window">
                <h2>Simulation (Step <span id="step-counter">0</span>)</h2>
                <div class="holding" id="sim-holding">Holding: None</div>
                <div class="grid" id="grid-sim"></div>
                <div id="step-info">Start</div>
                <div class="controls">
                    <button onclick="prevStep()" id="btn-prev" disabled>Previous</button>
                    <button onclick="nextStep()" id="btn-next">Next</button>
                </div>
            </div>

            <div class="window">
                <h2>Goal State</h2>
                <div class="grid" id="grid-goal"></div>
            </div>
        </div>

        <script>
            const max_x = {max_x};
            const max_y = {max_y};
            const initState = {json.dumps(init_state)};
            const goalState = {json.dumps(goal_state)};
            const history = {json.dumps(history)};
            const steps = {json.dumps(steps)};
            let currentStep = 0;

            function drawGrid(containerId, state) {{
                const container = document.getElementById(containerId);
                container.innerHTML = '';

                for (let y = 0; y < max_y; y++) {{
                    for (let x = 0; x < max_x; x++) {{
                        const cell = document.createElement('div');
                        cell.className = 'cell';

                        // Draw Blocks
                        const blocks = state.grid[`${{x}},${{y}}`] || [];
                        blocks.forEach(b => {{
                            const blockEl = document.createElement('div');
                            blockEl.className = 'block';
                            blockEl.innerText = b;
                            cell.appendChild(blockEl);
                        }});

                        // Draw Robot
                        if (state.robot && state.robot[0] === x && state.robot[1] === y) {{
                            const robotEl = document.createElement('div');
                            robotEl.className = 'robot';
                            robotEl.innerText = 'R';
                            cell.appendChild(robotEl);
                        }}

                        container.appendChild(cell);
                    }}
                }}
            }}

            function updateSimulation() {{
                drawGrid('grid-sim', history[currentStep]);
                document.getElementById('step-counter').innerText = currentStep;
                document.getElementById('step-info').innerText = steps[currentStep];

                const holding = history[currentStep].holding;
                document.getElementById('sim-holding').innerText = holding ? `Robot holding: ${{holding}}` : 'Robot hands empty';

                document.getElementById('btn-prev').disabled = currentStep === 0;
                document.getElementById('btn-next').disabled = currentStep === history.length - 1;
            }}

            function nextStep() {{ if (currentStep < history.length - 1) {{ currentStep++; updateSimulation(); }} }}
            function prevStep() {{ if (currentStep > 0) {{ currentStep--; updateSimulation(); }} }}

            // Init
            drawGrid('grid-init', initState);
            drawGrid('grid-goal', goalState);
            updateSimulation();
        </script>
    </body>
    </html>
    """
    with open(output_file, 'w') as f:
        f.write(html_content)
    print(f"✅ Dashboard successfully generated: {output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python visualizer.py <problem.pddl> <plan.txt>")
        sys.exit(1)

    prob_file = sys.argv[1]
    plan_file = sys.argv[2]
    out_file  = "visualizer.html"

    if not os.path.exists(prob_file) or not os.path.exists(plan_file):
        print("Error: Input files not found.")
        sys.exit(1)

    mx, my, init_state, goal_state = parse_problem(prob_file)
    actions, history = parse_plan_and_simulate(plan_file, mx, my, init_state)
    generate_html(out_file, mx, my, init_state, goal_state, actions, history)
