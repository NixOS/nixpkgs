{ stdenv, buildPythonPackage, fetchPypi
, zigpy, pyserial-asyncio, pycryptodome, voluptuous, aiohttp, crccheck, pyserial
}:

let
  pname = "zigpy-zigate";
  version = "0.6.1";

in buildPythonPackage {
  inherit pname version;

  buildInputs = [ zigpy pyserial-asyncio pycryptodome voluptuous aiohttp crccheck pyserial ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xxqv65drrr96b9ncwsx9ayd369lpwimj1jjb0d7j6l9lil0wmf5";
  };

  doCheck = false; # Tries to do requests to remote locations

  meta = with stdenv.lib; {
    description = "A library which communicates with ZiGate radios for zigpy";
    homepage = "http://github.com/doudz/zigpy-zigate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
