{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  promise,
  python-socketio,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "tago";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "tago-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-q1xcPF+oeQsCAZjeYTVY2aaKFmb8rCTWVikGxdpPQ28=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    aiohttp
    promise
    python-socketio
    requests
    websockets
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "tago" ];

  meta = with lib; {
    description = "Python module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/tago-sdk-python";
    changelog = "https://github.com/tago-io/tago-sdk-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
