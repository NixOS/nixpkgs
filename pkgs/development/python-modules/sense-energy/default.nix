{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
<<<<<<< HEAD
, kasa-crypt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, orjson
, pythonOlder
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6zhbchCRHyltJ/EP9Hnj4LoRn7/0PDJCmWNjF+IsQdM=";
=======
    hash = "sha256-i6XI6hiQTOGHB4KcDgz/MlYAhdEKaElLfNMq2R0fgu8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  propagatedBuildInputs = [
    aiohttp
    async-timeout
<<<<<<< HEAD
    kasa-crypt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    orjson
    requests
    websocket-client
    websockets
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "sense_energy"
  ];

  meta = with lib; {
    description = "API for the Sense Energy Monitor";
    homepage = "https://github.com/scottbonline/sense";
<<<<<<< HEAD
    changelog = "https://github.com/scottbonline/sense/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
