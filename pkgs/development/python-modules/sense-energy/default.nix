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
  version = "0.9.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = version;
    hash = "sha256-A4FSL+T2tWGEYmjOFsf99Sn17IT7HP7/ILQjUiPUl0A=";
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
