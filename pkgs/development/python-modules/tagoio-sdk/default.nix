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

buildPythonPackage rec {
  pname = "tagoio-sdk";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "sdk-python";
    tag = "v${version}";
    hash = "sha256-jKgH78ZFb9hr7rb71mF7qIpfDzCCWLlqUJVjO88dbYc=";
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
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
