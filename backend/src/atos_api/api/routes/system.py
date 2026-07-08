from typing import Annotated

from fastapi import APIRouter, Depends

from atos_api.core.config import Settings, get_settings
from atos_api.schemas.system import VersionResponse
from atos_api.version import get_application_version

router = APIRouter(tags=["system"])


@router.get("/version", response_model=VersionResponse, summary="Récupérer la version de l'API")
def get_version(settings: Annotated[Settings, Depends(get_settings)]) -> VersionResponse:
    return VersionResponse(
        application=settings.app_name,
        version=get_application_version(),
        environment=settings.environment,
    )
