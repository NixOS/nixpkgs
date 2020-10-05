{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.13.0";

  buildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a018d1d14e6454033701364186e9d41d96b98a6babf05edff7bc09cc7c63f78";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "http://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
