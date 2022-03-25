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
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IpdrR9mDG+8cNnXgSXkmXahSEP4EGnEBJqZk5SNu9pA=";
  };

  propagatedBuildInputs = [
    future
    python-dateutil
    six
  ];

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
