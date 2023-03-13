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
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "refs/tags/${version}";
    hash = "sha256-lfqQelAHh/xJH1jPz3JK32AIEA7ghUP6Mnya2M34V/w=";
  };

  postPatch = ''
    sed -i '/download_url/d' setup.py
  '';

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
