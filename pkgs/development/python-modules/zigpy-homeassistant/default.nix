{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto, voluptuous
, pytest, pytest-asyncio, asynctest }:

let
  version = "0.19.0";
  pname = "zigpy-homeassistant";

in buildPythonPackage {
  inherit pname version;

  nativeBuildInputs = [ pytest pytest-asyncio asynctest ];
  buildInputs = [ aiohttp pycryptodome ];
  propagatedBuildInputs = [ crccheck pycrypto voluptuous ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p0an7i78gn9h38y1pkafvnf0axj8a1ih734m90p2sxqzxxgz73p";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
