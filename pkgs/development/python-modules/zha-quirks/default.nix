{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, zigpy
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.57";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = version;
    sha256 = "sha256-ajdluj6UIzjJUK30GtoM+e5lsMQRKnn3FPNEg+RS/DM=";
  };

  propagatedBuildInputs = [
    aiohttp
    zigpy
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zhaquirks" ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
