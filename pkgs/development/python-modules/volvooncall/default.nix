{ lib
, aiohttp
, amqtt
, buildPythonPackage
, certifi
, docopt
, fetchFromGitHub
, fetchpatch
, geopy
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "volvooncall";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = "volvooncall";
    rev = "refs/tags/v${version}";
    hash = "sha256-/BMwDuo4xE/XOLM8qzJwt0A0h0+ihbCVCxT3BBToiVU=";
  };

  patches = [
    # Remove async, https://github.com/molobrakos/volvooncall/pull/92
    (fetchpatch {
      name = "remove-asnyc.patch";
      url = "https://github.com/molobrakos/volvooncall/commit/ef0df403250288c00ed4c600e9dfa79dcba8941e.patch";
      hash = "sha256-U+hM7vzD9JSEUumvjPSLpVQcc8jAuZHG3/1dQ3wnIcA=";
    })
  ];

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

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.mqtt;

  pythonImportsCheck = [
    "volvooncall"
  ];

  meta = with lib; {
    description = "Retrieve information from the Volvo On Call web service";
    homepage = "https://github.com/molobrakos/volvooncall";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dotlambda ];
  };
}
