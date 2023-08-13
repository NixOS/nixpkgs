{ lib
, buildPythonPackage
, fetchPypi
, python-socketio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uptime-kuma-api";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "uptime_kuma_api";
    inherit version;
    hash = "sha256-3Y7PGidtmBjrIXGAElzRAv//kvX0ZcK3OX0xnfeuLWE=";
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
    changelog = "https://github.com/lucasheld/uptime-kuma-api/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ julienmalka ];
  };
}
