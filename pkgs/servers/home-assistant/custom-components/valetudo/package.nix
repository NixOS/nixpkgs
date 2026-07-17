{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
}:
buildHomeAssistantComponent rec {
  owner = "Hypfer";
  domain = "valetudo";
  version = "2026.01.1";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "hass-valetudo";
    tag = "${version}";
    hash = "sha256-xJ8kA+ujWuen5660GWZSo90WsHpfwQVStIheaIRxAg8=";
  };
  meta = {
    description = "Valetudo for Home Assistant";
    homepage = "https://github.com/Hypfer/hass-valetudo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
