{
  lib,
  aenum,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  python-dateutil,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "weheat";
  version = "2025.1.15";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wefabricate";
    repo = "wh-python";
    tag = version;
    hash = "sha256-zt/4d7s4yoLQUQxtsc8Y6htS0PByuYmaecGsjKYo2tc=";
  };

  pythonRelaxDeps = [
    "urllib3"
    "pydantic"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aenum
    pydantic
    python-dateutil
    urllib3
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "weheat" ];

  meta = {
    description = "Library to interact with the weheat API";
    homepage = "https://github.com/wefabricate/wh-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
