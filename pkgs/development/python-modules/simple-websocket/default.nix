{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wsproto,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "simple-websocket";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "simple-websocket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dwL6GUyygNGBXqkkTnsHwFFpa1JAaeWc9ycQNRgTN4I=";
  };

  build-system = [ setuptools ];

  dependencies = [ wsproto ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simple_websocket" ];

  disabledTests = [
    # Tests require network access
    "SimpleWebSocketClientTestCase"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: There is no current event loop in thread 'MainThread'
    "AioSimpleWebSocketServerTestCase"
  ];

  meta = {
    description = "Simple WebSocket server and client for Python";
    homepage = "https://github.com/miguelgrinberg/simple-websocket";
    changelog = "https://github.com/miguelgrinberg/simple-websocket/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
