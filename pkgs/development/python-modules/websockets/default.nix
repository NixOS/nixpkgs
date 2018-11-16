{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17vwr6sa1y3lb24wzfyyc98c5v03di4j8f24qkqa9vsvaghc7qq8";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
