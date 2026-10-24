{#- Use the folder schema as-is (staging, raw_vault, marts) instead of dev_staging etc. -#}
{%- macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}{{ target.schema }}{%- else -%}{{ custom_schema_name | trim }}{%- endif -%}
{%- endmacro -%}
