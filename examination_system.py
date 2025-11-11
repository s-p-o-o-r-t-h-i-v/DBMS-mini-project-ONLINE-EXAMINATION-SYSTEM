import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector

# ---------------- Database Connection ----------------
def connect_db():
    try:
        con = mysql.connector.connect(
            host="localhost",
            user="root",           
            password="",           
            database="examination_system"
        )
        return con
    except mysql.connector.Error as err:
        messagebox.showerror("Database Error", f"Error: {err}")
        return None

# ---------------- Insert Operations ----------------
def add_student():
    name = name_entry.get()
    qual = qual_entry.get()
    addr = addr_entry.get()

    if not name or not qual or not addr:
        messagebox.showwarning("Input Error", "Please fill all fields.")
        return

    con = connect_db()
    if con:
        cur = con.cursor()
        cur.callproc("AddStudent", (name, qual, addr))
        con.commit()
        messagebox.showinfo("Success", "Student added successfully!")
        con.close()
        clear_fields()

def add_exam():
    subject = sub_entry.get()
    date = date_entry.get()
    marks = marks_entry.get()

    if not subject or not date or not marks:
        messagebox.showwarning("Input Error", "Please fill all fields.")
        return

    con = connect_db()
    if con:
        cur = con.cursor()
        cur.callproc("RegisterStudentForExam", (subject, date, marks))
        con.commit()
        messagebox.showinfo("Success", "Exam added successfully!")
        con.close()
        clear_fields()

def add_question():
    exam_id = examid_entry.get()
    q_text = qtext_entry.get()
    q_marks = qmarks_entry.get()

    if not exam_id or not q_text or not q_marks:
        messagebox.showwarning("Input Error", "Please fill all fields.")
        return

    con = connect_db()
    if con:
        cur = con.cursor()
        cur.callproc("AddQuestion", (exam_id, q_text, q_marks))
        con.commit()
        messagebox.showinfo("Success", "Question added successfully!")
        con.close()
        clear_fields()

def add_result():
    cert = cert_entry.get()
    score = score_entry.get()
    exam_id = rexam_entry.get()
    stu_id = rstu_entry.get()

    if not cert or not score or not exam_id or not stu_id:
        messagebox.showwarning("Input Error", "Please fill all fields.")
        return

    con = connect_db()
    if con:
        cur = con.cursor()
        query = "INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID) VALUES (%s, %s, %s, %s)"
        cur.execute(query, (cert, score, exam_id, stu_id))
        con.commit()
        messagebox.showinfo("Success", "Result added (grade auto-calculated)!")
        con.close()
        clear_fields()

# ---------------- View Operations ----------------
def view_table(table_name):
    con = connect_db()
    if con:
        cur = con.cursor()
        cur.execute(f"SELECT * FROM {table_name}")
        rows = cur.fetchall()

        tree.delete(*tree.get_children())
        col_names = [desc[0] for desc in cur.description]
        tree["columns"] = col_names
        tree["show"] = "headings"
        for col in col_names:
            tree.heading(col, text=col)
            tree.column(col, width=120)

        for row in rows:
            tree.insert("", tk.END, values=row)
        con.close()

# ---------------- Utility ----------------
def clear_fields():
    for entry in [name_entry, qual_entry, addr_entry,
                  sub_entry, date_entry, marks_entry,
                  examid_entry, qtext_entry, qmarks_entry,
                  cert_entry, score_entry, rexam_entry, rstu_entry]:
        entry.delete(0, tk.END)

# ---------------- GUI Setup ----------------
root = tk.Tk()
root.title("Examination System - Tkinter UI")
root.geometry("1000x700")
root.configure(bg="#F9F9F9")

title_lbl = tk.Label(root, text="🧾 Examination System", font=("Helvetica", 20, "bold"), bg="#F9F9F9")
title_lbl.pack(pady=10)

tabControl = ttk.Notebook(root)
tabControl.pack(expand=1, fill="both", padx=10, pady=10)

# ---------- Tabs ----------
tab1 = ttk.Frame(tabControl)
tab2 = ttk.Frame(tabControl)
tab3 = ttk.Frame(tabControl)
tab4 = ttk.Frame(tabControl)
tab5 = ttk.Frame(tabControl)
tab6 = ttk.Frame(tabControl)

tabControl.add(tab1, text="Add Student")
tabControl.add(tab2, text="Add Exam")
tabControl.add(tab3, text="Add Question")
tabControl.add(tab4, text="Add Result")
tabControl.add(tab5, text="View Data")
tabControl.add(tab6, text="About")

# ---------- Tab 1 : Add Student ----------
tk.Label(tab1, text="Student Name").grid(row=0, column=0, padx=10, pady=5)
name_entry = tk.Entry(tab1, width=40); name_entry.grid(row=0, column=1)
tk.Label(tab1, text="Qualification").grid(row=1, column=0, padx=10, pady=5)
qual_entry = tk.Entry(tab1, width=40); qual_entry.grid(row=1, column=1)
tk.Label(tab1, text="Address").grid(row=2, column=0, padx=10, pady=5)
addr_entry = tk.Entry(tab1, width=40); addr_entry.grid(row=2, column=1)
tk.Button(tab1, text="Add Student", command=add_student, bg="lightblue").grid(row=3, columnspan=2, pady=15)

# ---------- Tab 2 : Add Exam ----------
tk.Label(tab2, text="Subject").grid(row=0, column=0, padx=10, pady=5)
sub_entry = tk.Entry(tab2, width=40); sub_entry.grid(row=0, column=1)
tk.Label(tab2, text="Exam Date (YYYY-MM-DD)").grid(row=1, column=0, padx=10, pady=5)
date_entry = tk.Entry(tab2, width=40); date_entry.grid(row=1, column=1)
tk.Label(tab2, text="Max Marks").grid(row=2, column=0, padx=10, pady=5)
marks_entry = tk.Entry(tab2, width=40); marks_entry.grid(row=2, column=1)
tk.Button(tab2, text="Add Exam", command=add_exam, bg="lightblue").grid(row=3, columnspan=2, pady=15)

# ---------- Tab 3 : Add Question ----------
tk.Label(tab3, text="Exam ID").grid(row=0, column=0, padx=10, pady=5)
examid_entry = tk.Entry(tab3, width=40); examid_entry.grid(row=0, column=1)
tk.Label(tab3, text="Question Text").grid(row=1, column=0, padx=10, pady=5)
qtext_entry = tk.Entry(tab3, width=40); qtext_entry.grid(row=1, column=1)
tk.Label(tab3, text="Marks").grid(row=2, column=0, padx=10, pady=5)
qmarks_entry = tk.Entry(tab3, width=40); qmarks_entry.grid(row=2, column=1)
tk.Button(tab3, text="Add Question", command=add_question, bg="lightblue").grid(row=3, columnspan=2, pady=15)

# ---------- Tab 4 : Add Result ----------
tk.Label(tab4, text="Certificate No").grid(row=0, column=0, padx=10, pady=5)
cert_entry = tk.Entry(tab4, width=40); cert_entry.grid(row=0, column=1)
tk.Label(tab4, text="Score").grid(row=1, column=0, padx=10, pady=5)
score_entry = tk.Entry(tab4, width=40); score_entry.grid(row=1, column=1)
tk.Label(tab4, text="Exam ID").grid(row=2, column=0, padx=10, pady=5)
rexam_entry = tk.Entry(tab4, width=40); rexam_entry.grid(row=2, column=1)
tk.Label(tab4, text="Student ID").grid(row=3, column=0, padx=10, pady=5)
rstu_entry = tk.Entry(tab4, width=40); rstu_entry.grid(row=3, column=1)
tk.Button(tab4, text="Add Result", command=add_result, bg="lightblue").grid(row=4, columnspan=2, pady=15)

# ---------- Tab 5 : View Data ----------
btn_frame = tk.Frame(tab5)
btn_frame.pack(pady=10)
tk.Button(btn_frame, text="View Students", command=lambda: view_table("Student")).grid(row=0, column=0, padx=5)
tk.Button(btn_frame, text="View Exams", command=lambda: view_table("Exam")).grid(row=0, column=1, padx=5)
tk.Button(btn_frame, text="View Questions", command=lambda: view_table("Question")).grid(row=0, column=2, padx=5)
tk.Button(btn_frame, text="View Results", command=lambda: view_table("Result")).grid(row=0, column=3, padx=5)

tree = ttk.Treeview(tab5)
tree.pack(fill="both", expand=True, padx=10, pady=10)
# ---------- Tab 7 : Delete Data ----------
tab7 = ttk.Frame(tabControl)
tabControl.add(tab7, text="Delete Data")

tk.Label(tab7, text="Enter Table Name").grid(row=0, column=0, padx=10, pady=5)
del_table_entry = tk.Entry(tab7, width=30)
del_table_entry.grid(row=0, column=1)

tk.Label(tab7, text="Enter ID Column Name").grid(row=1, column=0, padx=10, pady=5)
del_idcol_entry = tk.Entry(tab7, width=30)
del_idcol_entry.grid(row=1, column=1)

tk.Label(tab7, text="Enter ID Value to Delete").grid(row=2, column=0, padx=10, pady=5)
del_id_entry = tk.Entry(tab7, width=30)
del_id_entry.grid(row=2, column=1)

def delete_record():
    table = del_table_entry.get()
    id_col = del_idcol_entry.get()
    id_val = del_id_entry.get()

    if not table or not id_col or not id_val:
        messagebox.showwarning("Input Error", "Please fill all fields.")
        return

    con = connect_db()
    if con:
        cur = con.cursor()
        try:
            query = f"DELETE FROM {table} WHERE {id_col} = %s"
            cur.execute(query, (id_val,))
            con.commit()
            messagebox.showinfo("Success", f"Record deleted from {table}.")
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            con.close()

tk.Button(tab7, text="Delete Record", command=delete_record, bg="lightcoral").grid(row=3, columnspan=2, pady=15)


# ---------- Tab 6 : About ----------
about_text = """
📘 Examination System

Features:
- Add Students, Exams, Questions, and Results
- MySQL Trigger auto-calculates Grades
- Built with Python Tkinter + MySQL

Created by: Your Team
"""
tk.Label(tab6, text=about_text, justify="left", font=("Helvetica", 12)).pack(padx=20, pady=20)

root.mainloop()
