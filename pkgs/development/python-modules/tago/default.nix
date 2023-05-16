{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, promise
, python-socketio
, pythonOlder
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, websockets
}:

buildPythonPackage rec {
  pname = "tago";
<<<<<<< HEAD
  version = "3.1.1";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tago-io";
    repo = "tago-sdk-python";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-q1xcPF+oeQsCAZjeYTVY2aaKFmb8rCTWVikGxdpPQ28=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

=======
    rev = version;
    hash = "sha256-eu6n83qmo1PQKnR/ellto04xi/3egl+LSKMOG277X1k=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/tago-io/tago-sdk-python/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
