from dbt.adapters.fabric import FabricAdapter
from dbt.adapters.fabric_serverless import FabricServerlessRelation, FabricServerlessConnectionManager

class FabricServerlessAdapter(FabricAdapter):
    Relation = FabricServerlessRelation
    ConnectionManager = FabricServerlessConnectionManager