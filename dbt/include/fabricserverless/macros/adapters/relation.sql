# This doesn't work with table and Synapse Serverless doesn't support tabl as well
# Implementation take from the conversation at: 
# https://github.com/dbt-msft/dbt-synapse-serverless/issues/4
{% macro fabricserverless__rename_relation(from_relation, to_relation) -%}
  {% call statement('rename_relation') -%}
    DECLARE @to_definition nvarchar(max);
    SET @to_definition = replace(object_definition (object_id ('{{ from_relation.include(database=False) }}')), '{{ from_relation.include(database=False) }}', '{{ to_relation.include(database=False) }}');
    EXEC('DROP VIEW {{ from_relation.include(database=False) }}')
    EXEC('DROP VIEW IF EXISTS {{ to_relation.include(database=False) }}')
    EXEC(@to_definition)
  {%- endcall %}
{% endmacro %}


{% macro fabricserverless__drop_relation(relation) -%}
    {% call statement('drop_relation', auto_begin=False) -%}
      {{ fabricserverless__drop_relation_script(relation) }}
    {%- endcall %}
{% endmacro %}

{% macro fabricserverless__drop_relation_script(relation) -%}
  {% if relation.type == 'view' -%}
    {% set object_id_type = 'V' %}
    {% set relation_type = 'view' %}
  {% elif relation.type == 'table'%}
    {% set object_id_type = 'U' %}
    {% set relation_type = 'table' %}
  {% elif relation.type == 'external'%}
    {% set object_id_type = 'U' %}
    {% set relation_type = 'external table' %}
  {%- else -%} invalid target name
  {% endif %}

  {{ use_database_hint(relation.database)}}
  if OBJECT_ID ('{{ relation.include(database=False) }}','{{ object_id_type }}') IS NOT NULL
    BEGIN
    DROP {{ relation_type }} {{ relation.include(database=False) }}
    END
{% endmacro %}



{% macro fabricserverless__list_relations_without_caching(schema_relation) %}
  {% call statement('list_relations_without_caching', fetch_result=True) -%}
    select
      table_catalog as [database],
      table_name as [name],
      table_schema as [schema],
      case when table_type = 'BASE TABLE' then 'external table'
           when table_type = 'VIEW' then 'view'
           else table_type
      end as table_type

    from [{{ schema_relation.database }}].INFORMATION_SCHEMA.TABLES
    where table_schema like '{{ schema_relation.schema }}'
  {% endcall %}
  {{ return(load_result('list_relations_without_caching').table) }}
{% endmacro %}
