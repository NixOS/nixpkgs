{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f3b956d11c5b301206382726210dc1d3bee1a9ccf7aadf895aaf31f71c3716c";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
