from dataclasses import dataclass
from typing import Optional
from aws_cdk.aws_ecr import TagStatus
from aws_cdk.core import RemovalPolicy
from src.base import Base

@dataclass(frozen=True)
class Repository(Base):
    id: str
    repository_name: str
    image_scan_on_push: Optional[bool] = None
    removal_policy: RemovalPolicy = RemovalPolicy.DESTROY
