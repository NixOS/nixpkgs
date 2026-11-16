{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  valetudo-map-parser,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "sca075";
  domain = "mqtt_vacuum_camera";
  version = "2026.10.0";

  src = fetchFromGitHub {
    owner = "sca075";
    repo = "mqtt_vacuum_camera";
    tag = finalAttrs.version;
    hash = "sha256-/xTjgIG6UOqbHNE7A2VYIeZcHVSG1vJdJiZWMjIj7d0=";
  };

  dependencies = [ valetudo-map-parser ];

  meta = {
    description = "Render MQTT-connected vacuum maps in Home Assistant";
    homepage = "https://github.com/sca075/mqtt_vacuum_camera";
    changelog = "https://github.com/sca075/mqtt_vacuum_camera/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
