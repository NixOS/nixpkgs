{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  smllib,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "marq24";
  domain = "tibber_local";
  version = "2026.10.4";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-tibber-pulse-local";
    tag = finalAttrs.version;
    hash = "sha256-YEbW6Mp1c3jjcoSsPmIr4vByEzSynGW6lzR9yiQFeKc=";
  };

  dependencies = [
    smllib
  ];

  meta = {
    changelog = "https://github.com/marq24/ha-tibber-pulse-local/releases/tag/${finalAttrs.version}";
    description = "Local/LAN Tibber Pulse IR/Bridge Integration for Home Assistant";
    homepage = "https://github.com/marq24/ha-tibber-pulse-local";
    maintainers = with lib.maintainers; [ hensoko ];
    license = lib.licenses.asl20;
  };
})
