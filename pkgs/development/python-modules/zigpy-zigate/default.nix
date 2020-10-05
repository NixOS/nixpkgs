{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.6.2";

  buildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "338c8c3c40d0aacdea623ced66229da08616d90758fb19b56f33919018ac9aa6";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with ZiGate radios for zigpy";
    homepage = "http://github.com/doudz/zigpy-zigate";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
