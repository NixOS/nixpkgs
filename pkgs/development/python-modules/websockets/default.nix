{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
}:

let
  pname = "websockets";
  version = "3.2";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "1dah1faywsnrlqyzagb1qc1cxrq9145srkdy118yhy9s8dyq4dmm";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
