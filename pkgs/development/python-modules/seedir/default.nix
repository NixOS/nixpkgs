{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  natsort,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "seedir";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "earnestt1234";
    repo = "seedir";
    rev = "refs/tags/v${version}";
    hash = "sha256-ilL2KKN5sJclVcStO/kZoacsPoMgcFW1/8M/PQjxw/U=";
  };

  build-system = [ setuptools ];

  dependencies = [ natsort ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "seedir" ];

  meta = with lib; {
    description = "Module for for creating, editing, and reading folder tree diagrams";
    homepage = "https://github.com/earnestt1234/seedir";
    changelog = "https://github.com/earnestt1234/seedir/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "seedir";
  };
}
