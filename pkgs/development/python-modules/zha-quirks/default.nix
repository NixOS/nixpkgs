{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, zigpy
, asynctest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.54";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = version;
    sha256 = "1xc4rky9x2n15rsb18vyg4lb2897k14gkz03khgf8gp37bg2dk5h";
  };

  propagatedBuildInputs = [ aiohttp zigpy ];
  checkInputs = [ pytestCheckHook asynctest ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    license = licenses.asl20;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
