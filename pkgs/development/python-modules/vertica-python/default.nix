{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  mock,
  parameterized,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5SuJT8Mu/4MnAmTWb9TL5b0f0Hug2n70X5BhZME2vrw=";
  };

  propagatedBuildInputs = [
    future
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
