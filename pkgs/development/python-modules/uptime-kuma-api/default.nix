{ lib
, buildPythonPackage
, fetchPypi
, python-socketio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uptime-kuma-api";
  version = "0.10.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "uptime_kuma_api";
    inherit version;
    hash = "sha256-qBSXQyruLVGJ0QeihnEUXOqYpvVftdFM5ED3usHT0OQ=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ julienmalka ];
  };
}
