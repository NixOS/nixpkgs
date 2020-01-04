{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.30";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "00731a9b9c58c4e59f6765ac0cec5e2301bdda28ef19e00e2ba752be457a61b9";
  };

  meta = with stdenv.lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
