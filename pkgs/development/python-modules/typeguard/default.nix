{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BOOPkutZQQyTddO+I99l4KdkPy6Ly9QhQj2AjS+emd8=";
  };

  buildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
    typing-extensions
  ];

  disabledTestPaths = [
    # mypy tests aren't passing with latest mypy
    "tests/mypy"
  ];

  pythonImportsCheck = [
    "typeguard"
  ];

  meta = with lib; {
    description = "Python library which provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
