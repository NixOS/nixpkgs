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
  version = "0.0.66";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = version;
    sha256 = "18g0i6b60ndfmbvdsx5pniq56fyc5k39ylp3sjhrfjcj434wvbvc";
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
