{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "lichtteil";
  domain = "local_luftdaten";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lichtteil";
    repo = "local_luftdaten";
    rev = version;
    hash = "sha256-68clZgS7Qo62srcZWD3Un9BnNSwQUBr4Z5oBMTC9m8o=";
  };

  meta = with lib; {
    changelog = "https://github.com/lichtteil/local_luftdaten/releases/tag/${version}";
    description = "Custom component for Home Assistant that integrates your (own) local Luftdaten sensor (air quality/particle sensor) without using the cloud";
    homepage = "https://github.com/lichtteil/local_luftdaten";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
