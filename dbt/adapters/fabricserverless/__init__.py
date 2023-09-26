from dbt.adapters.base import AdapterPlugin

from dbt.adapters.fabricserverless.adapter import FabricServerlessAdapter
from dbt.adapters.fabricserverless.credentials import FabricServerlessCredentials
from dbt.include import fabricserverless

Plugin = AdapterPlugin(
    adapter=FabricServerlessAdapter,
    credentials=FabricServerlessCredentials,
    include_path=fabricserverless.PACKAGE_PATH,
    dependencies=['fabric']
)
