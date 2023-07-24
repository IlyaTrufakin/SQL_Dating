USE Dating
GO

--Во всех заданиях (кроме 9 и 10) информацию о пользователях необходимо показывать в следующем виде:
-- уникальный номер страницы пользователя в социальной сети
-- ник
-- возраст
-- пол
--+ дополнительные поля, указанные в запросе.


--1. Показать TOP-10 пользователей с самым высоким средним рейтингом анкеты (Anketa_Rate, AVG, 
--средний рейтинг должен быть представлен в виде вещественного числа)



SELECT TOP 10
	Users.nick AS [Ник пользователя],
	Users.user_id AS [Страница в соцсети],
	Users.age AS [Возраст],
	Gender.name AS Пол,
	ROUND(AVG(CAST(Anketa_rate.rating AS FLOAT)),1) AS [Средний рейтинг]
FROM 
	Anketa_rate
JOIN 
	Users ON users.user_id = Anketa_rate.id_kogo
JOIN 
	Gender ON Gender.id = Users.sex
GROUP BY 
	Users.nick, Users.user_id, Users.age, Gender.name
ORDER BY 
	[Средний рейтинг] DESC





--2. Показать всех пользователей с высшим образованием, которые не курят, не пьют и не употребляют наркотики
SELECT
	Users.nick AS [Ник пользователя],
	Users.user_id AS [Страница в соцсети],
	Users.age AS [Возраст],
	Gender.name AS Пол,
	Education.name AS Образование,
	Smoking.name AS [Отношение к курению],
	Drinking.name AS [Отношение к спиртному],
	Drugs.name AS [Отношение к наркотикам]
FROM 
	Users
JOIN 
	Gender ON Gender.id = Users.sex
JOIN 
	Education ON Education.id = Users.id_education
JOIN 
	Smoking ON Smoking.id = Users.my_smoke
JOIN 
	Drinking ON Drinking.id = Users.my_drink
JOIN 
	Drugs ON Drugs.id = Users.my_drugs
WHERE 
	Education.id >= 4 AND Smoking.id = 1 AND Drinking.id=1 AND Drugs.id=1
ORDER BY 
	[Возраст] DESC




--3. Сделать запрос, который позволит найти пользователей по указанным данным:
-- ник (не обязательно точный)
-- пол
-- минимальный и максимальный возраст
-- минимальный и максимальный рост
-- минимальный и максимальный вес
DECLARE @NickName NVARCHAR(20) = 'слад'
DECLARE @MinAge INT = 13
DECLARE @MaxAge INT = 23
DECLARE @MinRost INT = 130
DECLARE @MaxRost INT = 230
DECLARE @MinWeight INT = 30
DECLARE @MaxWeight INT = 200

SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.age AS [Возраст],
    Gender.name AS [Пол],
    Users.rost AS [Рост, см],
    Users.ves AS [Вес, кг]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
WHERE
    LOWER(Users.nick) LIKE '%' + LOWER(@NickName) + '%'
    AND Users.age >= @MinAge AND Users.age <= @MaxAge
    AND Users.rost >= @MinRost AND Users.rost <= @MaxRost
    AND Users.ves >= @MinWeight AND Users.ves <= @MaxWeight
ORDER BY
    [Ник пользователя] DESC;




--4. Показать всех стройных голубоглазых блондинок, затем всех спортивных кареглазых брюнетов,
--а в конце их общее количество (UNION, одним запросом на SELECT)

-- объединение через UNION ---------------------------------------------------------------------------------
SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Users.Rost AS [Рост, см],
    Users.Ves AS [Вес, кг],
	Eyescolor.Name AS [Цвет глаз],
	Haircolor.Name AS [Цвет волос],
	Figure.Name AS [Телосложение]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Eyescolor ON Eyescolor.id = Users.eyes_color
JOIN
	Haircolor ON Haircolor.id = Users.hair_color
JOIN
	Figure ON Figure.id = Users.my_build
WHERE
    Users.sex = 2
    AND Users.eyes_color= 4
    AND Users.hair_color = 1
    AND Users.my_build = 2

UNION

SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Users.Rost AS [Рост, см],
    Users.Ves AS [Вес, кг],
	Eyescolor.Name AS [Цвет глаз],
	Haircolor.Name AS [Цвет волос],
	Figure.Name AS [Телосложение]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Eyescolor ON Eyescolor.id = Users.eyes_color
JOIN
	Haircolor ON Haircolor.id = Users.hair_color
JOIN
	Figure ON Figure.id = Users.my_build
WHERE
    Users.sex = 1
    AND Users.eyes_color= 2
    AND Users.hair_color = 4
    AND Users.my_build = 4

ORDER BY
	[Пол] ASC;



-- одним запросом на SELECT----------------------------------------------------------------------------------
SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Users.Rost AS [Рост, см],
    Users.Ves AS [Вес, кг],
	Eyescolor.Name AS [Цвет глаз],
	Haircolor.Name AS [Цвет волос],
	Figure.Name AS [Телосложение]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Eyescolor ON Eyescolor.id = Users.eyes_color
JOIN
	Haircolor ON Haircolor.id = Users.hair_color
JOIN
	Figure ON Figure.id = Users.my_build
WHERE
    (Users.sex = 2
    AND Users.eyes_color= 4
    AND Users.hair_color = 1
    AND Users.my_build = 2)
	OR
	(Users.sex = 1
    AND Users.eyes_color= 2
    AND Users.hair_color = 4
    AND Users.my_build = 4)

ORDER BY
	[Пол] ASC;



--5. Показать всех программистов с пирсингом, которые к тому же умеют вышивать крестиком (Moles, Framework и Interes)
SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Moles.Name AS [Дефекты кожи],
    framework.Name AS [Профессия],
	Interes.Name AS [Хобби]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	framework ON framework.id = Users.id_framework
JOIN
	Users_moles ON Users_moles.user_id = Users.user_id
JOIN
	Moles ON Moles.id = Users_moles.moles_id
JOIN
	Users_interes ON Users_interes.user_id = Users.user_id
JOIN
	interes ON Users_interes.interes_id = interes.id
WHERE
    Users.id_framework = 1
    AND Moles.id = 1
    AND interes.id = 23
ORDER BY
	Users.Age ASC;



--6. Показать сколько подарков подарили каждому пользователю, у которого знак зодиака Рыбы
SELECT
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Goroskop.Name AS [Знак зодиака],
    COUNT(*) AS [Кол-во подарков]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Goroskop ON Goroskop.id = Users.id_zodiak
JOIN
	Gift_service ON Gift_service.id_to = Users.user_id
WHERE
    Users.id_zodiak = 12
GROUP BY 
	Users.nick, Users.user_id, Users.Age, Gender.Name, Goroskop.Name
ORDER BY
	[Кол-во подарков] DESC;


--7. Показать как много зарабатывают себе на жизнь полиглоты (знающие более 5 языков), совершенно не умеющие готовить
SELECT 
    Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Richness.Name AS [Обеспеченность],
	Kitchen.Name AS [Кулинарные навыки],
	STRING_AGG(languages.Name, ', ') AS [Знание языков]
    --COUNT(languages.Name) AS [Знание языков] 
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Richness ON Richness.id = Users.my_rich
JOIN
	Kitchen ON Kitchen.id = Users.like_kitchen
JOIN
	Users_languages ON Users_languages.user_id = Users.user_id
JOIN
	Languages ON Languages.id = Users_languages.Languages_id
WHERE
    Users.like_kitchen = 2
GROUP BY 
	Users.nick, Users.user_id, Users.Age, Gender.Name, Richness.Name, Kitchen.Name
HAVING
	COUNT(Languages.id) >= 5
ORDER BY
	 [Знание языков] DESC;



--8. Показать всех буддистов, которые занимаются восточными единоборствами, живут на вокзале, и в свободное время катаются на скейте
SELECT 
	Users.nick AS [Ник пользователя],
    Users.user_id AS [Страница в соцсети],
    Users.Age AS [Возраст],
    Gender.Name AS [Пол],
    Religion.Name AS [Вероисповедание],
	Residence.Name AS [Место проживания],
	STRING_AGG( Sport.Name, ', ') AS [Спорт]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Religion ON Religion.id = Users.religion
JOIN
	Users_sport ON Users_sport.user_id = Users.user_id
JOIN
	Sport ON Sport.id = Users_sport.sport_id
JOIN
	Residence ON Residence.id = Users.my_home
WHERE
    Users.religion = 6
	AND Users.my_home = 9
	AND (Sport.id = 6 OR Sport.id = 9)
GROUP BY 
	Users.user_id, Users.nick, Users.Age, Gender.Name, Religion.Name, Residence.Name
ORDER BY
	 Users.Age ASC;




--9. Показать возрастную аудиторию пользователей в виде:
--возраст	  кол-во    %
-- до 18	   2000	   40.0
-- 18-24	   1500	   30.0
-- 24-30	   1000	   20.0
-- от 30	    500	   10.0

-- 1й вариант
SELECT
    CASE
        WHEN Users.Age < 18 THEN 'до 18'
        WHEN Users.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Users.Age BETWEEN 25 AND 30 THEN '24-30'
        ELSE 'от 30'
    END AS [возраст],
    COUNT(*) AS [количество],
	CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Users) AS NUMERIC(10, 2)) AS [%]
FROM
    Users
GROUP BY 
    CASE
        WHEN Users.Age < 18 THEN 'до 18'
        WHEN Users.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Users.Age BETWEEN 25 AND 30 THEN '24-30'
        ELSE 'от 30'
   END
ORDER BY
    MIN(Users.Age);





-- 2й вариант
SELECT
    'до 18' AS [возраст],
    COUNT(*) AS [количество],
    CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Users ) AS NUMERIC(10, 2)) AS [%]
FROM
    Users
WHERE
    Users.Age < 18
UNION 
SELECT
	'18-24' AS [возраст],
    COUNT(*) AS [количество],
	CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Users) AS NUMERIC(10, 2)) AS [%]
FROM
    Users
WHERE
	Users.Age BETWEEN 18 AND 24
UNION
SELECT
	'24-30' AS [возраст],
    COUNT(*) AS [количество],
	CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Users) AS NUMERIC(10, 2)) AS [%]
FROM
    Users
WHERE
	Users.Age BETWEEN 25 AND 30
UNION
SELECT
	'от 30' AS [возраст],
    COUNT(*) AS [количество],
	CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Users) AS NUMERIC(10, 2)) AS [%]
FROM
    Users
WHERE
	Users.Age > 30





--10*. Показать 5 самых популярных слов, отправленных в личных сообщениях, и то, как часто они встречаются
-- как то коряво получается удалять небуквенные символы - должен быть способ удобнее?
SELECT DISTINCT TOP 5
    UPPER(value) AS [Слова],
    COUNT(*) AS [Случаи использования]
FROM
	Messages
CROSS APPLY 
	STRING_SPLIT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Messages.mess, '.', ' '), '?', ' '), '=', ' '), ',', ' '), '!', ' '), ':', ' '),')', ' '), ' ')
WHERE 
	LEN(value) >= 4
GROUP BY 
	UPPER(value)
ORDER BY 
	COUNT(*) DESC

