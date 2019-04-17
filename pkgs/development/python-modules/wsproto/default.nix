{ lib, buildPythonPackage, fetchPypi, h11, enum34, pytest }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p24dmym6pfsqsyxps6m2cxfl36cmkri0kdy5y5q7s300j3xmhsm";
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
