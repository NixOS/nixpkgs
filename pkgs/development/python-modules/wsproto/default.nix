{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy36
, dataclasses
, h11
, pytest
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.15.0";
  disabled = pythonOlder "3.6"; # python versions <3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "17gsxlli4w8am1wwwl3k90hpdfa213ax40ycbbvb7hjx1v1rhiv1";
  };

  propagatedBuildInputs = [ h11 ] ++ lib.optional isPy36 dataclasses;

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
