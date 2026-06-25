{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  asgiref,
  psutil,
  urllib3,
  certifi,
  wrapt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scout-apm";
  version = "3.5.3";
  pyproject = true;

  src = fetchPypi {
    pname = "scout_apm";
    inherit version;
    hash = "sha256-ZsGyw7WnvmepG7FbfTQm6NawBWB9b4ZHRjoaRhXaUj4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    certifi
    psutil
    urllib3
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/integration"
  ];

  pythonImportsCheck = [ "scout_apm" ];

  meta = {
    description = "Scout Application Performance Monitoring Agent";
    homepage = "https://github.com/scoutapp/scout_apm_python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
