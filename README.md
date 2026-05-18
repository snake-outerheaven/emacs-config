# Neo's Emacs Configuration

A lightweight, high-performance Emacs configuration inspired by the philosophy of Doom Emacs, but optimized for native Emacs keybindings.

## ✨ Key Features

### 🚀 Performance
- **GCMH**: The "Garbage Collector Magic Hack" for stutter-free editing.
- **Lazy Loading**: Packages are deferred using `use-package` for a fast startup.
- **Optimized I/O**: Increased process output limits for smooth LSP communication.

### 🔍 Modern Completion Stack
- **Vertico & Marginalia**: Clean minibuffer UI with rich metadata.
- **Orderless**: Powerful filtering for finding files and commands.
- **Consult & Embark**: Enhanced navigation and context-aware "magic" actions.
- **Corfu**: Lightweight, fast in-buffer completion.

### 💻 IDE Capabilities
- **Eglot**: Native LSP support for Python, C/C++, JavaScript, and Lua.
- **Projectile**: Robust project management and navigation.
- **Magit**: The gold standard for Git integration within an editor.
- **Helpful**: Much improved documentation buffers.

### 🎨 Aesthetics
- **Doom Themes & Modeline**: A polished, modern look.
- **Nerd Icons**: Consistent iconography throughout the UI (Dired, Ibuffer, Modeline).
- **Dashboard**: A clean start screen with recent files and projects.

### ⌨️ Navigation & QoL
- **Avy**: Jump to any character on screen with a few keystrokes.
- **Expand Region**: Semantic text selection.
- **Undo-Fu**: Simple, linear undo/redo behavior.
- **Which-Key**: Real-time keybinding hints.

## 🛠️ Installation

1. Backup your existing `.emacs.d`.
2. Clone this repository to `~/.emacs.d`.
3. Launch Emacs; it will automatically install all required packages.
4. Run `M-x nerd-icons-install-fonts` to get the UI icons working.

## ⚖️ License

This configuration is licensed under the **MIT License**. 
Feel free to use, copy, and modify it to your heart's content.

---
*Maintained with the assistance of AI.*
