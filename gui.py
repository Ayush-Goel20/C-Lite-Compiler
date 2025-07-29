import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox
from tkinter.scrolledtext import ScrolledText
import ttkbootstrap as ttk
from ttkbootstrap.constants import *

def compile_code():
    code = code_input.get("1.0", tk.END)
    try:
        with open("temp_input.c", "w") as f:
            f.write(code)

        process = subprocess.run(["./mycompiler"], input=code.encode(), capture_output=True)

        output_text.delete("1.0", tk.END)
        output_text.insert(tk.END, process.stdout.decode())
        if process.stderr:
            output_text.insert(tk.END, "\n[Error Output]:\n" + process.stderr.decode())

        status_var.set("Compiled successfully" if not process.stderr else "Compiled with errors")

    except Exception as e:
        messagebox.showerror("Error", str(e))
        status_var.set("Compilation failed")

def open_file():
    path = filedialog.askopenfilename(filetypes=[("C Files", "*.c"), ("All Files", "*.*")])
    if path:
        with open(path, "r") as f:
            code_input.delete("1.0", tk.END)
            code_input.insert(tk.END, f.read())
        status_var.set(f"Opened file: {path}")

# --- Main Window ---
root = ttk.Window(themename="flatly")  # Try: "flatly", "darkly", "cosmo"
root.title("Mini C Compiler")
root.geometry("920x720")

default_font = ("Segoe UI", 11)

# --- Frames ---
ttk.Label(root, text="Mini C Compiler", font=("Segoe UI", 16, "bold")).pack(pady=10)

input_frame = ttk.Frame(root, padding=10)
input_frame.pack(fill="both", expand=True)

ttk.Label(input_frame, text="Enter C-like Code", font=default_font).pack(anchor="w")

code_input = ScrolledText(input_frame, height=15, font=("Consolas", 11), wrap="word", borderwidth=2, relief="groove")
code_input.pack(fill="both", expand=True, pady=(5, 10))

# --- Buttons ---
button_frame = ttk.Frame(root, padding=10)
button_frame.pack()

ttk.Button(button_frame, text="Compile", command=compile_code, bootstyle="success-outline", width=15).pack(side="left", padx=10)
ttk.Button(button_frame, text="Open File", command=open_file, bootstyle="info-outline", width=15).pack(side="left", padx=10)

# --- Output ---
output_frame = ttk.Frame(root, padding=(10, 10, 10, 5))
output_frame.pack(fill="both", expand=True)

ttk.Label(output_frame, text="Compiler Output", font=default_font).pack(anchor="w")

output_text = ScrolledText(output_frame, height=12, font=("Consolas", 11), wrap="word", background="#f4f9f4", borderwidth=2, relief="groove")
output_text.pack(fill="both", expand=True, pady=(5, 10))

# --- Status Bar ---
status_var = tk.StringVar(value="Ready")
status_bar = ttk.Label(root, textvariable=status_var, anchor="w", font=("Segoe UI", 10), bootstyle="secondary", padding=5)
status_bar.pack(fill="x", side="bottom")

root.mainloop()
