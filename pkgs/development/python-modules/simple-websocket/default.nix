{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, wheel
, wsproto
}:

buildPythonPackage rec {
  pname = "simple-websocket";
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "simple-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-OdgMYi2UobIlE4cDl5aNtVaFiHPTpf5TcuohG+TCSpg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    wsproto
  ];

  pythonImportsCheck = [
    "simple_websocket"
  ];

  meta = with lib; {
    description = "Simple WebSocket server and client for Python";
    homepage = "https://github.com/miguelgrinberg/simple-websocket";
    changelog = "https://github.com/miguelgrinberg/simple-websocket/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
