{% macro fabricserverless__create_view_as(relation, sql) -%}
    {{ fabricserverless__create_view_exec(relation, sql) }}
{% endmacro %}

{% macro fabricserverless__create_view_exec(relation, sql) -%}

    {%- set temp_view_sql = sql.replace("'", "''") -%}
    {{ use_database_hint(relation.database) }}

    {% set contract_config = config.get('contract') %}
    {% if contract_config.enforced %}
        {{ get_assert_columns_equivalent(sql) }}
    {%- endif %}

    EXEC('create view {{ relation.include(database=False) }} as {{ temp_view_sql }};');

{% endmacro %}
