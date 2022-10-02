{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, pythonOlder
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.10.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = version;
    hash = "sha256-yflI17lLZMXXB0ye+jz3VWWMdZtcBTwbg8deA4ENmWw=";
  };

  propagatedBuildInputs = [
    aiohttp
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
