{ lib, buildPythonPackage, fetchPypi, h11, enum34, pytest }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17gsxlli4w8am1wwwl3k90hpdfa213ax40ycbbvb7hjx1v1rhiv1";
  };

  propagatedBuildInputs = [ h11 enum34 ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pure Python, pure state-machine WebSocket implementation";
    homepage = https://github.com/python-hyper/wsproto/;
    license = licenses.mit;
  };
}
