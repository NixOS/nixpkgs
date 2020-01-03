{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.28";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "021z5f5dm74amxkqnz4s1690ydprciqg23jz3n4mpjlxyxbdfj73";
  };

  meta = with stdenv.lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
