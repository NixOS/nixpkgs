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
  version = "0.10.1";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = "volvooncall";
    rev = "v${version}";
    hash = "sha256-udYvgKj7Rlc/hA86bbeBfnoVRjKkXT4TwpceWz226cU=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  passthru.optional-dependencies = {
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

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.mqtt;

  pythonImportsCheck = [ "volvooncall" ];

  meta = with lib; {
    description = "Retrieve information from the Volvo On Call web service";
    homepage = "https://github.com/molobrakos/volvooncall";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dotlambda ];
  };
}
