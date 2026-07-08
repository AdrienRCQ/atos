from typing import Literal
from pydantic import BaseModel

class HealthResponse(BaseModel):
    status: Literal["healthy"] = "healthy"
    environment: str
    
class VersionResponse(BaseModel):
    application: str
    version: str
    environment: str