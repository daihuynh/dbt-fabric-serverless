from dbt.adapters.fabric import FabricConnectionManager

class FabricServerlessConnectionManager(FabricConnectionManager):
    TYPE = "fabricserverless"