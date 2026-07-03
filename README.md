# COAL_FinalProject_rush-hour-taxi
Assembly x86 Taxi Game 
# 🚕 Rush Hour Taxi Game - Assembly x86

A fully-featured taxi game written in x86 Assembly language using the Irvine32 library. Navigate through a 20x20 grid city, pick up passengers, deliver them to their destinations, and survive various challenges across unique game modes!

## 🎮 Game Features

### 4 Exciting Game Modes

| Mode | Description | Objective |
|------|-------------|-----------|
| 🎯 **Classic Mode** | Original game experience | Collect all 3 passengers to win |
| 📈 **Career Mode** | 5 progressive levels | Complete each level with increasing difficulty |
| ⏱️ **Time Attack Mode** | Race against the clock | Score maximum points in 3 minutes |
| ♾️ **Endless Mode** | Survival challenge | Survive as long as possible with increasing difficulty |

### Core Game Mechanics

- 🚕 **Player Taxi**: Control a taxi with two difficulty options
  - 💛 **Yellow Taxi (Easy)**: -4 points per collision
  - ❤️ **Red Taxi (Hard)**: -2 points per collision
  
- 🧑 **Passengers**: 
  - Pick up passengers marked as **(P)** in cyan
  - Deliver to green destinations marked as **(D)**
  - Earn **+10 points** per successful delivery

- 🏢 **Buildings** (#): Navigate around the city's obstacles
- 🚗 **NPC Cars** (C): Avoid other vehicles on the road
- 🌳 **Trees** (@) and 📦 **Boxes** (B): Environmental obstacles to avoid
- 🅿️ **Parking Spots** (H): 
  - Restore **+1 life** (max 3)
  - Earn **+10 bonus points**
  - Each spot can be used once

### Visual & Interactive Elements

- ASCII-based grid rendering with color coding
- Real-time score, lives, and progress tracking
- Animated ASCII art menus and transitions
- Sound effects using system beeps for events

## 🎯 How to Play

### Controls

| Key | Action |
|-----|--------|
| **↑** | Move Up |
| **↓** | Move Down |
| **←** | Move Left |
| **→** | Move Right |
| **Spacebar** | Interact (Pick up/Drop passenger) |
| **ESC** | Exit to Main Menu |

### Basic Strategy

1. **Pick Up Passengers**: Move your taxi onto a passenger **(P)**
2. **Deliver Passengers**: Transport them to their destination **(D)**
3. **Avoid Obstacles**: Stay away from buildings, cars, trees, and boxes
4. **Use Parking Spots**: Drive over **(H)** to heal and earn bonus points
5. **Manage Lives**: Start with 3 lives, lose one on collision
6. **Track Progress**: Monitor score, lives, and passenger count

### Scoring System

| Action | Points |
|--------|--------|
| ✅ Passenger Delivered | **+10** |
| 🅿️ Parking Spot Used | **+10** |
| 💥 Collision (Yellow Taxi) | **-4** |
| 💥 Collision (Red Taxi) | **-2** |

## 📋 Installation & Setup

### System Requirements

- **Windows Operating System** (XP through Windows 11)
- **MASM** (Microsoft Macro Assembler)
- **Irvine32 Library** (included with MASM)
- **Visual Studio** or any MASM-compatible IDE
- **4GB RAM** minimum (8GB recommended)
- **10MB** free disk space

