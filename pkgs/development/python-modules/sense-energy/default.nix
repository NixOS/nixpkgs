{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, kasa-crypt
, orjson
, pythonOlder
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "refs/tags/${version}";
    hash = "sha256-LVpTB7Q78N/cRbneJJ1aT+lFE790ssdMHo8VRirtDHY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    kasa-crypt
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
    changelog = "https://github.com/scottbonline/sense/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
