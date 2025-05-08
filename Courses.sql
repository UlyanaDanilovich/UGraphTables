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

CREATE TABLE EnrolledIn AS EDGE;    -- ������� -> ����
CREATE TABLE Teaches AS EDGE;       -- ������������� -> ����
CREATE TABLE Advises AS EDGE;       -- ������������� -> �������

-- ��������
INSERT INTO Students (ID, FullName) VALUES
(1, N'����� �������'),
(2, N'����� �������'),
(3, N'���� �������'),
(4, N'���� �������'),
(5, N'����� ��������'),
(6, N'���� ��������'),
(7, N'����� ������'),
(8, N'����� �����'),
(9, N'����� ���������'),
(10, N'������ ��������');

-- �������������
INSERT INTO Teachers (ID, FullName, Position) VALUES
(1, N'���� ��������� ������', N'������'),
(2, N'����� �������� �������', N'���������'),
(3, N'���� ���������� �������', N'���������'),
(4, N'����� ���������� ��������', N'������'),
(5, N'������ ������� ��������', N'������� �������������'),
(6, N'�������� ����������� ��������', N'���������'),
(7, N'������� ������������� ������', N'������'),
(8, N'������� �������� �������', N'���������'),
(9, N'����� ������������ �������', N'������'),
(10, N'���� ��������� ��������', N'���������');

-- ����������
INSERT INTO Courses (ID, Title, Credits) VALUES
(1, N'���� ������', 4),
(2, N'�������������� ������', 5),
(3, N'���������������� �� C++', 5),
(4, N'���������', 2),
(5, N'������������ ����', 4),
(6, N'�������� ��������', 5),
(7, N'������ ������������', 3),
(8, N'������', 4),
(9, N'���������� ����', 2),
(10, N'������� ��������', 3);

-- ������� ������� �� ����
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

-- ������������� ���� ����
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

-- ������������� �������� �������� 
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

-- ��������, ���������� �� ���� "���� ������"
SELECT s.FullName
FROM Students s, EnrolledIn e, Courses c
WHERE MATCH(s-(e)->c)
  AND c.Title = N'���� ������';

-- �������������, ������� ������������� ���������, ���������� �� ���� "������������ ����"
SELECT DISTINCT t.FullName
FROM Teachers t, Advises a, Students s, EnrolledIn e, Courses c
WHERE MATCH(t-(a)->s-(e)->c)
  AND c.Title = N'������������ ����';

-- �����, �� ������� ������� ������� "����� �������"
SELECT c.Title
FROM Students s, EnrolledIn e, Courses c
WHERE MATCH(s-(e)->c)
  AND s.FullName = N'����� �������';

-- �������������, ������� ����� ������ �����
SELECT t.FullName, COUNT(*) AS NumCourses
FROM Teachers t, Teaches te, Courses c
WHERE MATCH(t-(te)->c)
GROUP BY t.FullName
HAVING COUNT(*) > 1;

-- ������������� � ����� ���������, ������� ��� �������������
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