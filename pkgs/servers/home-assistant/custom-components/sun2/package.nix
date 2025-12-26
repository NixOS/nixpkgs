{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "pnbruckner";
  domain = "sun2";
  version = "4.0.0b4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-sun2";
    tag = version;
    hash = "sha256-Vc7qjza9i+PfKjCmIV2R4UloGKj3ldzvg4vY4tnXemQ=";
  };

  meta = rec {
    description = "Home Assistant Sun2 sensor";
    homepage = "https://github.com/pnbruckner/ha-sun2";
    changelog = "${homepage}/releases/tag/${version}";
    maintainers = with lib.maintainers; [ sephalon ];
    license = lib.licenses.unlicense;
  };
}
