from dataclasses import dataclass
from dbt.adapters.fabric.fabric_credentials import FabricCredentials

@dataclass
class FabricServerlessCredentials(FabricCredentials):
    @property
    def type(self):
        return "fabricserverless"