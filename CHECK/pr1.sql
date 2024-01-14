--1.1 Выберите из таблицы Водители записи, где стаж водителя не равен 3, 5, 6, 10 и  место прописки 'eee'.
SELECT *
FROM [Водители]
WHERE [Водители].[Стаж] NOT IN (3,5,6,10) AND [Водители].[Место прописки]='eee'
;


--1.2 Найдите № паспортов водителей, которые ни разу не совершали поездки (решите задачу через left join).
SELECT [Водители].[№ паспорта]
FROM [Водители]
LEFT JOIN [Диспетчерская] ON  [Водители].[Код водителя] = [Диспетчерская].[Код водителя]
WHERE [Диспетчерская].[Код водителя] IS NULL
;


--1.3 Написать запрос на выборку авто с годом выпуска = 2015 и его маршруты (таблицы Aвто, Диспеческая, Маршрут). 
--Вывести рег номер авто, время прибытия и отбытия, пункт назначения.
SELECT [Автомобили].[Регистрационный № авто], [Диспетчерская].[Время прибытия], [Диспетчерская].[Время отбытия], [Маршрут].[Пункт назначения]
FROM [Автомобили]
JOIN [Диспетчерская] ON [Автомобили].[Код авто] = [Диспетчерская].[Код авто]
JOIN [Маршрут] ON [Диспетчерская].[Путевка] = [Маршрут].[Код маршрута] 
WHERE [Автомобили].[Год выпуска авто] = 2015
;


--2.1 Сколько сотрудников, имена которых начинается с одной и той же буквы? 
--Сортировать по количеству. Показывать только те, где количество больше 1.
SELECT SUBSTRING(T1.FIRST_NAME,1,1), COUNT(SUBSTRING(T1.FIRST_NAME,1,1)) AS QNAME
FROM [EMPLOYEES] T1
JOIN (SELECT SUBSTRING(FIRST_NAME,1,1) AS FL
		FROM [EMPLOYEES]
		GROUP BY SUBSTRING(FIRST_NAME,1,1)
		HAVING COUNT(SUBSTRING(FIRST_NAME,1,1))>1) T2 ON SUBSTRING(T1.FIRST_NAME,1,1) = T2.FL
GROUP BY SUBSTRING(T1.FIRST_NAME,1,1)
ORDER BY COUNT(SUBSTRING(T1.FIRST_NAME,1,1))
;


--2.2 Сколько сотрудников, которые работают в одном и том же отделе и получают одинаковую зарплату?
SELECT T3.DEPARTMENT_NAME, SUM(T3.QE) AS QE 
FROM (
SELECT T2.DEPARTMENT_NAME, T1.SALARY, COUNT(T1.EMPLOYEE_ID) AS QE
FROM [EMPLOYEES] T1
JOIN [DEPARTMENTS] T2 ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
GROUP BY T2.DEPARTMENT_NAME, T1.SALARY
) T3
WHERE T3.QE>1
GROUP BY T3.DEPARTMENT_NAME
ORDER BY T3.DEPARTMENT_NAME
;


--2.3 Показать всех сотрудников, которые никому не подчиняются.
SELECT T1.*
FROM [EMPLOYEES] T1
JOIN [DEPARTMENTS] T2 ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
WHERE T2.DEPARTMENT_ID IS NULL
;


--2.4 Получить список сотрудников с самым длинным именем.
SELECT T1.*
FROM [EMPLOYEES] T1
WHERE LEN(CONCAT(TRIM(T1.FIRST_NAME),TRIM(T1.LAST_NAME)))=
	(SELECT MAX(LEN(CONCAT(TRIM(T2.FIRST_NAME),TRIM(T2.LAST_NAME))))
		FROM [EMPLOYEES] T2)
;


--2.5 В таблице Employees хранятся все сотрудники. В таблице Job_history хранятся сотрудники, 
--которые покинули компанию. Получить репорт о всех сотрудниках и о их статусе в компании 
--(Работает или покинул компанию с датой ухода)

SELECT T1.FIRST_NAME
	,CASE WHEN T2.EMPLOYEE_ID IS NULL THEN 'Currently Working'
			ELSE CONCAT('Left the company at',' ',FORMAT(T2.END_DATE,'D','en-gb')) END AS STATUS
FROM [EMPLOYEES] T1
LEFT JOIN [JOB_HISTORY] T2 ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID
;


