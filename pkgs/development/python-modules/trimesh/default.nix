{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
, pythonOlder
, numpy
, lxml
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ca0KytcPZaflr0eF/CRwbWSjmUzKNSbVkXLbQ1scHZ8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ lxml pytestCheckHook ];

  disabledTests = [
    # requires loading models which aren't part of the Pypi tarball
    "test_load"
  ];

  pytestFlagsArray = [ "tests/test_minimal.py" ];

  pythonImportsCheck = [ "trimesh" ];

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimsh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner pbsds ];
  };
}
