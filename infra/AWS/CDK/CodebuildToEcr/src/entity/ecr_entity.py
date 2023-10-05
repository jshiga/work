from dataclasses import dataclass
from typing import Optional
from aws_cdk.core import RemovalPolicy

from src.props.ecr_props import Repository

from src.base import Base

class EcrBase(Base):
    """ECR基底class"""
    repository: Repository


class SampleEcr(EcrBase):
    id = "SampleEcrBuildTest"
    repository = Repository(
        id = "XXXXXX"
        , repository_name = "XXXXXX"
    )