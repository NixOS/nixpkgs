{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-engineio
, python-socketio
, pythonOlder
, websocket-client
}:

buildPythonPackage rec {
  pname = "zwave-me-ws";
  version = "0.2.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Z-Wave-Me";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BcUUDn7PCpFRtQ3QDx0W3qXB4JmvRxMFoWoCeA8bS6o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    websocket-client
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "zwave_me_ws"
  ];

  meta = with lib; {
    description = "Library to connect to a ZWave-Me instance";
    homepage = "https://github.com/Z-Wave-Me/zwave-me-ws";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
