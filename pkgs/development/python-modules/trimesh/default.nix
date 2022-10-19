{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.15.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jzQEsrCwSB+OY9XGmztkvbM2ZzT4mUkuYvO86ed6XUc=";
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
