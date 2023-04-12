{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6NX3XDeKB8bRzGH62WEbRRyTg8AlMFLhYZioUuFiBwU=";
  };

  doCheck = false;

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}
