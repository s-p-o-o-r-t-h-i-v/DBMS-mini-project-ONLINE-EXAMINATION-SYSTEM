--  ONLINE EXAMINATION SYSTEM DATABASE SCRIPT

--  CREATE DATABASE
CREATE DATABASE Examination_system;
USE Examination_system;

--  CREATE TABLES (DDL)

CREATE TABLE Student (
    Student_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Qualification VARCHAR(50),
    Address VARCHAR(200)
);

CREATE TABLE Student_Contact (
    Student_ID INT,
    Contact_No VARCHAR(15),
    PRIMARY KEY (Student_ID, Contact_No),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE
);

CREATE TABLE Admin (
	Admin_ID INT PRIMARY KEY,
    Admin_Name VARCHAR(100) NOT NULL,
    Admin_Role VARCHAR(50) NOT NULL
);

CREATE TABLE Website (
	Website_ID INT PRIMARY KEY,
    Website_Name VARCHAR(100) NOT NULL,
    Contact_Details VARCHAR(100),
    Admin_ID INT,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
);

CREATE TABLE Subject (
    Subject_Code INT PRIMARY KEY,
    Subject_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Examination (
    Exam_ID INT PRIMARY KEY,
    Exam_Name VARCHAR(100) NOT NULL,
    Exam_Subject INT,
    Num_Questions INT,
    Website_ID INT,
    FOREIGN KEY (Exam_Subject) REFERENCES Subject(Subject_Code),
    FOREIGN KEY (Website_ID) REFERENCES Website(Website_ID)
);

CREATE TABLE Exam_Center (
    Center_No INT PRIMARY KEY,
    Center_Name VARCHAR(100) NOT NULL,
    Exam_ID INT,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

CREATE TABLE Question (
    Question_ID INT PRIMARY KEY AUTO_INCREMENT,
    Question_Text VARCHAR(500) NOT NULL,
    Correct_Answer VARCHAR(100) NOT NULL,
    Subject_Code INT,
    Exam_ID INT,
    FOREIGN KEY (Subject_Code) REFERENCES Subject(Subject_Code),
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

CREATE TABLE Result (
    Certificate_No INT PRIMARY KEY,
    Score INT,
    Grade_Obtained CHAR(2),
    Exam_ID INT,
    Student_ID INT,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
);

CREATE TABLE Student_Exam (
    Student_ID INT,
    Exam_ID INT,
    Registration_Date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (Student_ID, Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID)
);

CREATE TABLE Attend (
    Student_ID INT,
    Exam_ID INT,
    Attendance_Date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (Student_ID, Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Exam_ID) REFERENCES Examination(Exam_ID) ON DELETE CASCADE
);

-- 3️ INSERT DATA (DML)
INSERT INTO Student (Name, Qualification, Address) VALUES
('SPOORTHI', 'BTech CS', 'Bangalore'),
('SRIVIDHYA', 'BTech IS', 'Hyderabad'),
('Sneha Patel', 'BSc IT', 'Delhi');

INSERT INTO Student_Contact VALUES
(1,'9845227420'),
(2,'7483394221'),
(3,'9901939089');

INSERT INTO Admin VALUES
(101, 'Dr. Sanju', 'Super Admin'),
(102, 'Prof. Ramesh', 'Exam Coordinator');

INSERT INTO Website VALUES
(201, 'ExamPortal', 'exam@portal.com', 101),
(202, 'TestOnline', 'support@testonline.com', 102);

INSERT INTO Subject VALUES
(301, 'Database Management Systems'),
(302, 'Computer Networks');

INSERT INTO Examination VALUES
(401, 'DBMS Final Exam', 301, 50, 201),
(402, 'Networks Midterm', 302, 40, 202);

INSERT INTO Exam_Center VALUES
(501, 'Center A', 401),
(502, 'Center B', 402);

INSERT INTO Question (Question_Text, Correct_Answer, Subject_Code, Exam_ID) VALUES
('What is primary key?', 'Primary Key uniquely identifies rows in a table.', 301, 401),
('What is a view?', 'A virtual table based on a query.', 301, 401),
('What is IP address?', 'Unique identifier for a device', 302, 402);

INSERT INTO Student_Exam VALUES
(1, 401, '2025-09-01'),
(1, 402, '2025-09-02'),
(2, 402, '2025-09-01'),
(3, 401, '2025-09-03');

INSERT INTO Attend VALUES
(1, 401, '2025-09-15'),
(1, 402, '2025-09-20'),
(2, 402, '2025-09-20'),
(3, 401, '2025-09-15');

INSERT INTO Result (Certificate_No, Score, Grade_Obtained, Exam_ID, Student_ID) VALUES
(701, 95, 'A+', 401, 1),
(702, 76, 'B', 402, 2),
(703, 88, 'A', 402, 1),
(704, 82, 'B+', 401, 3);

--  FUNCTIONS AND PROCEDURES
DELIMITER //
CREATE FUNCTION CalculateGrade(score INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(2);
    IF score >= 90 THEN
        SET grade = 'A+';
    ELSEIF score >= 80 THEN
        SET grade = 'A';
    ELSEIF score >= 70 THEN
        SET grade = 'B';
    ELSEIF score >= 60 THEN
        SET grade = 'C';
    ELSEIF score >= 40 THEN
        SET grade = 'D';
    ELSE
        SET grade = 'F';
    END IF;
    RETURN grade;
END //
DELIMITER ;

-- Procedure: Add Student
DELIMITER //
CREATE PROCEDURE AddStudent(
    IN p_Name VARCHAR(100),
    IN p_Qualification VARCHAR(50),
    IN p_Address VARCHAR(100)
)
BEGIN
    INSERT INTO Student (Name, Qualification, Address)
    VALUES (p_Name, p_Qualification, p_Address);
END //
DELIMITER ;

-- Procedure: Register Student
DELIMITER //
CREATE PROCEDURE RegisterStudentForExam(
    IN p_student_id INT,
    IN p_exam_id INT
)
BEGIN
    INSERT INTO Student_Exam (Student_ID, Exam_ID)
    VALUES (p_student_id, p_exam_id);
END //
DELIMITER ;

-- Procedure: Add Question
DELIMITER //
CREATE PROCEDURE AddQuestion(
    IN p_question_text VARCHAR(255),
    IN p_correct_answer VARCHAR(100),
    IN p_subject_code INT,
    IN p_exam_id INT
)
BEGIN
    INSERT INTO Question (Question_Text, Correct_Answer, Subject_Code, Exam_ID)
    VALUES (p_question_text, p_correct_answer, p_subject_code, p_exam_id);
END //
DELIMITER ;

--  TRIGGER
DELIMITER //
CREATE TRIGGER trg_auto_grade
BEFORE INSERT ON Result
FOR EACH ROW
BEGIN
    SET NEW.Grade_Obtained = CalculateGrade(NEW.Score);
END //
DELIMITER ;

--  TEST FUNCTION & TRIGGER INVOCATION

CALL AddStudent('Arjun Rao', 'B.Tech', 'Bangalore');
CALL RegisterStudentForExam(4, 403);
CALL AddQuestion('What is a primary key?', 'A unique identifier for a record', 301, 403);

INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID)
VALUES (705, 86, 403, 4);

SELECT * FROM Result;

--  JOIN QUERIES
-- Show student name, subject, score, and grade
SELECT 
    s.Name AS Student_Name,
    e.Subject AS Exam_Subject,
    r.Score,
    r.Grade_Obtained
FROM Result r
JOIN Student s ON r.Student_ID = s.Student_ID
JOIN Exam e ON r.Exam_ID = e.Exam_ID;

-- Show exam details (exam center–exam example)
SELECT e.Exam_ID, e.Subject, e.Exam_Date, e.Max_Marks
FROM Exam e;

--  AGGREGATE QUERIES
-- Count number of exams conducted
SELECT COUNT(Exam_ID) AS Total_Exams FROM Exam;

-- Average score per exam
SELECT e.Subject, AVG(r.Score) AS Average_Score
FROM Result r
JOIN Exam e ON r.Exam_ID = e.Exam_ID
GROUP BY e.Subject;

-- Highest and lowest score per exam
SELECT e.Subject, MAX(r.Score) AS Highest_Score, MIN(r.Score) AS Lowest_Score
FROM Result r
JOIN Exam e ON r.Exam_ID = e.Exam_ID
GROUP BY e.Subject;

-- Total score obtained by each student
SELECT s.Name, SUM(r.Score) AS Total_Score
FROM Result r
JOIN Student s ON r.Student_ID = s.Student_ID
GROUP BY s.Name;
--  UPDATE AND DELETE EXAMPLES
-- Update student’s result score (example)
UPDATE Result
SET Score = 90
WHERE Student_ID = 1 AND Exam_ID = 1;

-- View updated result
SELECT * FROM Result WHERE Student_ID = 1;

-- Delete a student and related results (example)
DELETE FROM Result WHERE Student_ID = 3;
DELETE FROM Student WHERE Student_ID = 3;

-- Final student table after delete
SELECT * FROM Student;


