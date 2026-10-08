{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bleak,
  bleak-retry-connector,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "silabs-ble-ota";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "silabs-ble-ota";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0CRTeXWdWvBFECVyfq7K38iN4nLphzgJ0H5tCjHnVkw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "silabs_ble_ota"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Flash firmware to Silicon Labs EFR32 devices over BLE";
    homepage = "https://github.com/OpenDisplay/silabs-ble-ota";
    changelog = "https://github.com/OpenDisplay/silabs-ble-ota/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
