{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "trimesh";
  version = "3.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Aluy+jouh73Whz8R20Wnyhkhby+Lau0pFA/KV+MsKY4=";
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
