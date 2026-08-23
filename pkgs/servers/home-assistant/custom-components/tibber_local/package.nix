{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  smllib,
}:

buildHomeAssistantComponent rec {
  owner = "marq24";
  domain = "tibber_local";
  version = "2026.8.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-tibber-pulse-local";
    tag = version;
    hash = "sha256-lR3URLk6gpp2d+xfiNaHp2wb59SFxaEgLS1uFA9LTHs=";
  };

  dependencies = [
    smllib
  ];

  meta = {
    changelog = "https://github.com/marq24/ha-tibber-pulse-local/releases/tag/${version}";
    description = "Local/LAN Tibber Pulse IR/Bridge Integration for Home Assistant";
    homepage = "https://github.com/marq24/ha-tibber-pulse-local";
    maintainers = with lib.maintainers; [ hensoko ];
    license = lib.licenses.asl20;
  };
}
