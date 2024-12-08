{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "tinydb";
  version = "4.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "msiemens";
    repo = "tinydb";
    rev = "refs/tags/v${version}";
    hash = "sha256-N/45XB7ZuZiq25v6DQx4K9NRVnBbUHPeiKKbxQ9YB3E=";
  };

  build-system = [
    poetry-core
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
