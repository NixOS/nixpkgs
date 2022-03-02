{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy36
, dataclasses
, h11
, pytest
}:

buildPythonPackage rec {
  pname = "wsproto";
  version = "1.1.0";
  disabled = pythonOlder "3.6"; # python versions <3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ouVr/Vx82DwTadg7X+zNbTd5i3SHKGbmJhbg7PERvag=";
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
