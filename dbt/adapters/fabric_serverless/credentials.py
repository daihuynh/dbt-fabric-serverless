from dataclasses import dataclass
from dbt.adapters.fabric import FabricCredential

@dataclass
class FabricServerlessCredentials(FabricCredentials):
    @property
    def type(self):
        return "fabricserverless"