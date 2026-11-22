{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  bleak,
  bleak-retry-connector,
  crc,
  ecdsa,
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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "rabits";
    repo = "ha-ef-ble";
    tag = "v${version}";
    hash = "sha256-7QGcR9uJvQ43EGKPc0ioregFEZPW8qAQbu/4zRDPTos=";
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
