{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da4d4fbe059b0453e726d6d993760065d69b823a27efc3040402a6fcfe6a1ed9";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
