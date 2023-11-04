{ lib
, aiohttp
, buildPythonPackage
, construct
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    rev = "refs/tags/${version}";
    hash = "sha256-QLJnULAfYsDxwJENi8i/0wgmtlk7M929fCwTELONX1M=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    construct
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "vallox_websocket_api"
  ];

  meta = with lib; {
    description = "Async API for Vallox ventilation units";
    homepage = "https://github.com/yozik04/vallox_websocket_api";
    changelog = "https://github.com/yozik04/vallox_websocket_api/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
