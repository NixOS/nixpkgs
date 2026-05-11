{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  poetry-core,
  pythonRelaxDepsHook,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "synology-srm";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aerialls";
    repo = "synology-srm";
    tag = "v${version}";
    hash = "sha256-qQxctw1UUs3jYve//irBni8rNKeld5u/bVtOwD2ofEQ=";
  };

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "requests"
  ];

  dependencies = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "synology_srm"
  ];

  meta = {
    description = "Python 3 library for Synology SRM (Router Manager)";
    homepage = "https://github.com/aerialls/synology-srm";
    changelog = "https://github.com/aerialls/synology-srm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
