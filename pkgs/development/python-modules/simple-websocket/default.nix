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
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "simple-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-5dUZnbjHzH1sQ93CbFdEoW9j2zY4Z+8wNsYfmOrgC8E=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    wsproto
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
