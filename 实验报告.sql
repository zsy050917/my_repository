-- 1
SELECT student.student_name, score.course_id
FROM student
JOIN score ON student.student_id = score.student_id;

-- 2
SELECT student.student_name, course.course_name, score.score_grade
FROM student
JOIN score ON student.student_id = score.student_id
JOIN course ON score.course_id = course.course_id;

-- 3
SELECT student.student_name, course.course_name, score.score_grade
FROM student
left JOIN score ON student.student_id = score.student_id
left JOIN course ON score.course_id = course.course_id;

-- 4
SELECT S.student_name
FROM student S
JOIN score ON S.student_id = score.student_id
JOIN course ON score.course_id = course.course_id
WHERE course.course_name = '管理学';

-- 5
SELECT x.student_name
FROM student x
JOIN score ON x.student_id = score.student_id
JOIN course ON score.course_id = course.course_id AND course.course_name = '计算机文化基础'
WHERE EXISTS
	(SELECT *
	 FROM student y
	 JOIN score ON y.student_id = score.student_id
	 JOIN course ON score.course_id = course.course_id AND course.course_name = '管理学'
	 WHERE x.student_id = y.student_id
	 );

-- 6
SELECT y.student_name
FROM student y
JOIN score sy ON y.student_id = sy.student_id
JOIN course cy ON sy.course_id = cy.course_id 
WHERE cy.course_name = '管理学'
AND NOT EXISTS (
    SELECT 1
    FROM score sx
    JOIN course cx ON sx.course_id = cx.course_id
    WHERE cx.course_name = '计算机文化基础'
    AND sx.student_id = y.student_id
);

-- 7
SELECT student_name
FROM student 
WHERE student.student_entrancescore > (
	SELECT AVG(student.student_entrancescore)
	FROM student);

-- 8
SELECT student_id
FROM student 
WHERE student_partymember = 1 
UNION  
SELECT DISTINCT score.student_id  
FROM score
WHERE course_id = '04010101';

-- 9 
SELECT SX.student_name
FROM student SX
WHERE SX.student_sex = '女'
AND SX.student_entrancescore > (
	SELECT MAX(SY.student_entrancescore)
	FROM student SY
	WHERE SY.student_sex = '男'
	);
	
-- 10
SELECT SX.student_name
FROM student SX
WHERE SX.student_sex = '男'
AND SX.student_entrancescore > ANY(
SELECT SY.STUDENT_ENTRANCESCORE
FROM student SY
WHERE SY.STUDENT_SEX = '女'
);

-- 11
SELECT x.course_name AS 课程名称, Y.COURSE_NAME AS 先修课
FROM course X, course Y
WHERE X.course_prerequisite = Y.course_id;

-- 12
SELECT X.course_id
FROM score X
WHERE X.student_id = '2021094002'
AND EXISTS(
SELECT *
FROM score Y
WHERE Y.STUDENT_ID = '2021094001'
AND Y.SCORE_GRADE > X.score_grade
);

-- 13
SELECT SX.student_name
FROM student SX
WHERE SX.student_id != '2021094001'
AND EXISTS (
SELECT *
FROM score
WHERE score.STUDENT_ID = SX.student_id
AND score.COURSE_ID IN
	(SELECT COURSE_ID
	 FROM SCORE
	 WHERE score.STUDENT_ID = '2021094001'
	 )
);

-- 14
SELECT SX.STUDENT_NAME
FROM student SX
WHERE NOT EXISTS
	(SELECT *
	 FROM SCORE
	 WHERE score.course_id NOT IN
	 	(SELECT Y.course_id
		 FROM score Y
		 WHERE Y.student_id = SX.student_id)
	);
	
-- 15
SELECT SX.STUDENT_NAME
FROM student SX
WHERE NOT EXISTS 
	(SELECT *
	 FROM score scx
	 WHERE scx.student_id = '2021094003'
	 AND NOT exists
	 (SELECT *
	  FROM score scy
	  WHERE scy.student_id = SX.student_id
	        AND scy.course_id = scx.course_id
	   )
	);
	
-- 16
SELECT ifnull(student.student_sex, '总计') AS 性别, COUNT(*) AS 人数
FROM student
JOIN class ON student.student_class = class.class_id
WHERE class.class_name = '国际贸易081'
GROUP BY student.student_sex WITH ROLLUP;

-- 17
SELECT score.course_id,
	(SELECT COUNT(*) FROM score AS s1
	 WHERE s1.score_grade >=80 AND s1.course_id = score.course_id) 良好以上,
	(SELECT COUNT(*) FROM score AS s2
	 WHERE s2.score_grade <80 AND s2.course_id = score.course_id) 良好以下,
	COUNT(*) AS 合计
FROM score
GROUP BY score.course_id;

-- 17_2
SELECT ifnull(course_id, '总'),
		 SUM(case when score_grade >= 80 then 1 ELSE 0 END) AS 良好以上,
		 SUM(case when score_grade < 80 then 1 ELSE 0 END) AS 良好以下,
		 COUNT(*) AS 合计
FROM score
GROUP BY course_id WITH ROLLUP;