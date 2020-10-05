{ stdenv, buildPythonPackage, fetchPypi
, pyserial, pyserial-asyncio, zigpy
, pytest, pytest-asyncio, asynctest }:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.10.0";

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytest pytest-asyncio asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "09e6e3554b71b6525e46fa314d482d51c52e5c24458277096fcc9b4df580ba3a";
  };

  meta = with stdenv.lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
