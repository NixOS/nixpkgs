{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b2XxFSkYkMvOXNJpwTvfH4KkzSO8YbbhUKJ1Ee5qfV4=";
  };

  doCheck = false;

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}
