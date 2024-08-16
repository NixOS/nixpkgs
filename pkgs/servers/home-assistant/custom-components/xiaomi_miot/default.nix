{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  hap-python,
  micloud,
  pyqrcode,
  python-miio,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "al-one";
  domain = "xiaomi_miot";
  version = "0.7.19";

  src = fetchFromGitHub {
    owner = "al-one";
    repo = "hass-xiaomi-miot";
    rev = "v${version}";
    hash = "sha256-QtvcXQOq4aqXdydXaWDtRSZYzD0ZqDstpestdBiTQwo=";
  };

  propagatedBuildInputs = [
    hap-python
    micloud
    pyqrcode
    python-miio
  ];

  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/al-one/hass-xiaomi-miot/releases/tag/v${version}";
    description = "Automatic integrate all Xiaomi devices to HomeAssistant via miot-spec, support Wi-Fi, BLE, ZigBee devices";
    homepage = "https://github.com/al-one/hass-xiaomi-miot";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.asl20;
  };
}
