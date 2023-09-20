{% macro use_database_hint(database) %}
    {{ return(adapter.dispatch('use_database_hint')(database)) }}
{% endmacro %}

{% macro default__use_database_hint(database) %}{% endmacro %}

{% macro fabricserverless__use_database_hint(database) %}
    USE [{{ database }}]
{% endmacro %}

{% macro fabricserverless__list_schemas(database) %}
  {{ use_database_hint(database) }}
  {% call statement('list_schemas', fetch_result=True, auto_begin=False) -%}
    SELECT [name] AS [schema]
    FROM sys.schemas
  {% endcall %}
  {{ return(load_result('list_schemas').table) }}
{% endmacro %}