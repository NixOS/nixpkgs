{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, numpy
, lxml
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.21.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VRPE+1QLKGy5W99ia5BuPNtmH/eoXulApS8n8SdQSaQ=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
