{ lib, buildPythonPackage, fetchPypi
, aiohttp, zigpy, conftest, asynctest
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.46";

  propagatedBuildInputs = [ aiohttp zigpy ];
  checkInputs = [ pytestCheckHook conftest asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "OpkOMvxiPBCVagSv8Jxvth3gwVv4idFSlKoBaOO5JVg=";
  };

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
