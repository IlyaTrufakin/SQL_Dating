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
    Gender.Name AS [Пол]--,
 --   Moles.Name AS [Дефекты кожи]--,
 --   framework.Name AS [Профессия]--,
--	Interes.Name AS [Хобби]
FROM
    Users
JOIN
    Gender ON Gender.id = Users.sex
JOIN
	Users_moles ON Users_moles.user_id = Users.id
JOIN
	Moles ON Moles.id = Users_moles.moles_id
JOIN
	framework ON framework.id = Users.id_framework
JOIN
	Users_interes ON Users_interes.user_id = Users.id
JOIN
	interes ON Users_interes.interes_id = interes.id
WHERE
    (Users.id_framework = 1
    AND Moles.id = 1
    AND Users.my_build = 2)
	OR
	(Users.sex = 1
    AND Users.eyes_color= 2
    AND Users.hair_color = 4
    AND Users.my_build = 4)

ORDER BY
	[Пол] ASC;








SELECT * FROM Users
SELECT * FROM Drugs
SELECT * FROM Smoking
6. Показать сколько подарков подарили каждому пользователю, у которого знак зодиака Рыбы

7. Показать как много зарабатывают себе на жизнь полиглоты (знающие более 5 языков), совершенно не умеющие готовить

8. Показать всех буддистов, которые занимаются восточными единоборствами, живут на вокзале, и в свободное время катаются на скейте

9. Показать возрастную аудиторию пользователей в виде:

возраст	  кол-во    %
 до 18	   2000	   40.0
 18-24	   1500	   30.0
 24-30	   1000	   20.0
 от 30	    500	   10.0

10*. Показать 5 самых популярных слов, отправленных в личных сообщениях, и то, как часто они встречаются






--1. показать горизонтальную линию из звёздочек длиной @L
--вертикально
DECLARE @StarsCount INT = 10
WHILE (@StarsCount>0)
BEGIN
  PRINT '*'
  SET @StarsCount = @StarsCount - 1
END

--горизонтально
DECLARE @StarsCountH INT = 10
DECLARE @String nvarchar(max) = ''
WHILE (@StarsCountH>0)
BEGIN
	SET @String = @String + '*'
	SET @StarsCountH = @StarsCountH - 1
END
PRINT @String




--2. скрипт проверяет, какое сейчас время суток, и выдаёт приветствие "добрый вечер!" или "добрый день!"
DECLARE @CurrentTime TIME = GETDATE()
DECLARE @Message NVARCHAR(max)

IF @CurrentTime >= '04:30:00' AND @CurrentTime < '11:00:00'
	SET @Message = 'Доброе утро!'

ELSE IF @CurrentTime >= '11:00:00' AND @CurrentTime < '17:00:00'
    SET @Message = 'Добрый день!'

ELSE IF @CurrentTime >= '17:00:00' AND @CurrentTime < '23:00:00'
    SET @Message = 'Добрый вечер!'

ELSE
    SET @Message = 'Доброй ночи!'

PRINT @Message




--3. скрипт генерирует случайный сложный пароль длиной @PasswordLength символов
DECLARE @PasswordLength INT = 10 --  желаемая длина пароля
DECLARE @AvailableCharacters NVARCHAR(100) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_+='
DECLARE @Password NVARCHAR(max) = ''

WHILE (@PasswordLength >0)

BEGIN
    DECLARE @RandomIndex INT = ROUND(RAND() * (LEN(@AvailableCharacters) - 1) + 1, 0)
    SET @Password = @Password + SUBSTRING(@AvailableCharacters, @RandomIndex, 1)
    SET @PasswordLength = @PasswordLength - 1
END

PRINT @Password



--4. показать факториалы всех чисел от 0 до 25
DECLARE @Number INT = 0
DECLARE @Factorial NUMERIC(38, 0) = 1

WHILE (@Number <= 25)
BEGIN
    PRINT 'Факториал числа ' + CAST(@Number AS NVARCHAR(10)) + ': ' + CAST(@Factorial AS NVARCHAR(50))
    SET @Number = @Number + 1
    SET @Factorial = @Factorial * @Number
END




--5. показать все простые числа от 3 до 100000 (я уменьшил макс.число на порядок, слишком долго подсчитывает)
DECLARE @start INT = 3
DECLARE @end INT = 100000
DECLARE @primes TABLE (  Number INT) -- Создание временной таблицы для хранения информации о простых числах

WHILE (@start <= @end)
BEGIN
  DECLARE @isPrime BIT = 1
  DECLARE @divisor INT = 2

   -- Проверка, является ли число простым
  WHILE (@divisor * @divisor <= @start)
  BEGIN
    IF (@start % @divisor = 0)
    BEGIN
      SET @isPrime = 0
      BREAK
    END
    SET @divisor = @divisor + 1
  END
   -- Если число простое, добавляем его в таблицу
  IF (@isPrime = 1) INSERT INTO @primes (Number) VALUES (@start)

  SET @start = @start + 1
END

SELECT Number -- Вывод таблицы простых чисел
FROM @primes






--6. показать номера всех счастливых трамвайных билетов
DECLARE @TicketNumber INT = 100000

WHILE (@TicketNumber <= 999999)
BEGIN
    DECLARE @TicketString NVARCHAR(6) = RIGHT('000000' + CAST(@TicketNumber AS NVARCHAR(6)), 6) -- преобразование в строку 6 значн.

	-- получение суммы 3х левых чисел
    DECLARE @SumLeftHalf INT =
        CAST(SUBSTRING(@TicketString, 1, 1) AS INT) +
        CAST(SUBSTRING(@TicketString, 2, 1) AS INT) +
        CAST(SUBSTRING(@TicketString, 3, 1) AS INT)

	-- получение суммы 3х правых чисел
    DECLARE @SumRightHalf INT =
        CAST(SUBSTRING(@TicketString, 4, 1) AS INT) +
        CAST(SUBSTRING(@TicketString, 5, 1) AS INT) +
        CAST(SUBSTRING(@TicketString, 6, 1) AS INT)

    IF (@SumLeftHalf = @SumRightHalf) -- сравнение сумм
    PRINT @TicketString

    SET @TicketNumber = @TicketNumber + 1

END