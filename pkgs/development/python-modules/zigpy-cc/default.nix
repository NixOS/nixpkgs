{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, asynctest, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "zigpy-cc";
  version = "0.5.1";

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ asynctest pytest pytest-asyncio ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "06759615b28c45beaa5f03e594769a373d41674b96aeafefccd5c4e1c67e25ca";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "http://github.com/sanyatuning/zigpy-cc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
