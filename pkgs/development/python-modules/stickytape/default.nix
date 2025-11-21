{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stickytape";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "stickytape";
    tag = version;
    hash = "sha256-KOZN9oxPb91l8QVU07I49UMNXqox8j+oekA1fMtj6l8=";
  };

  build-system = [ setuptools ];

  # Tests have additional requirements
  doCheck = false;

  pythonImportsCheck = [ "stickytape" ];

  meta = {
    description = "Python module to convert Python packages into a single script";
    homepage = "https://github.com/mwilliamson/stickytape";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "stickytape";
  };
}
