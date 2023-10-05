from typing import Any, Type
from dataclasses import dataclass, field, asdict
from aws_cdk.core import RemovalPolicy

from aws_cdk import core
from aws_cdk.aws_ecr import Repository

from src.entity.ecr_entity import EcrBase

class EcrStack(core.Stack):
    def __init__(self,scope: core.Construct, entity: Type[EcrBase], property, **kwargs: Any) -> None:
        super().__init__(scope, entity.id, **kwargs)

        params = asdict(entity.repository)    
        repo = Repository(
            self 
            , **params
        )

        self.output_props = property.copy()
        self.output_props['ecr_repository_name'] = params["repository_name"]
        self.output_props['ecr_repo'] = repo
    
    @property
    def outputs(self):
        return self.output_props