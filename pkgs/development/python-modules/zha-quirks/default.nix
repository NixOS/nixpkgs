{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.42";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b9c6217054b9c49bfe249fa38d993490e901ab29f198022d569e3505e6c7f20";
  };

  meta = with stdenv.lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
