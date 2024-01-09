--�������� �� ������� �������� ������, ��� ���� �������� �� ����� 3, 5, 6, 10 �  ����� �������� 'eee'.
SELECT *
FROM [��������]
WHERE [��������].[����] NOT IN (3,5,6,10) AND [��������].[����� ��������]='eee'

--������� � ��������� ���������, ������� �� ���� �� ��������� ������� (������ ������ ����� left join).
SELECT [��������].[� ��������]
FROM [��������]
LEFT JOIN [�������������] ON  [��������].[��� ��������] = [�������������].[��� ��������]
WHERE [�������������].[��� ��������] IS NULL

--�������� ������ �� ������� ���� � ����� ������� = 2015 � ��� �������� (������� A���, �����������, �������). 
--������� ��� ����� ����, ����� �������� � �������, ����� ����������.
SELECT [����������].[��������������� � ����], [�������������].[����� ��������], [�������������].[����� �������], [�������].[����� ����������]
FROM [����������]
JOIN [�������������] ON [����������].[��� ����] = [�������������].[��� ����]
JOIN [�������] ON [�������������].[�������] = [�������].[��� ��������] 
WHERE [����������].[��� ������� ����] = 2015

--������� �����������, ����� ������� ���������� � ����� � ��� �� �����? 
--����������� �� ����������. ���������� ������ ��, ��� ���������� ������ 1.
SELECT SUBSTRING(T1.FIRST_NAME,1,1), COUNT(SUBSTRING(T1.FIRST_NAME,1,1)) AS QNAME
FROM [EMPLOYEES] T1
JOIN (SELECT SUBSTRING(FIRST_NAME,1,1) AS FL
		FROM [EMPLOYEES]
		GROUP BY SUBSTRING(FIRST_NAME,1,1)
		HAVING COUNT(SUBSTRING(FIRST_NAME,1,1))>1) T2 ON SUBSTRING(T1.FIRST_NAME,1,1) = T2.FL
GROUP BY SUBSTRING(T1.FIRST_NAME,1,1)
ORDER BY COUNT(SUBSTRING(T1.FIRST_NAME,1,1))

--������� �����������, ������� �������� � ����� � ��� �� ������ � �������� ���������� ��������?
SELECT T3.DEPARTMENT_NAME, T3.QE 
FROM (
SELECT T2.DEPARTMENT_NAME, COUNT(T1.EMPLOYEE_ID) OVER (PARTITION BY T1.DEPARTMENT_ID, T1.SALARY) AS QE
FROM [EMPLOYEES] T1
JOIN [DEPARTMENTS] T2 ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
)
WHERE T.QE>1
ORDER BY T3.QE

--�������� ���� �����������, ������� ������ �� �����������.
SELECT T1.*
FROM [EMPLOYEES] T1
JOIN [DEPARTMENTS] T2 ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
WHERE T2.DEPARTMENT_ID IS NULL

--�������� ������ ����������� � ����� ������� ������.
SELECT T1.*
FROM [EMPLOYEES] T1
WHERE CONCAT(TRIM(T1.FIRST_NAME),TRIM(T1.LAST_NAME))=
	(SELECT MAX(LEN(CONCAT(TRIM(T2.FIRST_NAME),TRIM(T2.LAST_NAME))))
		FROM [EMPLOYEES] T2)

--� ������� Employees �������� ��� ����������. � ������� Job_history �������� ����������, 
--������� �������� ��������. �������� ������ � ���� ����������� � � �� ������� � �������� 
--(�������� ��� ������� �������� � ����� �����)

SELECT T1.FIRST_NAME
	,CASE WHEN T2.EMPLOYEE_ID IS NULL THEN '��������'
			ELSE CONCAT('������',FORMAT(T2.END_DATE'D', 'en-gb' )) END AS STATUS
FROM [EMPLOYEES] T1
LEFT JOIN [JOB_HISTORY] T2 ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID

