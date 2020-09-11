{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.43";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "16f62dddce73bb27408b13a0d6526a250b588ca020405b2369e72d5dc9fa7607";
  };

  meta = with stdenv.lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
