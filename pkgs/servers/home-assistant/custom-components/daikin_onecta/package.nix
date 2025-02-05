{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "jwillemsen";
  domain = "daikin_onecta";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${version}";
    hash = "sha256-kjFBy+Nq9aQSsmvzWT2Wy/BwMpyd8GdgSXIrp44cMnA=";
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/tag/v${version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
}
