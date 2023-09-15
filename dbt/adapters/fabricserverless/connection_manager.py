from dbt.adapters.fabric.fabric_connection_manager import FabricConnectionManager

class FabricServerlessConnectionManager(FabricConnectionManager):
    TYPE = "fabricserverless"