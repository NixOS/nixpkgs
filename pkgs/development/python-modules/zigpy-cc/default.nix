{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, asynctest, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "zigpy-cc";
  version = "0.5.2";

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ asynctest pytest pytest-asyncio ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "832160c16d665ace4b961da2c9c55d2f6baa78cf9d5ee2a4c2e6743a1e85923f";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "http://github.com/sanyatuning/zigpy-cc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
