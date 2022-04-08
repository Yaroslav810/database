# 1. Добавить внешние ключи.
ALTER TABLE lesson
    ADD FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher);
ALTER TABLE lesson
    ADD FOREIGN KEY (id_subject) REFERENCES subject (id_subject);
ALTER TABLE lesson
    ADD FOREIGN KEY (id_group) REFERENCES `group` (id_group);
ALTER TABLE student
    ADD FOREIGN KEY (id_group) REFERENCES `group` (id_group);
ALTER TABLE mark
    ADD FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson);
ALTER TABLE mark
    ADD FOREIGN KEY (id_student) REFERENCES student (id_student);

# 2. Выдать оценки студентов по информатике если они обучаются данному предмету.
# Оформить выдачу данных с использованием view.
CREATE VIEW computer_science_grades AS
SELECT st.name, m.mark
FROM student st
         JOIN mark m ON st.id_student = m.id_student
         JOIN lesson l ON l.id_lesson = m.id_lesson
         JOIN subject su ON su.id_subject = l.id_subject
WHERE su.name = 'Информатика';

SELECT *
FROM computer_science_grades;

# 3. Дать информацию о должниках с указанием фамилии студента и названия предмета.
# Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе.
# Оформить в виде процедуры, на входе идентификатор группы.
DROP PROCEDURE IF EXISTS get_debtors;
CREATE PROCEDURE get_debtors(IN group_id int)
BEGIN
    SELECT st.name, su.name, m.mark
    FROM student st
             LEFT JOIN `group` g ON g.id_group = st.id_group
             LEFT JOIN lesson l ON g.id_group = l.id_group
             LEFT JOIN subject su ON su.id_subject = l.id_subject
             LEFT JOIN mark m ON l.id_lesson = m.id_lesson AND st.id_student = m.id_student
    WHERE st.id_group = group_id
    GROUP BY st.name, su.name
    HAVING COUNT(m.id_mark) = 0;
END;
CALL
    get_debtors(1);

# 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым
# занимается не менее 35 студентов.
SELECT subject.name, AVG(mark.mark)
FROM subject
         JOIN lesson ON subject.id_subject = lesson.id_subject
         JOIN `group` ON lesson.id_group = `group`.id_group
         JOIN student ON `group`.id_group = student.id_group
         JOIN mark ON lesson.id_lesson = mark.id_lesson
GROUP BY subject.name
HAVING COUNT(student.id_student) >= 35;

# 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с
# указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
# значениями NULL поля оценки
SELECT st.name, su.name, l.date, m.mark
FROM student st
         LEFT JOIN `group` g ON st.id_group = g.id_group AND g.name = 'ВМ'
         LEFT JOIN lesson l ON g.id_group = l.id_subject
         LEFT JOIN mark m ON l.id_lesson = m.id_lesson
         LEFT JOIN subject su ON l.id_subject = su.id_subject;

# 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05,
# повысить эти оценки на 1 балл.
UPDATE mark m
    JOIN student st ON m.id_student = st.id_student
    JOIN `group` g ON st.id_group = g.id_group
    JOIN lesson l ON g.id_group = l.id_group
    JOIN subject su ON l.id_subject = su.id_subject
SET m.mark = m.mark + 1
WHERE m.mark < 5
  AND su.name = 'БД'
  AND g.name = 'ПС'
  AND l.date < '20190512';

# 7. Добавить необходимые индексы.
CREATE INDEX IX_issuance_group_name ON `group`(name);
CREATE INDEX IX_issuance_lesson_date ON lesson(date);
CREATE INDEX IX_issuance_subject_name ON subject(name);
