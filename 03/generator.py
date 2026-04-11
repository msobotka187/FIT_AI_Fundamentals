import os
import random

def generate_problem(filename, size_x, size_y, tower_height, print_err=True):
    # General checks
    if not os.path.isfile("domain.pddl"):
        if print_err: print("Fatal Error: file domain.pddl not found.")
        return False

    if (size_x < 0 or size_y < 0):
        if print_err: print(f"Error: Invalid size - {size_x}x{size_y}.")
        return False

    if (size_x < 2 or size_y < 2):
        if print_err: print(f"Error: The grid ({size_x}x{size_y}) is too small (minimum: 2x2).")
        return False

    if (tower_height < 2):
        if print_err: print(f"Error: tower_height: {tower_height} is too small (minimum height: 2)")
        return False

    if tower_height > size_x * size_y:
        if print_err: print("Error: Not enough floor space to scatter all blocks initially!")
        return False

    # Actuall generation
    with open(filename, 'w') as f:
        # Header
        f.write("(define (problem minecraft-build)\n")
        f.write("  (:domain minecraft)\n\n")

        # Object Declaration
        f.write("  (:objects\n    ")
        for x in range(size_x):
            for y in range(size_y):
                f.write(f"loc_{x}_{y} ")
        f.write("- location\n    ")

        # Block Generation
        for i in range(tower_height):
            f.write(f"b{i + 1} ")
        f.write("- block\n  )\n\n")

        # Initial State
        f.write("  (:init\n")
        f.write("    (handempty)\n")
        f.write("    (at-robot loc_0_0)\n") # Robot starts at 0, 0

        # Adjacency Generation (2D Grid)
        for x in range(size_x):
            for y in range(size_y):
                current_loc = f"loc_{x}_{y}"

                neighbors = []
                if x > 0: neighbors.append((x-1, y))
                if x < size_x-1: neighbors.append((x+1, y))
                if y > 0: neighbors.append((x, y-1))
                if y < size_y-1: neighbors.append((x, y+1))

                for nx, ny in neighbors:
                    f.write(f"    (adjacent {current_loc} loc_{nx}_{ny})\n")

        # Scatter Initial Blocks
        # Get all grid locations except (0,0) where the robot starts
        available_locs = [(x,y) for x in range(size_x) for y in range(size_y) if (x,y) != (0,0)]

        block_positions = []
        for i in range(tower_height):
            bx, by = available_locs[i]
            block_positions.append((bx, by))
            # The block is at the location, on the floor, and has nothing on top of it
            f.write(f"    (at-block b{i+1} loc_{bx}_{by})\n")
            f.write(f"    (on-ground b{i+1})\n")
            f.write(f"    (clear b{i+1})\n")

        # Mark remaining locations as free ground
        for x in range(size_x):
            for y in range(size_y):
                if (x, y) not in block_positions:
                    f.write(f"    (free-ground loc_{x}_{y})\n")

        f.write("  )\n\n")

        # Goal Generation
        f.write("  (:goal (and\n")

        # We want to build the tower somewhere in the grid
        target_loc = f"loc_{random.randint(0, size_x - 1)}_{random.randint(0, size_y - 1)}"

        # The first block needs to be on the ground at the target location
        f.write(f"    (at-block b1 {target_loc})\n")
        f.write("    (on-ground b1)\n")

        # The rest of the blocks need to be stacked on top of each other
        for i in range(1, tower_height):
            f.write(f"    (at-block b{i+1} {target_loc})\n")
            f.write(f"    (on b{i+1} b{i})\n")

        f.write("  ))\n")
        f.write(")\n")
        return True


if __name__ == "__main__":
    def testing(filename, size_x, size_y, tower_height, print_err=True):
        return generate_problem(filename, size_x, size_y, tower_height, print_err)

    print("--- RUNNING NEGATIVE TESTS ---")
    print_error = False

    # Fail testing - grid size
    coords = [(-10, -10), (-3, 3), (5, -5), (0, 0), (4, 0), (0, 7), (1, 1)]
    for x, y in coords:
        filename = f"fail-grid_{x}_{y}.pddl"
        if testing(filename, x, y, 3, print_err=print_error):
            print(f"❌ FAILED: Grid size {x}x{y} should have been rejected!")
        else:
            print(f"✅ PASSED: Grid size {x}x{y} successfully rejected.")

    # Fail testing - tower_height
    tower_heights = [-5, 0, 1, 69]
    for i, h in enumerate(tower_heights):
        filename = f"fail-height_{i + 1}.pddl"
        if testing(filename, 5, 5, h, print_err=print_error):
            print(f"❌ FAILED: Tower height {h} should have been rejected!")
        else:
            print(f"✅ PASSED: Tower height {h} successfully rejected.")

    print("\n--- RUNNING POSITIVE TESTS ---")
    print_error = True

    # Try generating something
    params = [(3, 3, 5), (7, 5, 5), (7, 8, 9), (12, 11, 27), (21, 25, 289)]
    for i, (x, y, h) in enumerate(params):
        filename = f"test_problem{i + 1}.pddl"
        if testing(filename, x, y, h, print_err=print_error):
            print(f"✅ PASSED: Successfully generated {x}x{y} grid with {h} blocks!")
            os.remove(filename) # Clean up the test file so your folder doesn't get messy
        else:
            print(f"❌ FAILED: Could not generate {x}x{y} grid with {h} blocks.")


    print("\n--- GENERATING FILES ---")
    print_error = True

    params = [(3, 3, 3), (5, 6, 5), (7, 7, 3)]
    for i, (x, y, h) in enumerate(params):
        filename = f"problem{i + 1}.pddl"
        if generate_problem(filename, x, y, h, print_err=print_error):
            print(f"✅ PASSED: Successfully generated {x}x{y} grid with {h} blocks!")
        else:
            print(f"❌ FAILED: Could not generate {x}x{y} grid with {h} blocks.")
