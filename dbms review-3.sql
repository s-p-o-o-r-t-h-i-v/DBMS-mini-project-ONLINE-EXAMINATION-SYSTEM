-- ======================================================
-- ONLINE EXAMINATION SYSTEM

DROP DATABASE IF EXISTS examination_system;
CREATE DATABASE examination_system;
USE examination_system;

--  CREATE TABLES
CREATE TABLE Student (
    Student_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Qualification VARCHAR(50),
    Address VARCHAR(200)
);

CREATE TABLE Exam (
    Exam_ID INT AUTO_INCREMENT PRIMARY KEY,
    Subject VARCHAR(100),
    Exam_Date DATE,
    Max_Marks INT
);

CREATE TABLE Result (
    Result_ID INT AUTO_INCREMENT PRIMARY KEY,
    Certificate_No INT,
    Score INT,
    Grade_Obtained VARCHAR(2),
    Exam_ID INT,
    Student_ID INT,
    FOREIGN KEY (Exam_ID) REFERENCES Exam(Exam_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
);

CREATE TABLE Question (
    Question_ID INT AUTO_INCREMENT PRIMARY KEY,
    Exam_ID INT,
    Question_Text VARCHAR(255),
    Marks INT,
    FOREIGN KEY (Exam_ID) REFERENCES Exam(Exam_ID)
);

--  FUNCTION TO CALCULATE GRADE
DROP FUNCTION IF EXISTS CalculateGrade;
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

--  TRIGGER TO AUTO-INSERT GRADE
DROP TRIGGER IF EXISTS trg_auto_grade;
DELIMITER //
CREATE TRIGGER trg_auto_grade
BEFORE INSERT ON Result
FOR EACH ROW
BEGIN
    SET NEW.Grade_Obtained = CalculateGrade(NEW.Score);
END //
DELIMITER ;

--  STORED PROCEDURES

-- Add a student
DROP PROCEDURE IF EXISTS AddStudent;
DELIMITER //
CREATE PROCEDURE AddStudent(
    IN p_Name VARCHAR(100),
    IN p_Qualification VARCHAR(50),
    IN p_Address VARCHAR(200)
)
BEGIN
    INSERT INTO Student (Name, Qualification, Address)
    VALUES (p_Name, p_Qualification, p_Address);
END //
DELIMITER ;

-- Register exam
DROP PROCEDURE IF EXISTS RegisterStudentForExam;
DELIMITER //
CREATE PROCEDURE RegisterStudentForExam(
    IN p_Subject VARCHAR(100),
    IN p_ExamDate DATE,
    IN p_MaxMarks INT
)
BEGIN
    INSERT INTO Exam (Subject, Exam_Date, Max_Marks)
    VALUES (p_Subject, p_ExamDate, p_MaxMarks);
END //
DELIMITER ;

-- Add question
DROP PROCEDURE IF EXISTS AddQuestion;
DELIMITER //
CREATE PROCEDURE AddQuestion(
    IN p_ExamID INT,
    IN p_QuestionText VARCHAR(255),
    IN p_Marks INT
)
BEGIN
    INSERT INTO Question (Exam_ID, Question_Text, Marks)
    VALUES (p_ExamID, p_QuestionText, p_Marks);
END //
DELIMITER ;

--  INSERT SAMPLE DATA USING PROCEDURES

CALL AddStudent('Arjun Kumar', 'B.Sc', 'Bangalore');
CALL AddStudent('Sneha Rao', 'B.Tech', 'Mysore');
CALL AddStudent('Ravi Patel', 'M.Sc', 'Chennai');

CALL RegisterStudentForExam('Mathematics', '2025-11-10', 100);
CALL RegisterStudentForExam('Physics', '2025-11-12', 100);
CALL RegisterStudentForExam('Chemistry', '2025-11-15', 100);

CALL AddQuestion(1, 'What is 2+2?', 5);
CALL AddQuestion(1, 'Define Integration.', 10);
CALL AddQuestion(2, 'What is Newton’s 2nd Law?', 10);
CALL AddQuestion(3, 'Name the periodic table’s first element.', 5);

--  INSERT RESULTS (TRIGGER AUTO-CALCULATES GRADE)
INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID) VALUES (501, 92, 1, 1);
INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID) VALUES (502, 81, 2, 2);
INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID) VALUES (503, 68, 3, 3);
INSERT INTO Result (Certificate_No, Score, Exam_ID, Student_ID) VALUES (504, 37, 1, 2);

--  VIEW DATA
SELECT * FROM Student;
SELECT * FROM Exam;
SELECT * FROM Question;
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


