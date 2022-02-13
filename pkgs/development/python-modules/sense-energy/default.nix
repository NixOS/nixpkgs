{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "v${version}";
    hash = "sha256-Q4EIAVtCV5n1Ediw4QItchM/GWjUEZi4+hi//xB3Eew=";
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
