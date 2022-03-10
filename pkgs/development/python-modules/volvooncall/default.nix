{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, geopy
, docopt
, pyyaml
, certifi
, amqtt
, websockets
, aiohttp
, pytestCheckHook
, asynctest
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "volvooncall";
  version = "0.9.2";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = "volvooncall";
    rev = "v${version}";
    hash = "sha256-OTs282z7qzILl/xxM3whaxiQr8FZOfgceO2EY3NJKbA=";
  };

  propagatedBuildInputs = [
    geopy
    docopt
    pyyaml
    certifi
    amqtt
    websockets
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
    asynctest
    pytest-asyncio
  ];

  pythonImportsCheck = [ "volvooncall" ];

  meta = with lib; {
    description = "Retrieve information from the Volvo On Call web service";
    homepage = "https://github.com/molobrakos/volvooncall";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dotlambda ];
  };
}
