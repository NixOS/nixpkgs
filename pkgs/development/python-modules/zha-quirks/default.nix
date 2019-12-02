{ stdenv, buildPythonPackage, fetchPypi, zigpy, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "021z5f5dm74amxkqnz4s1690ydprciqg23jz3n4mpjlxyxbdfj73";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ zigpy ];

  meta = with stdenv.lib; {
    description = "Library implementing Zigpy quirks for ZHA in Home Assistant";
    homepage = https://github.com/dmulcahey/zha-device-handlers;
    license = licenses.asl20;
    maintainers = with maintainers; [ elseym ];
  };
}
