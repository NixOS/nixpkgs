{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.6.1";

  buildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xxqv65drrr96b9ncwsx9ayd369lpwimj1jjb0d7j6l9lil0wmf5";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with ZiGate radios for zigpy";
    homepage = "http://github.com/doudz/zigpy-zigate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
