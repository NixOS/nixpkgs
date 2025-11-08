{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "megakid";
  domain = "hildebrand_glow_ihd";
  version = "1.8.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha_hildebrand_glow_ihd_mqtt";
    tag = "v${version}";
    hash = "sha256-13NmNHaCYDZkWK5uqKeTZlB84UuThNLOAYaPS4QfTKY=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/megakid/ha_hildebrand_glow_ihd_mqtt/releases/tag/${src.tag}";
    description = "Home Assistant integration for local MQTT Hildebrand Glow IHD";
    homepage = "https://github.com/megakid/ha_hildebrand_glow_ihd_mqtt";
    maintainers = with lib.maintainers; [ CodedNil ];
  };
}
