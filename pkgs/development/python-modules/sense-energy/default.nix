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
  version = "0.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = version;
    hash = "sha256-0D0AagmLozF5nLbdcmtE9q65vG2WxWv+hZLTnjmmfEY=";
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
