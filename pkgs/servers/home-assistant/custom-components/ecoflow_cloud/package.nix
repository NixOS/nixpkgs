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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "tolwi";
    repo = "hassio-ecoflow-cloud";
    tag = "v${version}";
    hash = "sha256-x0K+yxOMnnorz7KFLWHDN3Dt84q1yRfTe1f5uVizs5o=";
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
