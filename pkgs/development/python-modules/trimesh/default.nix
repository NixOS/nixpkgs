{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.12.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rEWMPK07AqFEd/5ax/kIh49QSlbYqjlSxDDS6Q5ZaLU=";
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
