{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, geopy
, docopt
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
  version = "0.10.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = "volvooncall";
    rev = "v${version}";
    hash = "sha256-HLSanXJs1yPSgYo4oX0zJtrV5sKkxV2yLPhc2dVRHY8=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  passthru.extras-require = {
    console = [
      certifi
      docopt
      geopy
    ];
    mqtt = [
      amqtt
      certifi
    ];
  };

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ] ++ passthru.extras-require.mqtt;

  pythonImportsCheck = [ "volvooncall" ];

  meta = with lib; {
    description = "Retrieve information from the Volvo On Call web service";
    homepage = "https://github.com/molobrakos/volvooncall";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dotlambda ];
  };
}
