{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.11.0";

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest pytest-asyncio asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2263f8bc5807ebac55bb665eca553b514384ce270b66f83df02c39184193020";
  };

  meta = with stdenv.lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
