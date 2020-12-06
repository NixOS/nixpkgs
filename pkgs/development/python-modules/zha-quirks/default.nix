{ lib, buildPythonPackage, fetchPypi
, aiohttp, zigpy, conftest, asynctest
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.47";

  propagatedBuildInputs = [ aiohttp zigpy ];
  checkInputs = [ pytestCheckHook conftest asynctest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf7dbd5d1c1a3849b059e62afcef248b6955f5ceef78f87201ae2fc8420738de";
  };

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
