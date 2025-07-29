# 🛠️ Mini C Compiler with GUI

A simple mini C-like compiler with a user-friendly graphical interface using `tkinter` and `ttkbootstrap`. Supports variable declarations, conditionals (`if`, `else`), loops (`for`, `while`), and standard input/output (`printf`, `scanf`).

---

## ✨ Features

- GUI built with `tkinter` + `ttkbootstrap`
- Compile C-like code using `lex`, `yacc` (Bison & Flex)
- Supports:
  - Variable declaration and assignment
  - Arithmetic expressions
  - Conditional (`if`, `else`) 
  - `printf` and `scanf` functionality
- Open `.c` files and compile with a click
- Syntax-highlighted output area

---
## 🔧 Installation

### 🐧 Linux

1. **Install dependencies**:

```bash
sudo apt update
sudo apt install flex bison gcc python3 python3-pip
python3 -m venv venv
source venv/bin/activate
pip install ttkbootstrap
