{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wsproto,
}:

buildPythonPackage rec {
  pname = "simple-websocket";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "simple-websocket";
    rev = "refs/tags/v${version}";
    hash = "sha256-dwL6GUyygNGBXqkkTnsHwFFpa1JAaeWc9ycQNRgTN4I=";
  };

  build-system = [ setuptools ];

  dependencies = [ wsproto ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simple_websocket" ];

  disabledTests = [
    # Tests require network access
    "SimpleWebSocketClientTestCase"
  ];

  meta = with lib; {
    description = "Simple WebSocket server and client for Python";
    homepage = "https://github.com/miguelgrinberg/simple-websocket";
    changelog = "https://github.com/miguelgrinberg/simple-websocket/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
