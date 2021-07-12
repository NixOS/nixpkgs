{ lib, buildPythonPackage, fetchPypi, mock, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "345f35d0dccaf181e0aa4353e6c13f40f5cceda10a3c7021dafab29f004f62ae";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ mock ];

  meta = with lib; {
    homepage = "http://graphite.wikidot.com/";
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
