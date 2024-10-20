{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  numpy,
  lxml,
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "4.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/EnZ+8KeJQF3daAk5d+A9iXJ3dv5gs4+pdNEUHCVBCU=";
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

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimesh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${version}";
    license = licenses.mit;
    mainProgram = "trimesh";
    maintainers = with maintainers; [
      gebner
      pbsds
    ];
  };
}
