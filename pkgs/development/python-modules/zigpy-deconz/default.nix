{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pyserial, pyserial-asyncio, pycryptodome, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.7.0";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp crccheck pycryptodome ];
  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "049k6lvgf6yjkinbbzm7gqrzqljk2ky9kfw8n53x8kjyfmfp71i2";
  };

  meta = with stdenv.lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
