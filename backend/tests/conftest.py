from collections.abc import Iterator

import pytest
from fastapi.testclient import TestClient

from atos_api.core.config import get_settings
from atos_api.main import create_app


@pytest.fixture
def test_environment(monkeypatch: pytest.MonkeyPatch) -> Iterator[None]:
    monkeypatch.setenv("ATOS_ENVIRONMENT", "test")
    get_settings.cache_clear()

    yield

    get_settings.cache_clear()


@pytest.fixture
def client(test_environment: None) -> Iterator[TestClient]:
    application = create_app()

    with TestClient(application) as test_client:
        yield test_client
