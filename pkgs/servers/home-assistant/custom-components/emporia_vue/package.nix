{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "magico13";
  domain = "emporia_vue";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
    hash = "sha256-OfJvln80ek/+4PURk23REhIyUckAEZ+Ybb5rZyKs6h4=";
  };

  dependencies = [
    pyemvue
  ];

  ignoreVersionRequirement = [
    "pyemvue"
  ];

  dontBuild = true;

  meta = with lib; {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
