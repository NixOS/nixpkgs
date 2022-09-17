{ lib
, buildPythonPackage
, fetchFromGitHub
, async_generator
, pytest-trio
, pytestCheckHook
, trio
, trustme
, wsproto
}:

buildPythonPackage rec {
  pname = "trio-websocket";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "HyperionGray";
    repo = "trio-websocket";
    rev = version;
    sha256 = "sha256-8VrpI/pk5IhEvqzo036cnIbJ1Hu3UfQ6GHTNkNJUYvo=";
  };

  propagatedBuildInputs = [
    async_generator
    trio
    wsproto
  ];

  checkInputs = [
    pytest-trio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [ "trio_websocket" ];

  meta = with lib; {
    description = "WebSocket client and server implementation for Python Trio";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
