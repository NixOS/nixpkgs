{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
}:

let
  pname = "websockets";
  version = "3.4";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "43e5b9f51dd0000a4c6f646e2ade0c886bd14a784ffac08b9e079bd17a63bcc5";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
