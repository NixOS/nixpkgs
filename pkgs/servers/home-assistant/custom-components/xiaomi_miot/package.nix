{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  construct,
  micloud,
  python-miio,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "al-one";
  domain = "xiaomi_miot";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "al-one";
    repo = "hass-xiaomi-miot";
    rev = "v${version}";
    hash = "sha256-WoPzWCraTj0VNzwZT9IpK7Loc1OuoQf/2B++SwP7f0Y=";
  };

  dependencies = [
    construct
    micloud
    python-miio
  ];

  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/al-one/hass-xiaomi-miot/releases/tag/v${version}";
    description = "Automatic integrate all Xiaomi devices to HomeAssistant via miot-spec, support Wi-Fi, BLE, ZigBee devices";
    longDescription = ''
      Xiaomi Miot For HomeAssistant depends on `ffmpeg` and `homekit`, example how to setup in NixOS `configuration.nix`:

      ```
      { config, lib, pkgs, ... }:
      {
        services.home-assistant = {
          customComponents = [ pkgs.home-assistant-custom-components.xiaomi_miot ];
          extraComponents = [ "ffmpeg" "homekit" ];
        };
      }
      ```
    '';
    homepage = "https://github.com/al-one/hass-xiaomi-miot";
    maintainers = with lib.maintainers; [ azuwis ];
    license = lib.licenses.asl20;
  };
}
