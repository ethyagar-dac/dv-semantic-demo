-- One row per day. MetricFlow needs this to roll metrics up by week, month, etc.
-- Snowflake's generator() avoids needing an extra package for a date spine.

select
    dateadd(day, row_number() over (order by seq4()) - 1, '1992-01-01'::date) as date_day
from table(generator(rowcount => 3653))   -- ten years
