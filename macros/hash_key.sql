{#-
  hash_key(columns)
  Builds a Data Vault hash key (or hashdiff) from a list of column names.

  Called like:   {{ hash_key(['order_id', 'customer_id']) }}
  Should render: md5(concat_ws('||', <col1 standardised>, <col2 standardised>))

  Standardise EACH column the same way, everywhere, so one business key always
  produces one hash no matter which source it came from:
    1. cast to varchar        - 42 and '42' must hash the same
    2. trim, then upper       - ' abc' and 'ABC' must hash the same
    3. empty string -> null, then null -> '^^'
                              - a null must not silently disappear from the string
    4. join with '||'         - ('a','bc') and ('ab','c') must NOT collide

  TODO: write the macro body.

  Clue 1: Jinja loop:  {% for col in columns %} ... {% endfor %}
  Clue 2: One column, fully standardised:
            coalesce(nullif(upper(trim(cast(<col> as varchar))), ''), '^^')
  Clue 3: Put a comma between items but not after the last:
            {%- if not loop.last %},{% endif %}
  Clue 4: The {%- and -%} variants strip whitespace. Optional, but keeps compiled SQL tidy.

  Check: `dbt compile -s stg_part` then open target/compiled/.../stg_part.sql.
  You should see md5(concat_ws('||', coalesce(...), coalesce(...))).

  Interview question you should be able to answer: why '^^' and not ''?
-#}
{%- macro hash_key(columns) -%}
    {#- TODO -#}
{%- endmacro -%}
