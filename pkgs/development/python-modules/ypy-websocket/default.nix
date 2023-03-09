{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, aiofiles
, aiosqlite
, y-py
, pytest-asyncio
, pytestCheckHook
, websockets
}:

buildPythonPackage rec {
  pname = "ypy-websocket";
  version = "0.8.4";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "ypy-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-jl2ciIA3enJRfPgcu96MZN+BmNL+bBet54AFDBy3seY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiofiles
    aiosqlite
    y-py
  ];

  pythonImportsCheck = [ "ypy_websocket" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    websockets
  ];

  disabledTestPaths = [
    # requires installing yjs Node.js module
    "tests/test_ypy_yjs.py"
  ];

  meta = {
    changelog = "https://github.com/y-crdt/ypy-websocket/blob/${src.rev}/CHANGELOG.md";
    description = "WebSocket Connector for Ypy";
    homepage = "https://github.com/y-crdt/ypy-websocket";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
