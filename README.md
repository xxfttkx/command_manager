# Command Manager

A lightweight Flutter desktop tool to manage, configure, and run custom command groups with ease.

## ✨ Features

- 📋 Create reusable **commands** (single or multiple shell commands)
- 🧩 Group multiple commands into one **action**
- 🎨 Material 3-style UI with dark/light theme support
- 🚀 Run commands via GUI with real-time output display
- 📁 Organize commands with folders and labels
- 🛠️ Built-in command editor with arguments and presets
- 🔁 Reorderable actions for workflow customization

## 💡 Use Case Examples

- Run multiple setup scripts at once (e.g., `git pull` → `flutter pub get` → `build`)
- Save frequently used CLI tools and launch them from GUI
- Set up different project environments with a single click

## 🖥️ Platform

Currently optimized for **Flutter Desktop (Windows)**.

## 📸 Screenshots

_Add screenshots here if available._

## 📦 Getting Started

```bash
git clone https://github.com/yourname/command_manager.git
cd command_manager
flutter pub get
flutter run -d windows
```

> ✅ Make sure you have Flutter desktop enabled: `flutter config --enable-windows-desktop`

## 📁 Project Structure

- `models/` – Data classes for Command, Action, etc.
- `pages/` – Main UI pages like Home, Finished, etc.
- `widgets/` – Reusable UI components
- `services/` – Execution, logging, persistence
- `data/` – Predefined commands and actions (optional)

## 🧠 Concepts

- **Command**: A shell command (or group of commands) with description and arguments.
- **Action**: A list of commands run in sequence.
- **Finished Commands**: Logs of past executions (success/failure + stdout/stderr).

## 🛤️ Roadmap Ideas

- ✅ Run command groups from GUI
- [ ] Import/export commands as JSON
- [ ] Hotkey support
- [ ] Platform-aware command execution
- [ ] GitHub Actions integration?

## 🤝 Contributions

Contributions are welcome! Feel free to open issues or submit PRs.
