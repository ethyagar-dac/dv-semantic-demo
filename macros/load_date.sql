{#- Returns the load timestamp for the batch being run (var load_batch). -#}
{%- macro load_date() -%}
{%- if var('load_batch') | int == 2 -%}
cast('{{ var("load_date_batch_2") }}' as timestamp_ntz)
{%- else -%}
cast('{{ var("load_date_batch_1") }}' as timestamp_ntz)
{%- endif -%}
{%- endmacro -%}
