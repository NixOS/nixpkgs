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
  version = "4.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mikedh";
    repo = "trimesh";
    tag = version;
    hash = "sha256-ttOawg1mdGkV1Pi0CmFR4VtmZ9MUxPed0KoXLwlbUPE=";
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
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "trimesh";
    maintainers = with lib.maintainers; [
      gebner
      pbsds
    ];
  };
}
