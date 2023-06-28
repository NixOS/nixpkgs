{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, python-dateutil
, python-socketio
, pythonOlder
, pythonRelaxDepsHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "tagoio-sdk";
  version = "4.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GHjkw7B/T+XZ3F3XCI0INpx9NWjORr0lbuGse/W25wY=";
  };

  pythonRelaxDeps = [
    "requests"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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

  pythonImportsCheck = [
    "tagoio_sdk"
  ];

  meta = with lib; {
    description = "Module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/sdk-python";
    changelog = "https://github.com/tago-io/sdk-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
