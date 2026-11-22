{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

  # Build system
  hatchling,
  hatch-requirements-txt,
  hatch-vcs,

  # Dependencies
  click,
  python-keycloak,
  pyyaml,
  swh-core,

  # Tests
  aiocache,
  httpx,
  pytestCheckHook,
  pytest-django,
  pytest-mock,
  requests-mock,
  djangorestframework,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "swh-auth";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A+Vs+i6rGxrDh1AhqYy6d9N/J+DDnKz17ciGKjOU2m8=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-vcs
  ];

  dependencies = [
    click
    python-keycloak
    pyyaml
    swh-core
  ];

  pythonImportsCheck = [ "swh.auth" ];

  # Many broken tests on Darwin. Disabling them for now.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    aiocache
    djangorestframework
    httpx
    pytestCheckHook
    pytest-django
    pytest-mock
    requests-mock
    starlette
  ];

  meta = {
    description = "Set of utility libraries related to user authentication in applications and services based on the use of Keycloak and OpenID Connect";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-auth";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
