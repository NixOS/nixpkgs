{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  natsort,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "seedir";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "earnestt1234";
    repo = "seedir";
    tag = "v${version}";
    hash = "sha256-o2CUK00WdoYyLqbDlh+wa30Q23ZkWZC+RvGDCSiCwH4=";
  };

  build-system = [ setuptools ];

  dependencies = [ natsort ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "seedir" ];

  meta = {
    description = "Module for for creating, editing, and reading folder tree diagrams";
    homepage = "https://github.com/earnestt1234/seedir";
    changelog = "https://github.com/earnestt1234/seedir/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "seedir";
  };
}
