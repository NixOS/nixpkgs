{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  bleak,
  bleak-retry-connector,
  crc,
  ecdsa,
  jsonpath-ng,
  protobuf6,
  pycryptodome,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "rabits";
  domain = "ef_ble";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "rabits";
    repo = "ha-ef-ble";
    tag = "v${version}";
    hash = "sha256-hqwsoG8BkB16zR5MX3NNltEQAZR0ZhVFNXSqDsvep+0=";
  };

  dependencies = [
    bleak
    bleak-retry-connector
    ecdsa
    crc
    protobuf6
    pycryptodome
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rabits/ha-ef-ble/releases/tag/v${version}";
    description = "Home Assistant component for EcoFlow BLE devices (local)";
    homepage = "https://github.com/rabits/ha-ef-ble";
    maintainers = with lib.maintainers; [ implr ];
    license = lib.licenses.asl20;
  };
}
