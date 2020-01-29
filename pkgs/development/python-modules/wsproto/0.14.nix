{ lib, buildPythonPackage, fetchPypi, h11, enum34, pytest }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "614798c30e5dc2b3f65acc03d2d50842b97621487350ce79a80a711229edfa9d";
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
