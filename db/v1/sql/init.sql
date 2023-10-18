create table teachers (
    id serial primary key,
    first_name varchar not null,
    last_name varchar not null,
    patronymic_name varchar,
    email varchar not null unique,
    pass_hash varchar not null
);

create table students (
    id serial primary key,
    first_name varchar not null,
    last_name varchar not null
);

create table classes (
    id serial primary key,
    title varchar not null
);

create table teacher_classes (
    id serial primary key,
    teacher_id serial references teachers (id) not null,
    class_id serial references classes(id) not null unique,
    unique(teacher_id, class_id)
);

create table class_students (
    id serial primary key,
    class_id serial references classes (id) not null,
    student_id serial references students (id) not null,
    unique (class_id, student_id)
);

-- Домашние задания
create table homeworks (
    id serial primary key,
    title varchar not null,
    descr varchar null,
    time_start timestamp not null,
    -- Сделать по дефолту при создании в бд
    time_end timestamp not null
);

create table homework_class (
    id serial primary key,
    homework_id serial references homeworks(id) not null,
    class_id serial references classes(id) not null,
    unique (homework_id, class_id)
);

-- Решения дз
-- Вариант А
create table solutions (
    id serial primary key,
    file_uid varchar null,
    -- Файл с решением
    text_content varchar null,
    -- решение текстом 
    -- Добавить проверку что хотя бы одно поле есть
    time_create timestamp not null,
    -- Добавить авто время
    mark int null,
    -- Оценка
    -- Мб время оценки
    student_id serial references students(id) not null
);

-- Вариант Б 
-- Решение=сообщение в мессенджере
create table homework_solutions (
    id serial primary key,
    homework_id serial references homeworks(id),
    solution_id serial references solutions(id) unique,
    unique (homework_id, solution_id)
);

-- Сообщения
create type message_author as enum ('teacher', 'another');

create table messages (
    -- Унифицированый формат, т.е. не зависит откуда и куда сообщение
    id bigserial primary key,
    text_content varchar,
    time_create timestamp not null,
    -- Добавить авто-время
    author message_author not null
);

-- Вложения
create table message_attachments(
    id serial primary key,
    message_id serial references messages(id) not null,
    attachment_link varchar not null unique,
    unique (message_id, attachment_link)
);

-- Стикеры
create table message_stickers(
    id serial primary key,
    message_id serial references messages(id) not null,
    sticker_link varchar not null unique,
    unique (message_id, sticker_link)
);

create table chat (
    id serial primary key,
    api_type varchar not null,
    -- Тип мессенждера
    api_id varchar not null unique,
    -- Id в мессенджере
    teacher_id serial references teachers(id) not null,
    student_id serial references students(id) not null,
    unique (teacher_id, student_id, api_type)
);

create table chat_messages (
    id serial primary key,
    chat_id serial references chat(id) not null,
    message_id serial references messages(id) not null
);

-- Боты
create table vk_bots (
    id serial primary key,
    token varchar not null unique,
    title varchar null -- Для отображения и дебага
);

create table tg_bots (
    id serial primary key,
    token varchar not null unique,
    title varchar null -- Для отображения и дебага
);

-- Связь аккаунта в сервисе с внешним аккаунтом
create table student_vk (
    id serial primary key,
    student_id serial references students (id) not null,
    vk_id serial not null,
    unique (student_id, vk_id)
);

-- Связь аккаунта в сервисе с ботами сервиса
create table students_vk_bots (
    id serial primary key,
    vk_id serial references student_vk (vk_id) not null,
    bot_id serial references vk_bots (id) not null,
    unique (vk_id, bot_id)
);

create table student_tg (
    id serial primary key,
    student_id serial references students (id) not null,
    tg_id serial not null,
    unique (student_id, tg_id)
);

create table students_tg_bots (
    id serial primary key,
    tg_id serial references student_tg (tg_id) not null,
    bot_id serial references tg_bots (id) not null,
    unique (tg_id, bot_id)
);