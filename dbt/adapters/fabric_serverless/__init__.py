from dbt.adapters.fabric_serverless import FabricServerlessAdapter, FabricServerlessCredentials
from dbt.include import fabric_serverless

Plugin = AdapterPlugin(
    adapter=FabricServerlessAdapter,
    credentials=FabricServerlessCredentials,
    include_path=fabric_serverless.PACKAGE_PATH,
    dependencies=['fabric']
)
