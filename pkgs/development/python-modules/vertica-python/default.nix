{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  parameterized,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VCB4ri/t7mlK3tsE2Bxu3Cd7h+10QDApQhB9hqC81EU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    six
  ];

  nativeCheckInputs = [
    mock
    parameterized
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require an accessible Vertica db
    "vertica_python/tests/integration_tests"
  ];

  pythonImportsCheck = [ "vertica_python" ];

  meta = with lib; {
    description = "Native Python client for Vertica database";
    homepage = "https://github.com/vertica/vertica-python";
    changelog = "https://github.com/vertica/vertica-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
