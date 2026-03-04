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
  version = "3.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yale-Libs";
    repo = "yalexs-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Y2ix5ikrWC9taCHJhg8Irt3PGOiH+OzqLRSVW/q8Gs=";
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
