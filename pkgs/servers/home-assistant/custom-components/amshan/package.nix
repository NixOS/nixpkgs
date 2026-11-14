{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  amshan,
}:

buildHomeAssistantComponent rec {
  owner = "toreamun";
  domain = "amshan";
  version = "2024.12.0";

  src = fetchFromGitHub {
    owner = "toreamun";
    repo = "amshan-homeassistant";
    tag = version;
    hash = "sha256-L7TGdUjDvIRP9dHIkng9GYwilmRzhGbUK6ivx8PVtQ4=";
  };

  dependencies = [
    amshan
  ];

  meta = {
    description = "Home Assistant integration for electricity meters (AMS/HAN/P1)";
    longDescription = ''
      The integration supports both streaming (serial port / TCP/IP) and MQTT
      (Tibber Pulse, energyintelligence.se etc.).
    '';
    homepage = "https://github.com/toreamun/amshan-homeassistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
