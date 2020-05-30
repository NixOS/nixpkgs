{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.39";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "99d4b20a933b97b323c558f4057036ebe349bf603e97826c498d17d9cc80ff0b";
  };

  meta = with stdenv.lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
