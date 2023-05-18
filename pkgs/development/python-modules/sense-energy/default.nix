{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, orjson
, pythonOlder
, requests
, websocket-client
, websockets
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "refs/tags/${version}";
    hash = "sha256-i6XI6hiQTOGHB4KcDgz/MlYAhdEKaElLfNMq2R0fgu8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  propagatedBuildInputs = [
    aiohttp
    async-timeout
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
