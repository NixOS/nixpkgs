{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "xiaomi-weather";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "xiaomi_weather";
    inherit (finalAttrs) version;
    hash = "sha256-JzYofdCHsfh02XMpeJl1xUWvrDVLCZljTIdHo7wkunQ=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xiaomi_weather" ];

  meta = {
    description = "Typed asyncio client for Xiaomi Weather";
    homepage = "https://github.com/shirok1/python-xiaomi-weather";
    changelog = "https://github.com/shirok1/python-xiaomi-weather/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.shirok1 ];
  };
})
