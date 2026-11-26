{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  bluepy,
  cryptography,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miauth";
  version = "0.9.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2/4nFInpdY8fb/b+sXhgT6ZPtEgBV+KHMyLnxIp6y/U=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [
    bluepy
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miauth" ];

  meta = {
    description = "Authenticate and interact with Xiaomi devices over BLE";
    homepage = "https://github.com/dnandha/miauth";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "miauth";
  };
}
