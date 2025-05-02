{ lib
, buildHomeAssistantComponent
, fetchFromGitHub
, hap-python
, micloud
, pyqrcode
, python-miio
}:

buildHomeAssistantComponent rec {
  owner = "al-one";
  domain = "xiaomi_miot";
  version = "0.7.17";

  src = fetchFromGitHub {
    owner = "al-one";
    repo = "hass-xiaomi-miot";
    rev = "v${version}";
    hash = "sha256-IpL4e2mKCdtNu8NtI+xpx4FPW/uj1M5Rk6DswXmSJBk=";
  };

  propagatedBuildInputs = [
    hap-python
    micloud
    pyqrcode
    python-miio
  ];

  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/al-one/hass-xiaomi-miot/releases/tag/${version}";
    description = "Automatic integrate all Xiaomi devices to HomeAssistant via miot-spec, support Wi-Fi, BLE, ZigBee devices.";
    homepage = "https://github.com/al-one/hass-xiaomi-miot";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.asl20;
  };
}
