{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, promise
, python-socketio
, pythonOlder
, requests
, websockets
}:

buildPythonPackage rec {
  pname = "tago";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "tago-sdk-python";
    rev = version;
    hash = "sha256-eu6n83qmo1PQKnR/ellto04xi/3egl+LSKMOG277X1k=";
  };

  propagatedBuildInputs = [
    aiohttp
    promise
    python-socketio
    requests
    websockets
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "tago"
  ];

  meta = with lib; {
    description = "Python module for interacting with Tago.io";
    homepage = "https://github.com/tago-io/tago-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
