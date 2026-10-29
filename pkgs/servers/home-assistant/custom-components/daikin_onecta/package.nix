{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "jwillemsen";
  domain = "daikin_onecta";
  version = "4.6.19";

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8VEURHJk3A449Y0HeUF+1cSsXlfZJHFFK3cg2Ero/Ec=";
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/releases/tag/v${finalAttrs.version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
})
