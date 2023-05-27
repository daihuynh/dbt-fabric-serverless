{% macro fabric__create_schema(relation) -%}
  {% call statement('create_schema') -%}
    {{ use_database_hint() }}
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ relation.schema }}')
    BEGIN
    EXEC('CREATE SCHEMA [{{ relation.schema }}]')
    END
  {% endcall %}
{% endmacro %}

{% macro fabric__create_schema_with_authorization(relation, schema_authorization) -%}
  {% call statement('create_schema') -%}
    {{ use_database_hint() }}
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ relation.schema }}')
    BEGIN
    EXEC('CREATE SCHEMA [{{ relation.schema }}] AUTHORIZATION [{{ schema_authorization }}]')
    END
  {% endcall %}
{% endmacro %}

{% macro fabric__drop_schema(relation) -%}
  {%- set relations_in_schema = list_relations_without_caching(relation) %}

  {% for row in relations_in_schema %}
    {%- set schema_relation = api.Relation.create(database=relation.database,
                                               schema=relation.schema,
                                               identifier=row[1],
                                               type=row[3]
                                               ) -%}
    {% do drop_relation(schema_relation) %}
  {%- endfor %}

  {% call statement('drop_schema') -%}
      EXEC('DROP SCHEMA IF EXISTS {{ relation.schema }}')
  {% endcall %}
{% endmacro %}