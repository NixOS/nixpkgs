{
  lib,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lru-dict,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "yalexs-ble";
  version = "7.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yale-Libs";
    repo = "yalexs-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Aroqyg/2OcfJu8iI8UAVcoBIGDljW6/Obv9r9SrdFY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    bleak
    bleak-retry-connector
    cryptography
    lru-dict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yalexs_ble" ];

  meta = {
    description = "Library for Yale BLE devices";
    homepage = "https://github.com/Yale-Libs/yalexs-ble";
    changelog = "https://github.com/Yale-Libs/yalexs-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
