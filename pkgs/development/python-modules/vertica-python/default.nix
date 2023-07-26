{ lib
, buildPythonPackage
, fetchPypi
, future
, mock
, parameterized
, pytestCheckHook
, python-dateutil
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "vertica-python";
  version = "1.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KzvJcBR6Bc+z6IAmJ0KR88aSQMjRx1UilS28oBv9nTE=";
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

  pythonImportsCheck = [
    "vertica_python"
  ];

  meta = with lib; {
    description = "Native Python client for Vertica database";
    homepage = "https://github.com/vertica/vertica-python";
    changelog = "https://github.com/vertica/vertica-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
