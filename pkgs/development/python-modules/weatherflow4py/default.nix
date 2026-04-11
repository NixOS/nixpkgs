{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  hatchling,
  marshmallow,
  pytest-asyncio,
  pytestCheckHook,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "weatherflow4py";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "weatherflow4py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cfQWdQhjW6KjBLQWO9BSAVZ2btRCMjx1CpUifoOwPsU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    dataclasses-json
    marshmallow
    websockets
  ];

  pythonRelaxDeps = [ "marshmallow" ];

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

  meta = {
    description = "Module to interact with the WeatherFlow REST API";
    homepage = "https://github.com/jeeftor/weatherflow4py";
    changelog = "https://github.com/jeeftor/weatherflow4py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
