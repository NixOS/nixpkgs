{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "zwave-me-ws";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Z-Wave-Me";
    repo = "zwave-me-ws";
    tag = "v${version}";
    hash = "sha256-bTchtgr+UbHCpcXMaQA3bTrhasJ79TguvAqLNlpD/2c=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    websocket-client
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "zwave_me_ws" ];

  meta = {
    description = "Library to connect to a ZWave-Me instance";
    homepage = "https://github.com/Z-Wave-Me/zwave-me-ws";
    changelog = "https://github.com/Z-Wave-Me/zwave-me-ws/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
