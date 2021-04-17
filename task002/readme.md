# Задание 2

## Однотабличные запросы 

### 1a. Вывести всеми возможными способами имена и фамилии студентов, средний балл которых от 4 до 4.5

```sql
SELECT name, surname, score
FROM student
WHERE score >= 4 AND score <= 4.5
```
### 1b

```sql
SELECT name, surname, score
FROM student
WHERE score BETWEEN 4 AND 4.5
```

### 2. Познакомиться с функцией CAST. Вывести при помощи неё студентов заданного курса (использовать Like)

```sql
SELECT name, surname, n_group
FROM student
WHERE CAST (n_group AS varchar) LIKE '2%'
```

### 3. Вывести всех студентов, отсортировать по убыванию номера группы и имени от а до я

```sql
SELECT name, surname, n_group
FROM student
ORDER BY n_group DESC, name 
``` 

### 4. Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему

```sql
SELECT name, surname, score
FROM student
WHERE score >= 4 
ORDER BY score DESC
```

### 5. Вывести на экран название и риск футбола и хоккея

```sql
SELECT name, risk
FROM hobby
WHERE name = 'Футбол' OR name = 'Хоккей'
```

### 6. Вывести id хобби и id студента которые начали заниматься хобби между двумя заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби

```sql
SELECT 
student_id, hobby_id, 
date_start, date_finish
FROM student_hobby
WHERE date_start BETWEEN 
'2019-04-09'::DATE AND '2020-01-26'::DATE AND 
date_finish IS NULL
```

### 7. Вывести студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему

```sql
SELECT name, surname, score
FROM student
WHERE score >= 4.5
ORDER BY score DESC
```

### 8. Из запроса №7 вывести несколькими способами на экран только 5 студентов с максимальным баллом

```sql
SELECT name, surname, score
FROM student
WHERE score >= 4.5
ORDER BY score DESC
LIMIT 5
```

### 9. Выведите хобби и с использованием условного оператора сделайте риск словами

```sql
SELECT name, risk,
CASE
WHEN risk >= 0.8 THEN 'очень высокий'
WHEN risk >= 0.6 AND risk < 0.8 THEN 'высокий'
WHEN risk >= 0.4 AND risk < 0.6 THEN 'средний'
WHEN risk >= 0.2 AND risk < 0.4 THEN 'низкий'
ELSE 'очень низкий'
END
FROM hobby
```

### 10. Вывести 3 хобби с максимальным риском

```sql
SELECT name, risk
FROM hobby
ORDER BY risk DESC
LIMIT 3
```

## Групповые запросы

### 1. Выведите на экран номера групп и количество студентов, обучающихся в них

```sql
SELECT count(*) count_students, n_group
FROM student
GROUP BY n_group
```

### 2. Выведите на экран для каждой группы максимальный средний балл

```sql
SELECT MAX(score) max_score, n_group
FROM student
GROUP BY n_group
```

### 3. Подсчитать количество студентов с каждой фамилией

```sql
SELECT count(*) count_students, surname
FROM student
GROUP BY surname
```

### 4. Подсчитать студентов, которые родились в каждом году

```sql
SELECT extract (YEAR FROM s.date_birth) as birth_year, count(*) count_st
FROM student s
GROUP BY extract (YEAR FROM s.date_birth); 
```

### 5. Для студентов каждого курса подсчитать средний балл

```sql
SELECT AVG(score)::NUMERIC(3, 2) averange_score, n_group / 1000
FROM student
GROUP BY n_group / 1000 
```

### 6. Для студентов заданного курса вывести один номер группы с максимальным средним баллом

```sql
WITH avg_by_group AS (
SELECT AVG(score)::NUMERIC(3, 2) as a_s, n_group
FROM student st
GROUP BY n_group
)
SELECT n_group, a_s
FROM avg_by_group
WHERE n_group / 1000 = 2
ORDER BY a_s DESC
LIMIT 1
```

### 7. Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.

```sql
WITH avg_by_group AS (
SELECT AVG(score)::NUMERIC(3, 2) as a_s, n_group
FROM student st
GROUP BY n_group
)
SELECT n_group, a_s
FROM avg_by_group
WHERE a_s <= 3.5
ORDER BY a_s
```
 
### 8. Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, средний балл в группе, минимальный балл в группе

```sql
SELECT
n_group, count(*) st,
MAX(score) max_score,
AVG(score)::NUMERIC(3, 2) averange_score,
MIN(score) min_score
FROM student
GROUP BY n_group
```

### 9. Вывести студента/ов, который/ые имеют наибольший балл в заданной группе

```sql
SELECT *
FROM student
WHERE (score, n_group) IN (
SELECT MAX(score), n_group
FROM student
GROUP BY n_group
) AND n_group = 3233
```

### 10. Аналогично 9 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.

```sql
SELECT *
FROM student
WHERE (score, n_group) IN (
SELECT MAX(score), n_group
FROM student
GROUP BY n_group
) 
```

## Многотабличные запросы

### 1. Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.

```sql
SELECT s.name, s.surname, h.name
FROM student s
INNER JOIN student_hobby sh
ON sh.student_id = s.id
INNER JOIN hobby h
ON sh.hobby_id = h.id
ORDER BY s.id
```

### 2. Вывести информацию о студенте, занимающимся хобби самое продолжительное время.

```sql
WITH diff_date_sh AS(
SELECT student_id,
CASE 
WHEN date_finish IS NULL THEN 
CURRENT_DATE - date_start
ELSE 
date_finish - date_start
END pass_days
FROM student_hobby
)
SELECT *
FROM student s
INNER JOIN diff_date_sh dsh
ON dsh.student_id = s.id
ORDER BY dsh.pass_days DESC
LIMIT 1
```

### 3. Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.

```sql
SELECT st.id, st.name, st.surname, st.date_birth
FROM student st
INNER JOIN student_hobby sh
ON sh.student_id = st.id AND sh.date_finish IS NULL
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE st.score >
(SELECT avg(score) avg_score
FROM student) AND (SELECT SUM(risk) FROM hobby) > 0.9
```

### 4. Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.

```sql
SELECT st.id, st.name, st.surname, st.date_birth, h.name, 
sh.date_start, sh.date_finish,
((sh.date_finish - sh.date_start)/30) duration
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND sh.date_finish IS NOT NULL
INNER JOIN hobby h
ON sh.hobby_id = h.id
```

### 5. Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.

```sql
SELECT st.id, st.name, st.surname, st.date_birth, h.name, 
((CURRENT_DATE - st.date_birth)/365) years_old
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND sh.date_finish IS NULL 
INNER JOIN hobby h
ON sh.hobby_id = h.id 
WHERE ((CURRENT_DATE - st.date_birth)/365) = 21 
GROUP BY st.id 
AND count(sh.hobby_id) > 1
```

### 6. Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.

```sql
SELECT st.n_group, avg(score)::NUMERIC(3, 2) avg_score 
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
INNER JOIN hobby h 
ON sh.hobby_id = h.id AND sh.date_finish IS NOT NULL
GROUP BY st.n_group 
```

### 7. Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.

```sql
SELECT st.id, st.n_group, h.name, h.risk,
 (CURRENT_DATE - sh.date_start)/30 duration, sh.date_start, sh.date_finish
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
INNER JOIN hobby h 
ON sh.hobby_id = h.id
ORDER BY duration DESC 
LIMIT 1
```
 
### 8. Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.

```sql
SELECT h.name
FROM student_hobby sh 
INNER JOIN student st
ON sh.student_id = st.id
INNER JOIN hobby h 
ON sh.hobby_id = h.id
WHERE st.score = (
SELECT max(score)
FROM student)
```

### 9. Найти все действующие хобби, которыми увлекаются троечники 2-го курса.

```sql
SELECT h.name, st.name, st.surname, st.n_group
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
```

### 10. Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.

```sql
SELECT st.n_course, count(student_id) count_st, count(active_hobby) 
filter (WHERE active_hobby > 1), (count(active_hobby) 
filter (WHERE active_hobby > 1) *1.0 / 
count(student_id))
FROM(
SELECT (st.n_group/1000) n_course,
st.id student_id,
count(sh.hobby_id) active_hobby
FROM student st
LEFT JOIN student_hobby sh
ON sh.student_id = st.id 
AND
sh.date_finish IS NULL
GROUP BY (n_course, st.id)
) st
GROUP BY n_course 
HAVING (count(active_hobby) 
filter (WHERE active_hobby > 1)*1.0 / 
count(student_id)) > 0.5
```

### 11. Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.

```sql
SELECT n_group, count(id) all_students, 
count(id) filter(WHERE score >= 4) 
count_4, 
count(id) filter(WHERE score >= 4)*1.0 /
count(id) 
FROM student
GROUP BY n_group
HAVING (count(id) filter
(WHERE score >= 4)*1.0 /
count(id)) > 0.6
```

### 12. Для каждого курса подсчитать количество различных действующих хобби на курсе.

```sql
WITH T_12 AS (
SELECT
DISTINCT ON ((sh.hobby_id, st.n_group / 1000))
floor(st.n_group / 1000) as n_course,
sh.hobby_id
FROM student st
INNER JOIN student_hobby sh
ON sh.student_id = st.id AND 
sh.date_finish IS NULL
)
SELECT n_course, count(hobby_id)
FROM T_12
GROUP BY n_course
```

### 13. Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.

```sql
SELECT st.id, st.surname,
st.name, st.date_birth,
st.n_group / 1000 n_course
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
AND sh.date_finish IS NOT NULL
OR sh.date_start IS NULL
WHERE st.score > 4.5
GROUP BY st.id
ORDER BY (st.n_group / 1000),
st.date_birth DESC
```

### 14. Создать представление, в котором отображается вся информация о студентах, которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.

```sql
CREATE OR REPLACE VIEW students_V1 AS
SELECT st.id, st.name, st.surname,
st.date_birth, st.address, st.score,
st.n_group
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND 
sh.date_finish IS NULL AND
DATE_PART('year', AGE(CURRENT_DATE,
sh.date_start)) >= 5
GROUP BY st.id
```

### 15. Для каждого хобби вывести количество людей, которые им занимаются.

```sql
SELECT count(st.id) count_students, 
sh.hobby_id
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_finish IS NULL 
GROUP BY sh.hobby_id
```

### 16. Вывести ИД самого популярного хобби.

```sql
SELECT count(st.id) count_students, 
sh.hobby_id
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_finish IS NULL 
GROUP BY sh.hobby_id
ORDER BY count(st.id) DESC
LIMIT 1
```

### 17. Вывести всю информацию о студентах, занимающихся самым популярным хобби.

```sql
SELECT st.id, st.name, st.surname,
st.date_birth, st.address, st.score,
st.n_group
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_finish IS NULL AND 
sh.hobby_id = (
SELECT sh.hobby_id
FROM student_hobby sh
WHERE sh.date_finish IS NULL
GROUP BY sh.hobby_id
ORDER BY count(sh.id) DESC
LIMIT 1 
)
```

### 18. Вывести ИД 3х хобби с максимальным риском.

```sql
SELECT h.id, h.risk
FROM hobby h
ORDER BY h.risk DESC
LIMIT 3
```

### 19. Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

```sql
SELECT st.name, st.surname, st.n_group
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_finish IS NULL 
GROUP BY (st.id, sh.date_start)
ORDER BY (CURRENT_DATE - sh.date_start) DESC
LIMIT 10
```

### 20. Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.

```sql
SELECT DISTINCT st.n_group
FROM student st
WHERE st.id IN (
SELECT sh.student_id
FROM student_hobby sh
WHERE sh.date_finish IS NULL 
GROUP BY (sh.student_id, sh.date_start)
ORDER BY (CURRENT_DATE - sh.date_start) DESC
LIMIT 10
)
```

### 21. Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.

```sql
CREATE OR REPLACE VIEW Student_T21 AS 
SELECT st.id, st.name, st.surname
FROM student st
ORDER BY st.score DESC
```

### 22. Представление: найти каждое популярное хобби на каждом курсе.

```sql
SELECT DISTINCT ON (n_course) 
h.name, (st.n_group/1000) n_course
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND 
sh.date_finish IS NULL
INNER JOIN hobby h
ON sh.hobby_id = h.id 
GROUP BY (st.n_group/1000, h.id)
ORDER BY n_course, count(sh.id)
```

### 23. Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.

```sql
CREATE OR REPLACE VIEW student_T23 AS 
SELECT h.name
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND 
sh.date_finish IS NULL 
INNER JOIN hobby h
ON sh.hobby_id = h.id
WHERE st.n_group/1000 = 2
GROUP BY (h.name, h.risk)
ORDER BY (count(st.id), h.risk) DESC
LIMIT 1
```

### 24. Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.

```sql
CREATE OR REPLACE VIEW student_T24 AS
SELECT (st.n_group/1000) n_course, 
count(st.id), count(st.id) filter 
(WHERE st.score >= 4.5)
FROM student st
GROUP BY (st.n_group/1000)
```

### 25. Представление: самое популярное хобби среди всех студентов.

```sql
CREATE OR REPLACE VIEW student_T25 AS
SELECT h.name
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_finish IS NULL 
INNER JOIN hobby h
ON sh.hobby_id = h.id
GROUP BY h.name
ORDER BY count(st.id) DESC
LIMIT 1
```

### 26. Создать обновляемое представление.

```sql
CREATE OR REPLACE VIEW student_T24 AS
SELECT (st.n_group/1000) n_course, 
count(st.id), count(st.id) filter 
(WHERE st.score >= 4.5)
FROM student st
GROUP BY (st.n_group/1000)
WITH CHECK OPTION 
```

### 29. Для каждого года рождения подсчитать количество хобби, которыми занимаются или занимались студенты.

```sql
SELECT DATE_PART('year', st.date_birth)
year_birth, count(sh.hobby_id)
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
GROUP BY DATE_PART('year', st.date_birth)
```

### 31. Для каждого месяца из даты рождения вывести средний балл студентов, которые занимаются хобби с названием «Футбол»

```sql
SELECT avg(st.score)::NUMERIC(3, 2),
DATE_PART('month', st.date_birth) 
month_birth
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id
INNER JOIN hobby h
ON sh.hobby_id = h.id AND 
h.name = 'Футбол'
GROUP BY DATE_PART('month', st.date_birth)
```

### 36. Выведите на экран сколько дней в апреле 2018 года.

```sql
SELECT '2018-05-01'-'2018-04-01'::DATEdays_in_april
```

### 37. Выведите на экран какого числа будет ближайшая суббота.

```sql
SELECT 
CURRENT_DATE + 1 +
mod((12 - extract(DOW FROM CURRENT_DATE))::INT, 7)
next_saturday
```

### 38. Выведите на экран век, а также какая сейчас неделя года и день года.

```sql
SELECT extract (CENTURY FROM CURRENT_DATE)
this_century,
extract (WEEK FROM CURRENT_DATE)
this_week,
CURRENT_DATE - '2020-12-31'::DATE this_day
```

### 39. Выведите всех студентов, которые занимались или занимаются хотя бы 1 хобби. Выведите на экран Имя, Фамилию, Названию хобби, а также надпись «занимается», если студент продолжает заниматься хобби в данный момент или «закончил», если уже не занимает.

```sql
SELECT st.name, st.surname, h.name,
CASE 
WHEN sh.date_finish IS NULL THEN
'занимается'
ELSE 'закончил'
END
FROM student_hobby sh
INNER JOIN student st
ON sh.student_id = st.id AND
sh.date_start IS NOT NULL
INNER JOIN hobby h
ON sh.hobby_id = h.id
```