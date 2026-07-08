from fastapi import FastAPI

from atos_api.api.router import api_router
from atos_api.api.routes import health
from atos_api.core.config import get_settings
from atos_api.version import get_application_version

def create_app() -> FastAPI:
    """Construction + configuration de l'application FastAPI"""
    settings = get_settings()
    application = FastAPI(
        title=settings.app_name,
        version=get_application_version(),
        debug=settings.debug,
        description="Aston Task Orchestrator System API"
    )
    application.include_router(health.router)
    application.include_router(api_router, prefix=settings.api_v1_prefix)
    return application

app = create_app()