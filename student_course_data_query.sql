
-- Выборка информации по ученикам на годовых курсах ЕГЭ и ОГЭ

SELECT
    c.id AS course_id,                   -- ID курса
    c.name AS course_name,               -- Название курса
    s.name AS subject_name,              -- Название предмета
    s.project AS subject_type,           -- Тип предмета
    ct.name AS course_type,              -- Тип курса
    c.starts_at AS course_start_date,    -- Дата старта курса
    u.id AS user_id,                     -- ID ученика
    u.last_name AS user_last_name,       -- Фамилия ученика
    ci.name AS user_city,                -- Город ученика
    cu.active AS student_active,         -- Ученик не отчислен с курса
    cu.created_at AS course_open_date,   -- Дата открытия курса ученику
    FLOOR(DATEDIFF(NOW(), cu.created_at) / 30) AS open_months,  -- Число полных месяцев курса открыто у ученика
    COUNT(hd.id) AS homework_done_count  -- Число сданных ДЗ ученика на курсе
FROM
    course_users cu
JOIN
    users u ON cu.user_id = u.id
JOIN
    courses c ON cu.course_id = c.id
JOIN
    subjects s ON c.subject_id = s.id
JOIN
    course_types ct ON c.course_type_id = ct.id
LEFT JOIN
    cities ci ON u.city_id = ci.id
LEFT JOIN
    homework_done hd ON hd.user_id = u.id
WHERE
    ct.name IN ('ЕГЭ', 'ОГЭ')            -- Фильтр по типу курса: ЕГЭ или ОГЭ
    AND cu.active = 1                    -- Только активные ученики, не отчисленные с курса
GROUP BY
    c.id, u.id
ORDER BY
    c.id, u.id;
