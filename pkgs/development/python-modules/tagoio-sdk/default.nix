{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  requests,
  requests-mock,
  requests-toolbelt,
  sseclient-py,
}:

buildPythonPackage (finalAttrs: {
  pname = "tagoio-sdk";
  version = "5.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pNkG1T1eIvAGc0v+FXdDYxHea7whFN2Uq8Ozj7rJ/fQ=";
  };

  pythonRelaxDeps = [ "requests" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    python-dateutil
    python-socketio
    requests
    requests-toolbelt
    sseclient-py
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tagoio_sdk" ];

  meta = {
    description = "Module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/sdk-python";
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
