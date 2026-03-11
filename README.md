# Godoku
A rudimentary implementation of Sudoku made in Godot that puts code structure first.

<img width="1144" height="638" alt="image" src="https://github.com/user-attachments/assets/92de1286-98eb-4032-aa47-6122b463b092" />

> [!NOTE]
> GUI is not finalized, all art shown is placeholder.

## Features:
- Playable sudoku
- Candidate marking
- Board highlighting
  - Custom highlighting options
- 800,000+ Unique puzzles[^1]
- Ability to play puzzles not included via a [board code](#board-codes)

## Roadmap:
- Major UI overhaul
- Game saving
- Hotkeys
- SFX
- Reworked Board Codes
- Multiple candidate display types
- Multiplayer[^2]
- Multiple puzzle types (N x N board size, killer, crazy, etc.)
- Dynamic board generation[^3]

### Got an idea?
If you've got any ideas that aren't currently outlined in the roadmap and that aren't available in the game itself, make a feature request. Is it on the roadmap? Still let me know, I want to know what people want.

## Board Codes
Board codes take the following format:
81 digit-long string of numbers from 0 to 9, representing digits from top to bottom, left to right in the board.

Example string: 
000200160561309020400006050047060031000802000320070680010600008030507412075008000

Example board:\
\
0 0 0 2 0 0 1 6 0\
5 6 1 3 0 9 0 2 0\
4 0 0 0 0 6 0 5 0\
0 4 7 0 6 0 0 3 1\
0 0 0 8 0 2 0 0 0\
3 2 0 0 7 0 6 8 0\
0 1 0 6 0 0 0 0 8\
0 3 0 5 0 7 4 1 2\
0 7 5 0 0 8 0 0 0

> [!NOTE]
> There is no agreed-upon way to represent sudoku boards as a string, this format will likely change to allow for a more dynamic and customizable sharing / storing of puzzles in the future.

[^1]: This project makes use of [this](https://github.com/grantm/sudoku-exchange-puzzle-bank) public domain sudoku puzzle dataset.
[^2]: This project was at one point refactored to better anticipate a code structure that supports multiplayer, but that "solution" ended up not being viable due to limitations / [security concerns](https://github.com/godotengine/godot-proposals/issues/7653) with the engine. I am still trying to figure out the best way to implement this (let me know).
[^3]: Once functional, this project will generate its puzzles directly, or have a list of puzzles compiled by [this](https://github.com/henbotb/SudokuGenerator) generator. This will also allow for custom generated N x N puzzles.


