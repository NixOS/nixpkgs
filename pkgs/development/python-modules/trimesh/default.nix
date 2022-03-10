{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PcR84la6ZJjtpjg4WGVUkyZJqVT8Ge7vjk90X6gStAo=";
  };

  propagatedBuildInputs = [ numpy ];

  # tests are not included in pypi distributions and would require lots of
  # optional dependencies
  doCheck = false;

  pythonImportsCheck = [ "trimesh" ];

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimsh.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
