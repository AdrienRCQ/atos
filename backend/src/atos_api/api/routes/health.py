from typing import Annotated
from fastapi import APIRouter, Depends

from atos_api.core.config import Settings, get_settings
from atos_api.schemas.system import HealthResponse

router = APIRouter(tags=["system"])

@router.get(
    "/health",
    response_model=HealthResponse,
    summary="Vérifier l'état de l'API"
    )

def health_check(settings: Annotated[Settings, Depends(get_settings)]) -> HealthResponse:
    return HealthResponse(environment=settings.environment)