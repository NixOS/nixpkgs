{ lib
, buildPythonPackage
, fetchPypi
, python-socketio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uptime-kuma-api";
<<<<<<< HEAD
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.10.0";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "uptime_kuma_api";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-owRLc6823jJbEEzdJ3ORCkQfaEvxxs0uwYLzzCa17zI=";
=======
    hash = "sha256-qBSXQyruLVGJ0QeihnEUXOqYpvVftdFM5ED3usHT0OQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    python-socketio
    python-socketio.optional-dependencies.client
  ];

  pythonImportsCheck = [
    "uptime_kuma_api"
  ];

  # Tests need an uptime-kuma instance to run
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper for the Uptime Kuma Socket.IO API";
    homepage = "https://github.com/lucasheld/uptime-kuma-api";
<<<<<<< HEAD
    changelog = "https://github.com/lucasheld/uptime-kuma-api/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ julienmalka ];
  };
}
