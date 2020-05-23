{ stdenv, buildPythonPackage, fetchPypi
, pyserial-asyncio, zigpy, pyserial, pycryptodome, voluptuous, aiohttp, crccheck }:

let
  pname = "zigpy-xbee";
  version = "0.12.1";

in buildPythonPackage {
  inherit pname version;

  buildInputs = [ pyserial-asyncio zigpy pyserial pycryptodome voluptuous aiohttp crccheck ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "09488hl27qjv8shw38iiyzvzwcjkc0k4n00l2bfn1ac443xzw0vh";
  };

  doCheck = false; # Tries to do requests to remote locations

  meta = with stdenv.lib; {
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "http://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
