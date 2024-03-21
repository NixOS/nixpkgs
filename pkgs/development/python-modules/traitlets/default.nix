{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, hatchling

# tests
, argcomplete
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hYUQWzcaBLgxakPVzinAmFdcLkd4ULYrhIuWTxREUn4=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    argcomplete
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires mypy-testing
    "tests/test_typing.py"
  ];

  meta = {
    changelog = "https://github.com/ipython/traitlets/blob/v${version}/CHANGELOG.md";
    description = "Traitlets Python config system";
    homepage = "https://github.com/ipython/traitlets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
