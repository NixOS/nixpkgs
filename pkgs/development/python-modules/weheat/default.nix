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
  version = "2024.12.22";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wefabricate";
    repo = "wh-python";
    rev = "refs/tags/${version}";
    hash = "sha256-hd0mqdcj+rvrYCvxhK3ewuiDekWUgTD7JypjL/EMqv8=";
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
