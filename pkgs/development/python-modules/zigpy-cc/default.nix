{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, pyserial-asyncio, zigpy, pyserial, pycryptodome, voluptuous, crccheck }:

let
  pname = "zigpy-cc";
  version = "0.4.4";

in buildPythonPackage {
  inherit pname version;

  buildInputs = [ aiohttp pyserial-asyncio zigpy pyserial pycryptodome voluptuous crccheck ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "117a9xak4y5nksfk9rgvzd6l7hscvzspl1wf3gydyq2lc7b3ggnl";
  };

  doCheck = false; # Tries to do requests to remote locations

  meta = with stdenv.lib; {
    description = "A library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "http://github.com/sanyatuning/zigpy-cc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
