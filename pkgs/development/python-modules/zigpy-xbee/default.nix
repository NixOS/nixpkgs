{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.12.1";

  buildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "09488hl27qjv8shw38iiyzvzwcjkc0k4n00l2bfn1ac443xzw0vh";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "http://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
