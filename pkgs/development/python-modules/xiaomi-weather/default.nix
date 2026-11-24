{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xiaomi-weather";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shirok1";
    repo = "python-xiaomi-weather";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wii69gKBfjt6h+W61QNhc6fChR1UChbyLVLtEXKsTY4=";
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
    changelog = "https://github.com/shirok1/python-xiaomi-weather/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
