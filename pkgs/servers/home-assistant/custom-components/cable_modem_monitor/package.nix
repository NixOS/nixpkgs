{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  nix-update-script,
  solentlabs-cable-modem-monitor-catalog,
  solentlabs-cable-modem-monitor-core,
}:

buildHomeAssistantComponent rec {
  owner = "solentlabs";
  domain = "cable_modem_monitor";
  version = "3.14.0-beta.2";

  src = fetchFromGitHub {
    owner = "solentlabs";
    repo = "cable_modem_monitor";
    tag = "v${version}";
    hash = "sha256-plSW3moR5Uf2cDSxeX9EjlT7+tQf51zBk/4JsJ0pNl0=";
  };

  dependencies = [
    solentlabs-cable-modem-monitor-catalog
    solentlabs-cable-modem-monitor-core
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    description = "Home Assistant integration for monitoring cable modem signal quality";
    homepage = "https://solentlabs.io/cable-modem-monitor";
    changelog = "https://github.com/solentlabs/cable_modem_monitor/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
}
