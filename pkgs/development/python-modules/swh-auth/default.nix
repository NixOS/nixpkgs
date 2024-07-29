{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  pythonRelaxDepsHook,
  click,
  python-keycloak,
  python-jose,
  pyyaml,
  swh-core,
}:

buildPythonPackage rec {
  pname = "swh-auth";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-auth";
    rev = "v${version}";
    hash = "sha256-rYcjOwbqV7e27oR/QU5a/h7r6nvcj9+TUkCJ5wf5jOE=";
  };

  build-system = [
    setuptools
    setuptools-scm
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # python-keycloak<3.9,>=0.19.0 not satisfied by version 4.0.0
    "python-keycloak"
  ];

  dependencies = [
    click
    python-keycloak
    python-jose
    pyyaml
    swh-core
  ];

  pythonImportsCheck = [ "swh.auth" ];

  meta = {
    description = "Set of utility libraries related to user authentication in applications and services based on the use of Keycloak and OpenID Connect";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-auth";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
