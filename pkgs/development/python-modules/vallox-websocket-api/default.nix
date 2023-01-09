{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, construct
, websockets
, asynctest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    rev = "refs/tags/${version}";
    hash = "sha256-iy5ipW7ldvLWhfxgPlWcsFeKrAXqtyypveAX74u8zmo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    construct
    websockets
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
  ];

  meta = {
    description = "Async API for Vallox ventilation units";
    homepage = "https://github.com/yozik04/vallox_websocket_api";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
