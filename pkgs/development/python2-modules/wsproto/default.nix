{ lib, buildPythonPackage, fetchPypi, h11, enum34, pytest }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "051s127qb5dladxa14n9nqajwq7xki1dz1was5r5v9df5a0jq8pd";
  };

  propagatedBuildInputs = [ h11 enum34 ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pure Python, pure state-machine WebSocket implementation";
    homepage = "https://github.com/python-hyper/wsproto/";
    license = licenses.mit;
  };
}
