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
  version = "0.0.53";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = version;
    sha256 = "16n99r7bjd3lnxn72lfnxg44n7mkv196vdhkw2sf1nq1an4ks1nc";
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
