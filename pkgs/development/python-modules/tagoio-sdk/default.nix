{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  pythonOlder,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "tagoio-sdk";
  version = "5.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "sdk-python";
    tag = "v${version}";
    hash = "sha256-PNPG1FUniwZhOKjynp4ba6kjGJmB/OW0F5b2ZOYaYwY=";
  };

  pythonRelaxDeps = [ "requests" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    python-socketio
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tagoio_sdk" ];

  meta = with lib; {
    description = "Module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/sdk-python";
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
