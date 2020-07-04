{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pyserial, pyserial-asyncio, pycryptodome, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.9.2";

  nativeBuildInputs = [ pytest ];
  buildInputs = [ aiohttp crccheck pycryptodome ];
  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4256136d714c00d22f6d2abf975438e2bc080cc43b8afef0decb80ed8066ef6";
  };

  meta = with stdenv.lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
