{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, zigpy
, conftest
, asynctest
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.48";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = version;
    sha256 = "KyTttpD3i2Y+mAGMtjCDKhwoBuDTpnuPyOP6sLmbCis=";
  };

  propagatedBuildInputs = [
    aiohttp
    zigpy
  ];

  checkInputs = [
    pytestCheckHook
    conftest
    asynctest
  ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
