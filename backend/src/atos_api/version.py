from importlib.metadata import PackageNotFoundError, version

PACKAGE_NAME = "atos-backend"


def get_application_version() -> str:
    """Récupération de la version installé du package ATOS"""
    try:
        return version(PACKAGE_NAME)
    except PackageNotFoundError:
        return "0.0.1-dev"
