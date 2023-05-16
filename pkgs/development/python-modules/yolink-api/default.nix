{ lib
, aiohttp
<<<<<<< HEAD
, aiomqtt
, buildPythonPackage
, fetchFromGitHub
=======
, buildPythonPackage
, fetchFromGitHub
, asyncio-mqtt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pydantic
, pythonOlder
, setuptools
, tenacity
}:

buildPythonPackage rec {
  pname = "yolink-api";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YoSmart-Inc";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-t/e3DSpmrH48I6ZAmDljL5YblsY2/UWgPCcodi2A7Ro=";
=======
    hash = "sha256-DbdoGNwz7HtscnDv+rOI2zcs4i4Dl1DpRZNH/DOcJHc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
<<<<<<< HEAD
    aiomqtt
=======
    asyncio-mqtt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pydantic
    tenacity
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "yolink"
  ];

  meta = with lib; {
    description = "Library to interface with Yolink";
    homepage = "https://github.com/YoSmart-Inc/yolink-api";
    changelog = "https://github.com/YoSmart-Inc/yolink-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
