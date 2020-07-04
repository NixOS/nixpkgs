{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, pycrypto
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy-homeassistant";
  version = "0.19.0";

  nativeBuildInputs = [ pytest pytest-asyncio asynctest ];
  buildInputs = [ aiohttp pycryptodome ];
  propagatedBuildInputs = [ crccheck pycrypto ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "779cff7affb86b7141aa641c188342b22be0ec766adee0d180c93e74e2b10adc";
  };

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
