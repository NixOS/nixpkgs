{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pythonOlder
, numpy
, lxml
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.23.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-61nMytrqc7w7IbO7TX7H4O4DYoVL9MTBasN3UDx492w=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ lxml ];

  checkPhase = ''
    # Disable test_load because requires loading models which aren't part of the tarball
    substituteInPlace tests/test_minimal.py --replace "test_load" "disable_test_load"
    python tests/test_minimal.py
  '';

  pythonImportsCheck = [ "trimesh" ];

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimsh.org/";
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
