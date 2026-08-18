{
  lib,
  buildPythonPackage,
  fetchPypi,
  pint,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y4J3kCoRON7qt5bsW+9wdqbgJIyjYHo/Pe4LbZ6bhBU=";
  };

  build-system = [ setuptools ];

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

  meta = {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    changelog = "https://github.com/jendrikseipp/vulture/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcwitt ];
    mainProgram = "vulture";
  };
}
