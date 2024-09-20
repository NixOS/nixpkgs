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
  version = "0.7.20";

  src = fetchFromGitHub {
    owner = "al-one";
    repo = "hass-xiaomi-miot";
    rev = "v${version}";
    hash = "sha256-wR5N6a+g4TE9cRv1k4zExCWiui7ZHwK54j0oUxnhcR0=";
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
