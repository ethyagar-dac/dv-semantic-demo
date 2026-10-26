rw-r--r--@  1 elangothyagarajan  staff  29424 Oct 24 07:04 dv-semantic-demo.zip
{#-
  hash_key(columns)
  Builds a Data Vault hash key (or hashdiff) from one or more columns.

  Standardisation rules, applied identically everywhere so the same business key
  always produces the same hash, regardless of source:
    1. cast to varchar        - 42 and '42' hash the same
    2. trim + upper           - ' abc' and 'ABC' hash the same
    3. null -> '^^'           - a null is distinguishable from an empty string
    4. join with '||'         - ('a','bc') and ('ab','c') don't collide

  MD5 is used for readability in a demo. Production: SHA-256 (sha2).
-#}
{%- macro hash_key(columns) -%}
md5(
    concat_ws('||',
    {%- for col in columns %}
        coalesce(nullif(upper(trim(cast({{ col }} as varchar))), ''), '^^')
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
    )
)
{%- endmacro -%}