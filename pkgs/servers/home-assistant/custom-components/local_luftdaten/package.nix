{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "lichtteil";
  domain = "local_luftdaten";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "lichtteil";
    repo = "local_luftdaten";
    tag = version;
    hash = "sha256-VVMTZjxcfq/nAh4FhlDlkmLV45M9y5fkWa5s68Qd8oI=";
  };

  meta = {
    changelog = "https://github.com/lichtteil/local_luftdaten/releases/tag/${version}";
    description = "Custom component for Home Assistant that integrates your (own) local Luftdaten sensor (air quality/particle sensor) without using the cloud";
    homepage = "https://github.com/lichtteil/local_luftdaten";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
