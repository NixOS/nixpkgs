{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinytag";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinytag";
    repo = "tinytag";
    tag = version;
    hash = "sha256-QRPnXPTMe0eM9nlZ1YFWJuP+OvifZnaNCwOcJz+48EY=";
  };

  build-system = [
    setuptools
    flit-core
  ];

  pythonImportsCheck = [ "tinytag" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Read audio file metadata";
    homepage = "https://github.com/tinytag/tinytag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
