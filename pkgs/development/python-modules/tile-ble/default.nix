{
  lib,
  aiohttp,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "tile-ble";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-tile-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZlSH9X4IvRR4Hlm1GUh3Q8o362DyqLHoFuyjZdqBLZ4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "tile_ble" ];

  meta = {
    description = "Asynchronous Python client for Tile trackers over Bluetooth";
    homepage = "https://github.com/joostlek/python-tile-ble";
    changelog = "https://github.com/joostlek/python-tile-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
