{% macro fabricserverless__create_table_as(temporary, relation, sql) -%}
    {{ exceptions.raise_compiler_error(
        "Creating tables is not supported in Serverless Pools"
        )
    }}
{% endmacro %}
