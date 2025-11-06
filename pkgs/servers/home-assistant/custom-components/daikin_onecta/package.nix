{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "jwillemsen";
  domain = "daikin_onecta";
  version = "4.2.9";

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${version}";
    hash = "sha256-bV+4nTRhtqSVBdaG3rCtIdTYhM4pqcQCtUQwsUhgcq0=";
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/tag/v${version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
}
