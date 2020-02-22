{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy-homeassistant";
  version = "0.11.0";

  nativeBuildInputs = [ pytest pytest-asyncio asynctest ];
  buildInputs = [ aiohttp pycryptodome ];
  propagatedBuildInputs = [ crccheck pycrypto ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "021wg9yhz8dsif60r8s5621mf63bsayjjb2bimhq0am03ql0fysl";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
