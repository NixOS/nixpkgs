{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  smllib,
}:

buildHomeAssistantComponent rec {
  owner = "marq24";
  domain = "tibber_local";
  version = "2026.2.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-tibber-pulse-local";
    tag = version;
    sha256 = "sha256-YHvhVAGOMkPwaxdQVv1cO6H8LitoG2PChOV1b8Z/4KU=";
  };

  dependencies = [
    smllib
  ];

  meta = {
    changelog = "https://github.com/marq24/ha-tibber-pulse-local/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/marq24/ha-tibber-pulse-local";
    maintainers = with lib.maintainers; [ hensoko ];
    license = lib.licenses.asl20;
  };
}
