-- Поиск по одному слову

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages]
where search_vector @@ plainto_tsquery('russian', 'комиссия')
order by message_ts desc
limit 100;


-- Поиск с ранжированием по максимальному совпадению

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text,
    ts_rank_cd(search_vector, plainto_tsquery('russian', 'комиссия')) as relevance
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'комиссия')
order by relevance desc, message_ts desc
limit 100;


-- Поиск по нескольким словам

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text,
    ts_rank_cd(search_vector, websearch_to_tsquery('russian', 'яндекс комиссия')) as relevance
from cdm.searchable_messages
where search_vector @@ websearch_to_tsquery('russian', 'яндекс комиссия')
order by relevance desc, message_ts desc
limit 100;


-- Поиск точной фразы

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ phraseto_tsquery('russian', 'время ожидания')
order by message_ts desc
limit 100;


-- Поиск по началу слова

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ to_tsquery('russian', 'комисс:*')
order by message_ts desc
limit 100;


-- Поиск по слову и фильтр по времени

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'поддержка')
  and message_ts >= '2026-01-01 00:00:00'
  and message_ts <= '2026-03-17 00:00:00'
order by message_ts desc
limit 100;


-- Поиск по слову и фильтр по источнику

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'яндекс')
  and source_code = 'tg'
order by message_ts desc
limit 100;


-- Поиск по слову и фильтр по чату

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'заказ')
  and group_id = '1692301276'
order by message_ts desc
limit 100;


-- Поиск по слову и фильтр по автору

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'выплаты')
  and author_id = '5101712664'
order by message_ts desc
limit 100;


-- Поиск с несколькими фильтрами сразу: слово, источник, период

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text,
    ts_rank_cd(search_vector, websearch_to_tsquery('russian', 'комиссия')) as relevance
from cdm.searchable_messages
where search_vector @@ websearch_to_tsquery('russian', 'комиссия')
  and source_code = 'tg'
  and group_id = '1692301276'
  and message_ts >= '2026-01-01 00:00:00'
  and message_ts <= '2026-03-17 00:00:00'
order by relevance desc, message_ts desc
limit 100;


-- Количество найденных сообщений по дням

select
    date_trunc('day', message_ts) as day,
    count(*) as total_messages
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'комиссия')
group by date_trunc('day', message_ts)
order by day;


-- Количество найденных сообщений по источникам

select
    source_code,
    count(*) as total_messages
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'комиссия')
group by source_code
order by total_messages desc;


-- Топ источников по количеству сообщений с нужным словом

select
    group_id,
    source_code,
    count(*) as total_messages
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'заказ')
group by group_id, source_code
order by total_messages desc
limit 100;


-- Топ авторов по количеству сообщений с нужным словом

select
    author_id,
    count(*) as total_messages
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'выплаты')
  and author_id is not null
group by author_id
order by total_messages desc
limit 100;


-- Поиск по возможным проблемам

select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text,
    ts_rank_cd(search_vector, websearch_to_tsquery('russian', 'штраф блокировка жалоба поддержка')) as relevance
from cdm.searchable_messages
where search_vector @@ websearch_to_tsquery('russian', 'штраф блокировка жалоба поддержка')
order by relevance desc, message_ts desc
limit 100;


-- Проверка скорости запроса

explain analyze
select
    message_id,
    source_code,
    group_id,
    author_id,
    message_ts,
    message_text
from cdm.searchable_messages
where search_vector @@ plainto_tsquery('russian', 'комиссия')
order by message_ts desc
limit 100;


-- Количество всех сообщений по источникам

select
    source_code,
    count(*) as total_messages
from cdm.searchable_messages
group by source_code
order by total_messages desc;


-- Количество сообщений по дням и источникам

select
    date_trunc('day', message_ts) as day,
    source_code,
    count(*) as total_messages
from cdm.searchable_messages
group by date_trunc('day', message_ts), source_code
order by day, source_code;
