{ lib
, fetchurl
, buildPythonPackage
, pythonOlder
}:

let
  pname = "websockets";
  version = "3.3";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "305ab7fdd86afd08c2723461c949e153f7b01233f95a108619a15e41b7a74c93";
  };

  disabled = pythonOlder "3.3";
  doCheck = false; # protocol tests fail

  meta = {
    description = "WebSocket implementation in Python 3";
    homepage = https://github.com/aaugustin/websockets;
    license = lib.licenses.bsd3;
  };
}
