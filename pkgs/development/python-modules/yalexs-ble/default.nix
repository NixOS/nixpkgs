{
  lib,
  async-interrupt,
  async-timeout,
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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yalexs-ble";
  version = "2.5.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs-ble";
    tag = "v${version}";
    hash = "sha256-EJKFlHw+lwNKUFVYg/wa0BqPeuui/2WXfWYwgG/kbHw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    async-timeout
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

  meta = with lib; {
    description = "Library for Yale BLE devices";
    homepage = "https://github.com/bdraco/yalexs-ble";
    changelog = "https://github.com/bdraco/yalexs-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
