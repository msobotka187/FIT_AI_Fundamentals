#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <raylib.h>

namespace Constants {
  // === Window dimensions ===
  inline constexpr int    SCREEN_WIDTH        = 1200;
  inline constexpr int    SCREEN_HEIGHT       = 800;
  inline constexpr double MARGIN_X            = 10.0;
  inline constexpr double MARGIN_Y            = 10.0;

  // === Drawing ===

  // Reset Button
  inline constexpr float  BTN_WIDTH           = 100.0f;
  inline constexpr float  BTN_HEIGHT          = 30.0f;
  inline constexpr float  BTN_MARGIN_Y        = 20.0f;
  inline constexpr float  BTN_START_X         = (SCREEN_WIDTH / 2.0f) - (BTN_WIDTH / 2.0f);
  inline constexpr float  BTN_START_Y         = SCREEN_HEIGHT - BTN_MARGIN_Y - BTN_HEIGHT;

  inline constexpr float  BTN_CENTER_X        = BTN_START_X + (BTN_WIDTH  / 2.0f);
  inline constexpr float  BTN_CENTER_Y        = BTN_START_Y + (BTN_HEIGHT / 2.0f);

  inline constexpr Rectangle BTN_BOUNDS = {
    BTN_START_X, BTN_START_Y, BTN_WIDTH, BTN_HEIGHT
  };

  inline constexpr Color  BTN_UNHOVERED_COLOR = GRAY;
  inline constexpr Color  BTN_HOVERED_COLOR   = LIGHTGRAY;
  inline constexpr Color  BTN_OUTLINE_COLOR   = BLACK;

  // Reset Button Text
  inline const char *     BTN_TEXT            = "Restart (R)";
  inline constexpr int    BTN_FONT_SIZE       = 14;
  inline constexpr Color  BTN_TEXT_COLOR      = BLACK;

  // Text
  inline constexpr int    MARGIN_TEXT         = 5;
  inline constexpr int    INFO_FONT_SIZE      = 20;

  inline constexpr int    TEMP_TEXT_X         = MARGIN_X;
  inline constexpr int    TEMP_TEXT_Y         = MARGIN_Y;
  inline constexpr int    TEMP_FONT_SIZE      = INFO_FONT_SIZE;

  inline constexpr int    DIST_TEXT_X         = MARGIN_X;
  inline constexpr int    DIST_TEXT_Y         = TEMP_TEXT_Y + TEMP_FONT_SIZE + MARGIN_TEXT;
  inline constexpr int    DIST_FONT_SIZE      = INFO_FONT_SIZE;

  inline constexpr int    DONE_TEXT_X         = MARGIN_X;
  inline constexpr int    DONE_TEXT_Y         = DIST_TEXT_Y + DIST_FONT_SIZE + MARGIN_TEXT;
  inline constexpr int    DONE_FONT_SIZE      = INFO_FONT_SIZE;

  // Widths
  inline constexpr float  CITY_CIRCLE_WIDTH   = 4.0f;
  inline constexpr float  CURR_ROUTE_WIDTH    = 2.0f;
  inline constexpr float  BEST_ROUTE_WIDTH    = 2.0f;
  inline constexpr float  BTN_OUTLINE_WIDTH   = 2.0f;

  // Colors
  inline constexpr Color  BACKGROUND_COLOR    = DARKGRAY;

  inline constexpr Color  CITY_COLOR          = BLUE;
  inline constexpr Color  CURR_ROUTE_COLOR    = RAYWHITE;
  inline constexpr Color  BEST_ROUTE_COLOR    = LIME;

  inline constexpr Color  TEMP_TEXT_COLOR     = RAYWHITE;
  inline constexpr Color  DIST_TEXT_COLOR     = LIME;
  inline constexpr Color  DONE_TEXT_COLOR     = RED;
  inline constexpr Color  RESET_TEXT_COLOR    = BLACK;

  // === Graph ===
  inline constexpr double MARGIN_UP           = DONE_TEXT_Y + DONE_FONT_SIZE + MARGIN_TEXT;
  inline constexpr double MARGIN_DOWN         = BTN_HEIGHT + BTN_MARGIN_Y;
  inline constexpr double MARGIN_LEFT         = 3.0 * MARGIN_X;
  inline constexpr double MARGIN_RIGHT        = 3.0 * MARGIN_X;

  // Cities
  inline constexpr int    NUM_CITIES          = 50;

  // Positions
  inline constexpr double GEN_START_X         = MARGIN_LEFT;
  inline constexpr double GEN_END_X           = SCREEN_WIDTH - MARGIN_RIGHT;
  inline constexpr double GEN_START_Y         = MARGIN_UP;
  inline constexpr double GEN_END_Y           = SCREEN_HEIGHT - MARGIN_DOWN - 2.0 * MARGIN_TEXT;

  // === Simulated Annealing ===
  inline constexpr double START_TEMP          = 1000.0;
  inline constexpr double MIN_TEMP            = 1.0;
  inline constexpr double COOLING_RATE        = 0.99;
  inline constexpr int    ITERATIONS_PER_STEP = 100;
}

#endif // CONSTANTS_H
