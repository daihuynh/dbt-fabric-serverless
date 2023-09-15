from dbt.adapters.fabric.fabric_adapter import FabricAdapter
from dbt.adapters.fabricserverless.connection_manager import FabricServerlessConnectionManager

class FabricServerlessAdapter(FabricAdapter):
    ConnectionManager = FabricServerlessConnectionManager