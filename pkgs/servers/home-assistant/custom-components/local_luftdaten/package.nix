{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "lichtteil";
  domain = "local_luftdaten";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lichtteil";
    repo = "local_luftdaten";
    tag = version;
    hash = "sha256-K8sQ/xm9aoJ6EBF9H9Y87m7a0OZN4y6T3DFZcSpPYOI=";
  };

  meta = {
    changelog = "https://github.com/lichtteil/local_luftdaten/releases/tag/${version}";
    description = "Custom component for Home Assistant that integrates your (own) local Luftdaten sensor (air quality/particle sensor) without using the cloud";
    homepage = "https://github.com/lichtteil/local_luftdaten";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
