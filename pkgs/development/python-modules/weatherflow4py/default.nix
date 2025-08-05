{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  marshmallow,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  websockets,
}:

buildPythonPackage rec {
  pname = "weatherflow4py";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "weatherflow4py";
    tag = "v${version}";
    hash = "sha256-nHpLdzO49HhX5+gtYrgche4whs7Onzp4HeRNFwLHcVI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dataclasses-json
    marshmallow
    websockets
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "weatherflow4py" ];

  disabledTests = [
    # KeyError
    "test_convert_json_to_weather_data4"
  ];

  meta = with lib; {
    description = "Module to interact with the WeatherFlow REST API";
    homepage = "https://github.com/jeeftor/weatherflow4py";
    changelog = "https://github.com/jeeftor/weatherflow4py/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
