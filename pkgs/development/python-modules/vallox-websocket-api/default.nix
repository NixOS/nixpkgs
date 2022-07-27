{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, construct
, websockets
, asynctest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vallox-websocket-api";
  version = "2.12.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "vallox_websocket_api";
    rev = "refs/tags/${version}";
    hash = "sha256-Ibp+oAd6q8Vu9V+TaLzlPbWIDheFUjCyW83Hg4Ztw20=";
  };

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
