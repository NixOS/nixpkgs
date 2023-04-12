{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "zwave-me-ws";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Z-Wave-Me";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Wo67G5jzNDl+70+pXEwCw4vck3Dlh7ClpPO6T7RYdBc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
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
    changelog = "https://github.com/Z-Wave-Me/zwave-me-ws/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
