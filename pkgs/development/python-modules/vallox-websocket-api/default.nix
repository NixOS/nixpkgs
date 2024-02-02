{ lib
, aiohttp
, buildPythonPackage
, pythonOlder
, pythonRelaxDepsHook
, fetchFromGitHub
, setuptools
, construct
, websockets
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
  version = "4.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    rev = "refs/tags/${version}";
    hash = "sha256-L6uLA8iVYzh3wFVSwxzleHhu22sQeomq9N9A1oAxpf4=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "websockets"
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

  pythonImportsCheck = [ "vallox_websocket_api" ];

  meta = {
    changelog = "https://github.com/yozik04/vallox_websocket_api/releases/tag/${version}";
    description = "Async API for Vallox ventilation units";
    homepage = "https://github.com/yozik04/vallox_websocket_api";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
