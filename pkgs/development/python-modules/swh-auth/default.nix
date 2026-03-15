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
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-auth";
    tag = "v${version}";
    hash = "sha256-fRkhSpgguBff+vIOploi8i2qzd9qmsswiC62rIcY5bE=";
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
    maintainers = [ ];
  };
}
