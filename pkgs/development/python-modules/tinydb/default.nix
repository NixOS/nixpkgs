{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "4.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = "tinydb";
    tag = "v${version}";
    hash = "sha256-7YKqbBf+WrSVDZdPb6dT/22f5uggXy8uQ3lkxvWD5AI=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pyyaml
  ];

  pythonImportsCheck = [ "tinydb" ];

  meta = {
    description = "Lightweight document oriented database written in Python";
    homepage = "https://tinydb.readthedocs.org/";
    changelog = "https://tinydb.readthedocs.io/en/latest/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcus7070 ];
  };
}
