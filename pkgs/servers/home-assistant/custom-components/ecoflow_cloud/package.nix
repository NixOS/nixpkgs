{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  jsonpath-ng,
  paho-mqtt,
  protobuf,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "tolwi";
  domain = "ecoflow_cloud";
  version = "1.5.0-shp3.9";

  src = fetchFromGitHub {
    owner = "tolwi";
    repo = "hassio-ecoflow-cloud";
    tag = "v${version}";
    hash = "sha256-QwpA3TVhU36QPeejV9rpo24iwGtQ4UeDLDqc384ji7U=";
  };

  ignoreVersionRequirement = [
    "protobuf"
  ];

  dependencies = [
    jsonpath-ng
    paho-mqtt
    protobuf
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/tolwi/hassio-ecoflow-cloud/releases/tag/v${version}";
    description = "Home Assistant component for EcoFlow Cloud";
    homepage = "https://github.com/tolwi/hassio-ecoflow-cloud";
    maintainers = with lib.maintainers; [ ananthb ];
    license = lib.licenses.asl20;
  };
}
