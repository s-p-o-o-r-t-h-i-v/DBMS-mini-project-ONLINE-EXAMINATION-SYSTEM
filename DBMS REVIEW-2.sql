-- STUDENT TABLE
Create database Examination_system;
use Examination_system;

CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Qualification VARCHAR(50),
    Address VARCHAR(200)
);

-- STUDENT CONTACT TABLE
CREATE TABLE Student_Contact (
    Student_ID INT,
    Contact_No VARCHAR(15),
    PRIMARY KEY (Student_ID, Contact_No),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

-- ADMIN TABLE
CREATE TABLE ADMIN (
	Admin_ID INT PRIMARY KEY,
    Admin_Name VARCHAR(100) NOT NULL,
    Admin_Role VARCHAR(50) NOT NULL
);

-- WEBSITE TABLE
CREATE TABLE Website (
	Website_ID INT PRIMARY KEY,
    Website_Name VARCHAR(100) NOT NULL,
    Contact_Details VARCHAR(100),
    Admin_ID INT,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
);

 
-- SUBJECT TABLE
CREATE TABLE Subject (
    Subject_Code INT PRIMARY KEY,
    Subject_Name VARCHAR(100) NOT NULL
);

-- EXAMINATION TABLE
CREATE TABLE Examination (
    Exam_ID INT PRIMARY KEY,
    Exam_Name VARCHAR(100) NOT NULL,
    Exam_Subject INT,
    Num_Questions INT,
    Website_ID INT,
    FOREIGN KEY (Exam_Subject) REFERENCES Subject(Subject_Code),
    FOREIGN KEY (Website_ID) REFERENCES Website(Website_ID)
);

-- EXAM CENTER TABLE
CREATE TABLE Exam_Center (
    Center_No INT PRIMARY KEY,
    Center_Name VARCHAR(100) NOT NULL,
    Exam_ID INT,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

-- QUESTION TABLE
CREATE TABLE Question (
    Question_ID INT PRIMARY KEY,
    Question_Text VARCHAR(500) NOT NULL,
    Correct_Answer VARCHAR(100) NOT NULL,
    Subject_Code INT,
    Exam_ID INT,
    FOREIGN KEY (Subject_Code) REFERENCES Subject(Subject_Code),
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

-- RESULT TABLE
CREATE TABLE Result (
    Certificate_No INT PRIMARY KEY,
    Grade_Obtained CHAR(2),
    Exam_ID INT,
    Student_ID INT,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
);

-- NEW RELATIONSHIP TABLE: STUDENT-EXAM REGISTRATION
CREATE TABLE Student_Exam (
    Student_ID INT,
    Exam_ID INT,
    Registration_Date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (Student_ID, Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

-- ATTEND TABLE
CREATE TABLE Attend (
    Student_ID INT,
    Exam_ID INT,
    Attendance_Date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (Student_ID, Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID) ON DELETE CASCADE
);


INSERT INTO Student VALUES (1, 'SPOORTHI', 'Btech CS', 'Bangalore');
INSERT INTO Student VALUES (2, 'SRIVIDHYA', 'BTech IS', 'Hyderabad');
INSERT INTO Student VALUES (3, 'Sneha Patel', 'BSc IT', 'Delhi');

show tables;
select * from Attend;
-- CONTACTS
Insert into Student_Contact values(1,'9845227420');
Insert into Student_Contact Values(2,'7483394221');
Insert into Student_Contact values(3,'9901939089');
select * from Student_Contact;

-- ADMINS
INSERT INTO Admin VALUES (101, 'Dr. Sanju', 'Super Admin');
INSERT INTO Admin VALUES (102, 'Prof. Ramesh', 'Exam Coordinator');
select * from Admin;

-- WEBSITES
INSERT INTO Website VALUES (201, 'ExamPortal', 'exam@portal.com', 101);
INSERT INTO Website VALUES (202, 'TestOnline', 'support@testonline.com', 102);

select * from Website;

-- SUBJECTS
INSERT INTO Subject VALUES (301, 'Database Management Systems');
INSERT INTO Subject VALUES (302, 'Computer Networks');
select * from Subject;

-- EXAMS
INSERT INTO Examination VALUES (401, 'DBMS Final Exam', 301, 50, 201);
INSERT INTO Examination VALUES (402, 'Networks Midterm', 302, 40, 202);

select * from Examination;

-- EXAM CENTERS
INSERT INTO Exam_Center VALUES (501, 'Center A', 401);
INSERT INTO Exam_Center VALUES (502, 'Center B', 402);

select * from Exam_Center;

-- QUESTIONS
INSERT INTO Question VALUES (601, 'What is primary key?', ' Primary Key uniquely identifies rows in a table.', 301, 401);
INSERT INTO Question VALUES (602, 'What is a view?', 'A virtual table based on a result set from a query. ', 301, 401);
INSERT INTO Question VALUES (603, 'What is IP address?', 'Unique identifier for a device', 302, 402);

select * from Question;

-- STUDENT-EXAM REGISTRATION
INSERT INTO Student_Exam VALUES (1, 401, '2025-09-01'); -- SPOORTHI registered for DBMS Exam
INSERT INTO Student_Exam VALUES (1, 402, '2025-09-02'); -- SPOORTHI also registered for Networks
INSERT INTO Student_Exam VALUES (2, 402, '2025-09-01'); -- SRIVIDHYA registered for Networks
INSERT INTO Student_Exam VALUES (3, 401, '2025-09-03'); -- Sneha registered for DBMS

select * from Student_Exam;

-- RESULTS
INSERT INTO Result VALUES (701, 'A+', 401, 1); -- SPOORTHI got A+ in DBMS
INSERT INTO Result VALUES (702, 'B', 402, 2);  -- SRIVIDHYA got B in Networks
INSERT INTO Result VALUES (703, 'A', 402, 1);  -- SPOORTHI got A in Networks
INSERT INTO Result VALUES (704, 'B+', 401, 3); -- Sneha got B+ in DBMS

select * from Result;

show tables;

INSERT INTO Attend VALUES (1, 401, '2025-09-15');  -- SPOORTHI attended DBMS Exam
INSERT INTO Attend VALUES (1, 402, '2025-09-20');  -- SPOORTHI attended Networks Exam
INSERT INTO Attend VALUES (2, 402, '2025-09-20');  -- SRIVIDHYA attended Networks Exam
INSERT INTO Attend VALUES (3, 401, '2025-09-15');  -- Sneha attended DBMS Exam
select * from Attend;
