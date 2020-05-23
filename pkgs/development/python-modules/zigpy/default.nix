{ stdenv, buildPythonPackage, fetchPypi
, aiohttp, crccheck, pycryptodome, voluptuous }:

let
  pname = "zigpy";
  version = "0.20.4";

in buildPythonPackage {
  inherit pname version;

  buildInputs = [ aiohttp crccheck pycryptodome voluptuous ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1idzcsksi1lsy3rn5bbrblipi3sx9zyima3qrh975yvb4wx0vkjv";
  };

  doCheck = false; # Tries to do requests to remote locations

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = "https://github.com/zigpy/zigpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
