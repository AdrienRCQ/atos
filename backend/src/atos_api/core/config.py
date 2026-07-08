from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


EnvironmentName = Literal[
    "development",
    "test",
    "staging",
    "production",
]


class Settings(BaseSettings):
    """Configuration générale de l'API ATOS."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_prefix="ATOS_",
        case_sensitive=False,
        extra="ignore",
    )

    app_name: str = "ATOS API"
    environment: EnvironmentName = "development"
    api_v1_prefix: str = "/api/v1"
    debug: bool = False


@lru_cache
def get_settings() -> Settings:
    """Retourne une instance mise en cache de la configuration."""

    return Settings()