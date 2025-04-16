{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  numpy,
  lxml,
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "4.6.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mikedh";
    repo = "trimesh";
    tag = version;
    hash = "sha256-A/obsrJIItNszMleMP1kkysSVdiFV2WxKTmYG+g1nks=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  disabledTests = [
    # requires loading models which aren't part of the Pypi tarball
    "test_load"
  ];

  pytestFlagsArray = [ "tests/test_minimal.py" ];

  pythonImportsCheck = [ "trimesh" ];

  meta = {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimesh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "trimesh";
    maintainers = with lib.maintainers; [
      pbsds
    ];
  };
}
