{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "magico13";
  domain = "emporia_vue";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
    hash = "sha256-6VeyKmFKbBG6MgQqylkTg1blZJlBKBWYdkUmCYyEV2I=";
  };

  dependencies = [
    pyemvue
  ];

  ignoreVersionRequirement = [
    "pyemvue"
  ];

  meta = {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ presto8 ];
    license = lib.licenses.mit;
  };
}
