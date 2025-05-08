USE MASTER
GO
DROP DATABASE IF EXISTS Courses
GO
CREATE DATABASE Courses
GO
USE Courses
GO

CREATE TABLE Students (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(100)
) AS NODE;

CREATE TABLE Teachers (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Position NVARCHAR(50)
) AS NODE;

CREATE TABLE Courses (
    ID INT PRIMARY KEY,
    Title NVARCHAR(100),
    Credits INT
) AS NODE;

CREATE TABLE EnrolledIn AS EDGE;    -- Студент -> Курс
CREATE TABLE Teaches AS EDGE;       -- Преподаватель -> Курс
CREATE TABLE Advises AS EDGE;       -- Преподаватель -> Студент

-- Студенты
INSERT INTO Students (ID, FullName) VALUES
(1, N'Алиса Иванова'),
(2, N'Борис Смирнов'),
(3, N'Вера Козлова'),
(4, N'Глеб Новиков'),
(5, N'Дарья Сидорова'),
(6, N'Егор Михайлов'),
(7, N'Жанна Титова'),
(8, N'Захар Орлов'),
(9, N'Ирина Васильева'),
(10, N'Кирилл Кузнецов');

-- Преподаватели
INSERT INTO Teachers (ID, FullName, Position) VALUES
(1, N'Иван Сергеевич Иванов', N'доцент'),
(2, N'Мария Петровна Петрова', N'профессор'),
(3, N'Олег Николаевич Соколов', N'ассистент'),
(4, N'Елена Викторовна Морозова', N'доцент'),
(5, N'Андрей Юрьевич Васильев', N'старший преподаватель'),
(6, N'Светлана Геннадьевна Лебедева', N'профессор'),
(7, N'Дмитрий Александрович Козлов', N'доцент'),
(8, N'Татьяна Игоревна Фролова', N'ассистент'),
(9, N'Павел Владимирович Захаров', N'доцент'),
(10, N'Юлия Никитична Баранова', N'профессор');

-- Дисциплины
INSERT INTO Courses (ID, Title, Credits) VALUES
(1, N'Базы данных', 4),
(2, N'Математический анализ', 5),
(3, N'Программирование на C++', 5),
(4, N'Философия', 2),
(5, N'Компьютерные сети', 4),
(6, N'Машинное обучение', 5),
(7, N'Теория вероятностей', 3),
(8, N'Физика', 4),
(9, N'Английский язык', 2),
(10, N'История Беларуси', 3);

-- Студент записан на курс
INSERT INTO EnrolledIn ($from_id, $to_id) VALUES
((SELECT $node_id FROM Students WHERE ID = 1), (SELECT $node_id FROM Courses WHERE ID = 10)),
((SELECT $node_id FROM Students WHERE ID = 1), (SELECT $node_id FROM Courses WHERE ID = 8)),
((SELECT $node_id FROM Students WHERE ID = 1), (SELECT $node_id FROM Courses WHERE ID = 4)),
((SELECT $node_id FROM Students WHERE ID = 2), (SELECT $node_id FROM Courses WHERE ID = 8)),
((SELECT $node_id FROM Students WHERE ID = 2), (SELECT $node_id FROM Courses WHERE ID = 5)),
((SELECT $node_id FROM Students WHERE ID = 3), (SELECT $node_id FROM Courses WHERE ID = 1)),
((SELECT $node_id FROM Students WHERE ID = 3), (SELECT $node_id FROM Courses WHERE ID = 7)),
((SELECT $node_id FROM Students WHERE ID = 4), (SELECT $node_id FROM Courses WHERE ID = 2)),
((SELECT $node_id FROM Students WHERE ID = 5), (SELECT $node_id FROM Courses WHERE ID = 3)),
((SELECT $node_id FROM Students WHERE ID = 6), (SELECT $node_id FROM Courses WHERE ID = 6)),
((SELECT $node_id FROM Students WHERE ID = 7), (SELECT $node_id FROM Courses WHERE ID = 7)),
((SELECT $node_id FROM Students WHERE ID = 8), (SELECT $node_id FROM Courses WHERE ID = 5)),
((SELECT $node_id FROM Students WHERE ID = 9), (SELECT $node_id FROM Courses WHERE ID = 9)),
((SELECT $node_id FROM Students WHERE ID = 10), (SELECT $node_id FROM Courses WHERE ID = 1)),
((SELECT $node_id FROM Students WHERE ID = 10), (SELECT $node_id FROM Courses WHERE ID = 5));

-- Преподаватель ведёт курс
INSERT INTO Teaches ($from_id, $to_id) VALUES
((SELECT $node_id FROM Teachers WHERE ID = 1), (SELECT $node_id FROM Courses WHERE ID = 7)),
((SELECT $node_id FROM Teachers WHERE ID = 1), (SELECT $node_id FROM Courses WHERE ID = 2)),
((SELECT $node_id FROM Teachers WHERE ID = 2), (SELECT $node_id FROM Courses WHERE ID = 9)),
((SELECT $node_id FROM Teachers WHERE ID = 2), (SELECT $node_id FROM Courses WHERE ID = 5)),
((SELECT $node_id FROM Teachers WHERE ID = 3), (SELECT $node_id FROM Courses WHERE ID = 10)),
((SELECT $node_id FROM Teachers WHERE ID = 3), (SELECT $node_id FROM Courses WHERE ID = 2)),
((SELECT $node_id FROM Teachers WHERE ID = 4), (SELECT $node_id FROM Courses WHERE ID = 4)),
((SELECT $node_id FROM Teachers WHERE ID = 5), (SELECT $node_id FROM Courses WHERE ID = 6)),
((SELECT $node_id FROM Teachers WHERE ID = 6), (SELECT $node_id FROM Courses WHERE ID = 1)),
((SELECT $node_id FROM Teachers WHERE ID = 7), (SELECT $node_id FROM Courses WHERE ID = 3)),
((SELECT $node_id FROM Teachers WHERE ID = 8), (SELECT $node_id FROM Courses WHERE ID = 8));

-- Преподаватель курирует студента 
INSERT INTO Advises ($from_id, $to_id) VALUES
((SELECT $node_id FROM Teachers WHERE ID = 1), (SELECT $node_id FROM Students WHERE ID = 2)),
((SELECT $node_id FROM Teachers WHERE ID = 1), (SELECT $node_id FROM Students WHERE ID = 4)),
((SELECT $node_id FROM Teachers WHERE ID = 2), (SELECT $node_id FROM Students WHERE ID = 1)),
((SELECT $node_id FROM Teachers WHERE ID = 2), (SELECT $node_id FROM Students WHERE ID = 8)),
((SELECT $node_id FROM Teachers WHERE ID = 3), (SELECT $node_id FROM Students WHERE ID = 1)),
((SELECT $node_id FROM Teachers WHERE ID = 3), (SELECT $node_id FROM Students WHERE ID = 7)),
((SELECT $node_id FROM Teachers WHERE ID = 4), (SELECT $node_id FROM Students WHERE ID = 3)),
((SELECT $node_id FROM Teachers WHERE ID = 5), (SELECT $node_id FROM Students WHERE ID = 5)),
((SELECT $node_id FROM Teachers WHERE ID = 6), (SELECT $node_id FROM Students WHERE ID = 6)),
((SELECT $node_id FROM Teachers WHERE ID = 7), (SELECT $node_id FROM Students WHERE ID = 9));

-- Студенты, записанные на курс "Базы данных"
SELECT s.FullName
FROM Students s, EnrolledIn e, Courses c
WHERE MATCH(s-(e)->c)
  AND c.Title = N'Базы данных';

-- Преподаватели, которые консультируют студентов, записанных на курс "Компьютерные сети"
SELECT DISTINCT t.FullName
FROM Teachers t, Advises a, Students s, EnrolledIn e, Courses c
WHERE MATCH(t-(a)->s-(e)->c)
  AND c.Title = N'Компьютерные сети';

-- Курсы, на которые записан студент "Алиса Иванова"
SELECT c.Title
FROM Students s, EnrolledIn e, Courses c
WHERE MATCH(s-(e)->c)
  AND s.FullName = N'Алиса Иванова';

-- Преподаватели, ведущие более одного курса
SELECT t.FullName, COUNT(*) AS NumCourses
FROM Teachers t, Teaches te, Courses c
WHERE MATCH(t-(te)->c)
GROUP BY t.FullName
HAVING COUNT(*) > 1;

-- Преподаватели и имена студентов, которых они консультируют
SELECT t.FullName, s.FullName
FROM Teachers t, Advises a, Students s
WHERE MATCH(t-(a)->s);

SELECT 
    s1.FullName AS StudentName,
    STRING_AGG(s2.FullName, '->') WITHIN GROUP (GRAPH PATH) AS StudentConnections
FROM 
    Students AS s1,
    EnrolledIn FOR PATH AS e1,
    Courses FOR PATH AS c,
    EnrolledIn FOR PATH AS e2,
    Students FOR PATH AS s2
WHERE 
    MATCH(SHORTEST_PATH(s1(-(e1)->c<-(e2)-s2){1,3}))
    AND s1.id = 1;

SELECT 
    s1.FullName AS Student,
    STRING_AGG(c.Title, ' -> ') WITHIN GROUP (GRAPH PATH) AS CourseConnection
FROM 
    Students AS s1,
    EnrolledIn FOR PATH AS e1,
    Courses FOR PATH AS c,
    EnrolledIn FOR PATH AS e2,
	Students FOR PATH AS s2
WHERE 
    MATCH(SHORTEST_PATH(s1(-(e1)->c<-(e2)-s2)+))
    AND s1.id = 3;


SELECT S.Id AS IdFirst
	, S.FullName AS First
	, CONCAT(N'student (', S.Id, ')') AS [First image name]
	, C.Id AS IdSecond
	, C.Title AS Second
	, CONCAT(N'course (', C.Id, ')') AS [Second image name]
FROM Students AS S
	, EnrolledIn AS ei
	, Courses AS C
WHERE MATCH(S-(ei)->C)

SELECT T.Id AS IdFirst
	, T.FullName AS First
	, CONCAT(N'teacher (', T.Id, ')') AS [First image name]
	, C.Id AS IdSecond
	, C.Title AS Second
	, CONCAT(N'course (', C.Id, ')') AS [Second image name]
FROM Teachers AS T
	, Teaches AS ts
	, Courses AS C
WHERE MATCH(T-(ts)->C)

SELECT T.Id AS IdFirst
	, T.FullName AS First
	, CONCAT(N'teacher (', T.Id, ')') AS [First image name]
	, S.Id AS IdSecond
	, S.FullName AS Second
	, CONCAT(N'student (', S.Id, ')') AS [Second image name]
FROM Teachers AS T
	, Advises AS a
	, Students AS S
WHERE MATCH(T-(a)->S)