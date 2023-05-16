{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
<<<<<<< HEAD
, aiosqlite
, anyio
=======
, aiofiles
, aiosqlite
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, y-py
, pytest-asyncio
, pytestCheckHook
, pythonRelaxDepsHook
<<<<<<< HEAD
, uvicorn
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, websockets
}:

buildPythonPackage rec {
  pname = "ypy-websocket";
<<<<<<< HEAD
  version = "0.12.3";
=======
  version = "0.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "ypy-websocket";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-gBLRjqsI2xx2z8qfaix4Gsm1rlNcjZ5g1PNVW7N4Q5k=";
=======
    hash = "sha256-jl2ciIA3enJRfPgcu96MZN+BmNL+bBet54AFDBy3seY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonRelaxDeps = [
    "aiofiles"
  ];

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiosqlite
    anyio
=======
    aiofiles
    aiosqlite
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    y-py
  ];

  pythonImportsCheck = [
    "ypy_websocket"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
<<<<<<< HEAD
    uvicorn
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    websockets
  ];

  disabledTestPaths = [
    # requires installing yjs Node.js module
    "tests/test_ypy_yjs.py"
  ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/y-crdt/ypy-websocket/blob/${src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/y-crdt/ypy-websocket/blob/${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "WebSocket Connector for Ypy";
    homepage = "https://github.com/y-crdt/ypy-websocket";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
