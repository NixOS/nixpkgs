{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  construct,
  paho-mqtt,
  numpy,
  cryptography,
  psutil-home-assistant,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "XiaoMi";
  domain = "xiaomi_home";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "XiaoMi";
    repo = "ha_xiaomi_home";
    rev = "v${version}";
    hash = "sha256-X8AP2pFGhkh4f72+pORXBB8yOqgIqJ+SLrQx5gwKxEg=";
  };

  dependencies = [
    construct
    paho-mqtt
    numpy
    cryptography
    psutil-home-assistant
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=^v([0-9.]+)$" ]; };

  meta = {
    changelog = "https://github.com/XiaoMi/ha_xiaomi_home/releases/tag/v${version}";
    description = "Xiaomi Home Integration for Home Assistant";
    longDescription = ''
      Xiaomi Home Integration for Home Assistant depends on additional components, example how to setup in NixOS `configuration.nix`:

      ```
      { config, lib, pkgs, ... }:
      {
        services.home-assistant = {
          customComponents = [ pkgs.home-assistant-custom-components.xiaomi_home ];
          extraComponents = [ "ffmpeg" "zeroconf" ];
        };
        # OAuth2 Redirect URL is hardcoded as http://homeassistant.local:8123
        # Make sure you can access HA via this URL with mDNS
        services.avahi.hostName = "homeassistant";
        networking.firewall.allowedTCPPorts = [ 8123 ];
      }
      ```
    '';
    homepage = "https://github.com/XiaoMi/ha_xiaomi_home";
    maintainers = with lib.maintainers; [ MakiseKurisu ];
    license = lib.licenses.unfree;
  };
}
