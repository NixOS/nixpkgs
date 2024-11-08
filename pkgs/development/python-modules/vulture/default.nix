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
  version = "2.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eCSL9Y9er/zCreMGFB6tc/Q3M5lQ+ABF3Of4sHjloao=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pint
    pytest-cov-stub
    pytestCheckHook
    toml
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
