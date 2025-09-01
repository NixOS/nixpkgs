{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  click,
  python-keycloak,
  python-jose,
  pyyaml,
  swh-core,
  aiocache,
  httpx,
  pytestCheckHook,
  pytest-django,
  pytest-mock,
  djangorestframework,
  starlette,
}:

buildPythonPackage rec {
  pname = "swh-auth";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-auth";
    tag = "v${version}";
    hash = "sha256-8ctd5D7zT66oVNZlvRIs8pN7Fe2BhTgC+S9p1HBDO9E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    python-keycloak
    python-jose
    pyyaml
    swh-core
  ];

  pythonImportsCheck = [ "swh.auth" ];

  nativeCheckInputs = [
    aiocache
    djangorestframework
    httpx
    pytestCheckHook
    pytest-django
    pytest-mock
    starlette
  ];

  meta = {
    description = "Set of utility libraries related to user authentication in applications and services based on the use of Keycloak and OpenID Connect";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-auth";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
