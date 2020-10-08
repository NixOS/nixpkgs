{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto, voluptuous
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.22.2";

  propagatedBuildInputs = [ aiohttp crccheck pycrypto pycryptodome voluptuous ];
  checkInputs = [ pytest pytest-asyncio asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a43129932c6e4af0d2d57542218faf7695e2424ce18a5a8915d016e1303f5e44";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
