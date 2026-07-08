""" Routeur principal"""
from fastapi import APIRouter
from atos_api.api.routes import system

api_router = APIRouter()
# Intégration du router de system
api_router.include_router(system.router)