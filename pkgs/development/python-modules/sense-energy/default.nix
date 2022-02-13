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
  version = "0.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = version;
    hash = "sha256-93o1UfoZ+Sb+lMg4Xdd4eGBEdrSCVSin5HJVnaRyp8o=";
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
