{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  smllib,
}:

buildHomeAssistantComponent rec {
  owner = "marq24";
  domain = "tibber_local";
  version = "2026.8.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-tibber-pulse-local";
    tag = version;
    hash = "sha256-IUhOVMMX2uM3cR2ZD88lCxNEn4YW4/NhgWe+Y8MTzK8=";
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
