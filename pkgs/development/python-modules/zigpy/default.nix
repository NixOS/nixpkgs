{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto, voluptuous
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.25.0";

  propagatedBuildInputs = [ aiohttp crccheck pycrypto pycryptodome voluptuous ];
  checkInputs = [ pytest pytest-asyncio asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e1338103cf0ed83e0a24b1c810b032f73cb44fb0029cf875e26b7d68860e901";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
