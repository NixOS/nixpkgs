{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "jwillemsen";
  domain = "daikin_onecta";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${version}";
    hash = "sha256-55IGU3qYTt4V+BYDNiYx2l/EiuPNESfJHi5QCRm36Qk=";
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/releases/tag/v${version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
}
