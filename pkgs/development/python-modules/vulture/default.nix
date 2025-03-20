{
  lib,
  buildPythonPackage,
  fetchPypi,
  pint,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  toml,
  tomli,
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y4J3kCoRON7qt5bsW+9wdqbgJIyjYHo/Pe4LbZ6bhBU=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pint
    pytest-cov-stub
    pytestCheckHook
    toml
  ];

  disabledTestPaths = [
    # missing pytype package/executable
    "tests/test_pytype.py"
  ];

  pythonImportsCheck = [ "vulture" ];

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    changelog = "https://github.com/jendrikseipp/vulture/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
    mainProgram = "vulture";
  };
}
