# 🧠 Emacs Configuration – “Ultimate Rice” IDE

> *AI‑enhanced. Performance‑first. Designed for the modern hacker.*

This is my personal Emacs configuration – a carefully curated, **AI‑powered** development environment that blends the best of modern Emacs packages with a sleek, consistent interface. It’s built to be fast, flexible, and a pleasure to use every day.

Maintained by **[snake‑outerheaven](https://github.com/snake-outerheaven)**  
📦 Repository: [github.com/snake-outerheaven/emacs-config](https://github.com/snake-outerheaven/emacs-config)  
📜 License: **MIT** – free for everyone, no strings attached.

---

## ✨ Overview

This config turns Emacs into a fully‑fledged **IDE** with:

- **Intelligent code completion** (LSP via Eglot)  
- **Modern completion UI** (Vertico + Orderless + Consult)  
- **Git integration** (Magit + VC)  
- **Visual polish** (Doom themes, Nerd icons, Dashboard)  
- **Navigation superpowers** (Avy, Consult, Projectile)  
- **Terminal replacement** (Eshell)  
- **Buffer & file management** (Ibuffer, Dired with preview)  

And everything is **AI‑guided**: from the selection of packages to the tuning of performance and keybindings.

---

## 🚀 Features (by category)

### 🔧 Performance & Stability
- **Garbage Collection** tuned to prevent stutters (`gcmh` + custom thresholds)  
- `no-littering` keeps your `~/.emacs.d` clean  
- No file locks (`create-lockfiles nil`)  

### 🎨 Aesthetics
- **Doom Themes** (easily switchable, defaults to `doom-one`)  
- **Doom Modeline** with LSP, version control, and icon support  
- **Nerd Icons** everywhere – Dired, Ibuffer, Corfu, Dashboard  
- **Rainbow delimiters** for parentheses and brackets  
- **Dashboard** startup screen with recent files & projects  

### 🔍 Completion & Discovery
- **Vertico** – vertical, interactive minibuffer completion  
- **Orderless** – fuzzy, prefix‑free matching  
- **Marginalia** – rich annotations for completions  
- **Consult** – powerful search and navigation commands  
- **Embark** – context‑sensitive actions (“the magic button”)  
- **Which‑Key** – discover keybindings as you type  

### 📝 Code Completion (popup)
- **Corfu** – inline popup completion  
- **Nerd Icons** in the completion margin  
- `corfu-terminal` fallback for TTY sessions  

### 💻 IDE & Language Support (Eglot)
- **C / C++** (clangd)  
- **Python** (pyright)  
- **JavaScript** (typescript‑language-server)  
- **Java** (jdtls)  
- **Lua** (lua‑language-server + lua-mode)  

All LSP features: rename, code actions, format, go to definition, symbol search (`consult-eglot`).

### 🗃️ Version Control
- **Magit** – the best Git client inside Emacs  
- Built‑in **VC** commands for quick diffs, logs, and commits  
- **diff‑hl** – visual git‑gutter in the margin  

### 📂 File & Buffer Management
- **Dired** – enhanced with async commands, compression, and image preview  
- **Ibuffer** – filtered, grouped buffer list with icons  
- **Projectile** – project navigation and switching  
- **Consult‑projectile** – fuzzy project search  

### 🐚 Shell & Terminal
- **Eshell** – cross‑platform shell written in Elisp  
- Custom aliases (`ff`, `dired`, `z`)  
- Persistent history  

### 🧭 Navigation & Editing
- **Avy** – jump to any character with two keystrokes (`M‑j`)  
- **Expand Region** – semantically expand selection (`C‑=`)  
- **Undo‑Fu** – better undo/redo (`C‑z` / `C‑S‑z`)  
- **Comment Line** – quick commenting (`M‑/`)  
- **Electric pair mode** – auto‑close brackets  

### 🧹 Utilities & Documentation
- **Helpful** – better help buffers  
- **Hl‑Todo** – highlight TODO/FIXME/NOTE comments  
- **Saveplace** – restore cursor position  
- **Recentf** – track recently opened files  
- **Auto‑revert** – keep buffers in sync with disk  

### 🔌 Additional Packages
- `gcmh` – idle garbage collection  
- `consult-dir` – directory history navigation  
- `dired-preview` – quick file previews  
- `embark-consult` – bridge between Consult and Embark  

---

## 📦 Requirements (outside Emacs)

For full functionality, install these external tools. Below is a plain‑text table for easy copying:

```text
Language / Tool   | Required package               | Installation (Debian/Ubuntu)
C/C++             | clangd                         | sudo apt install clangd
Python            | pyright                        | npm install -g pyright
JavaScript        | typescript-language-server     | npm install -g typescript-language-server
Java              | jdtls                          | Download from Eclipse (or use eglot-jdtls)
Lua               | lua-language-server            | sudo apt install lua-language-server
Ripgrep           | rg (for Consult)               | sudo apt install ripgrep
Nerd Fonts        | (any Nerd Font)                | Run M-x nerd-icons-install-fonts
```

---

## 🛠️ Installation

Clone the repository to `~/.emacs.d`:

```bash
git clone https://github.com/snake-outerheaven/emacs-config.git ~/.emacs.d
```

Then start Emacs. All packages will be installed automatically (first startup may take a few minutes).

> **Note**: This config requires **Emacs 29.1 or newer** (some features use `emoji-insert`, `tree-sitter` is optional).

---

## 🧠 AI‑Powered? What does that mean?

This configuration was **designed and refined with the help of AI** (Large Language Models). Every package selection, performance tuning, and keybinding choice has been reviewed by AI, and the entire `init.el` is documented in a style that makes it easy for both humans and AI to understand. The goal is to create a **reproducible, extensible, and intelligent** starting point for any Emacs user.

In practice, this means:
- **Self‑documenting** code with comments in English  
- **Modular** sections that are easy to read and modify  
- **Best practices** taken from community wisdom + AI suggestions  
- **Optimised defaults** that work out of the box  

---

## 🤝 Contributing

Because this is my personal config, I don't actively accept pull requests. However, you are free to **fork** and adapt it under the MIT license. If you find a bug or have a great idea, feel free to open an issue – I might incorporate it.

---

## 📄 License

**MIT License** – see [LICENSE](LICENSE) file for details.  
You are free to use, copy, modify, merge, publish, distribute, and sell copies of this software.

---

## 🙏 Credits

- The amazing Emacs community and all package authors  
- Doom Emacs for inspiration on performance & keybindings  
- AI models (especially DeepSeek) for helping me craft, refactor, and document this config  

---

**“Emacs is a great operating system – lacking only a decent editor.”**  
*With this config, it has both.* 🚀*