{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, asynctest, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "zigpy-cc";
  version = "0.4.4";

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ asynctest pytest pytest-asyncio ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "117a9xak4y5nksfk9rgvzd6l7hscvzspl1wf3gydyq2lc7b3ggnl";
  };

  meta = with stdenv.lib; {
    description = "A library which communicates with Texas Instruments CC2531 radios for zigpy";
    homepage = "http://github.com/sanyatuning/zigpy-cc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
