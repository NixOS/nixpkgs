{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "magico13";
  domain = "emporia_vue";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
    hash = "sha256-bUfFRcVu/i6yp9BbfM3d6J8TBT3X35HNk0tr00JIwC8=";
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
