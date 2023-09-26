{% macro create_external_table_as(relation, sql) %}
    {{ adapter.dispatch('create_external_table_as', 'dbt')(relation, sql) }}
{% endmacro %}

{% macro fabricserverless__create_external_table_as(relation, sql) %}
    {%- set location = config.get('location', default='') -%}
    {%- set data_source = config.get('data_source', default='') -%}
    {%- set file_format = config.get('file_format', default='') -%}
    
    {% set contract_config = config.get('contract') %}
    {% if contract_config.enforced %}
        {{ get_assert_columns_equivalent(sql) }}
    {%- endif %}
    
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
    {{ use_database_hint(relation.database) }}
    CREATE EXTERNAL TABLE {{ relation.include(database=False) }}
    WITH (
        LOCATION = '{{ location }}',
        DATA_SOURCE = {{ data_source }},
        FILE_FORMAT = {{ file_format }}
    ) AS 
    {{ sql }}
   
{% endmacro%}