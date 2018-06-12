{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
}:

let
  pname = "websockets";
  version = "5.0.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "a49d315db5a7a19d55422e1678e8a1c3b9661d7296bef3179fa620cf80b12674";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
