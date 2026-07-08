from fastapi.testclient import TestClient


def test_version_returns_application_information(client: TestClient) -> None:
    response = client.get("/api/v1/version")

    assert response.status_code == 200

    payload = response.json()

    assert payload["application"] == "ATOS API"
    assert payload["environment"] == "test"
    assert isinstance(payload["version"], str)
    assert payload["version"]
