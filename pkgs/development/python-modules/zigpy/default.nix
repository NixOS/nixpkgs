{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto, voluptuous
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.22.0";

  propagatedBuildInputs = [ aiohttp crccheck pycrypto pycryptodome voluptuous ];
  checkInputs = [ pytest pytest-asyncio asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y8n96g5g6qsx8s2z028f1cyp2w8y7kksi8k2yyzpqvmanbxyjhc";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
