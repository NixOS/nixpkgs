{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "magico13";
  domain = "emporia_vue";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
    hash = "sha256-p8rBO+Z64n87NE7BXNSsTT5IA7ba5RzCZjqX05LqD0A=";
  };

  dependencies = [
    pyemvue
  ];

  ignoreVersionRequirement = [
    "pyemvue"
  ];

  meta = with lib; {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
