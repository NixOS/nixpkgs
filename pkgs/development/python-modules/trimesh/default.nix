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
  version = "4.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XySMp5DvwkHEbsmj1+50TMcopnz1KoR592ZZG+UfoaQ=";
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
