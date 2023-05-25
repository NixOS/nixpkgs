{ lib
, buildPythonPackage
, fetchFromGitHub
, exceptiongroup
, pytest-trio
, pytestCheckHook
, trio
, trustme
, wsproto
}:

buildPythonPackage rec {
  pname = "trio-websocket";
  version = "0.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HyperionGray";
    repo = "trio-websocket";
    rev = version;
    hash = "sha256-djoTxkIKY52l+WnxL1FwlqrU/zvsLVkPUAHn9BxJ45k=";
  };

  propagatedBuildInputs = [
    exceptiongroup
    trio
    wsproto
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [ "trio_websocket" ];

  meta = with lib; {
    changelog = "https://github.com/HyperionGray/trio-websocket/blob/${version}/CHANGELOG.md";
    description = "WebSocket client and server implementation for Python Trio";
    homepage = "https://github.com/HyperionGray/trio-websocket";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
