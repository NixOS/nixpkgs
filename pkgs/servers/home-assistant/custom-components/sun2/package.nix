{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "pnbruckner";
  domain = "sun2";
  version = "3.4.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-sun2";
    tag = version;
    hash = "sha256-gorjykAEQGglH7nyAHMZDeSEERPuZINHTN3IiH3RKsQ=";
  };

  meta = rec {
    description = "Home Assistant Sun2 sensor";
    homepage = "https://github.com/pnbruckner/ha-sun2";
    changelog = "${homepage}/releases/tag/${version}";
    maintainers = with lib.maintainers; [ sephalon ];
    license = lib.licenses.unlicense;
  };
}
