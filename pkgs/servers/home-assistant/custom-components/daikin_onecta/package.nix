{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "jwillemsen";
  domain = "daikin_onecta";
  version = "4.2.6";

  src = fetchFromGitHub {
    owner = "jwillemsen";
    repo = "daikin_onecta";
    tag = "v${version}";
    hash = "sha256-JBo2205wHeC+5+kontzqgRLTss2Naht/TbkuEAs2nSQ=";
  };

  meta = {
    changelog = "https://github.com/jwillemsen/daikin_onecta/tag/v${version}";
    description = "Home Assistant Integration for devices supported by the Daikin Onecta App";
    homepage = "https://github.com/jwillemsen/daikin_onecta";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl3Only;
  };
}
