{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, construct
, websockets
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-wlkb6aa2UtqjrbNA26TUH+ZKvOM64An+lol+MCdQh3U=";
=======
    hash = "sha256-KtjyTSD7osIdThq/Ota4oCyeseBHxqaYaL47wiVicsI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    construct
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vallox_websocket_api" ];

  meta = {
    description = "Async API for Vallox ventilation units";
    homepage = "https://github.com/yozik04/vallox_websocket_api";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
