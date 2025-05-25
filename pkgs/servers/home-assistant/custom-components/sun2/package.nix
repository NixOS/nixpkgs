{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "pnbruckner";
  domain = "sun2";
  version = "3.3.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-sun2";
    tag = version;
    hash = "sha256-aR9tQw1d64RWuwc9QLhTP0z4TdaKeRfN0p7lMdWUpgw=";
  };

  meta = rec {
    description = "Home Assistant Sun2 sensor";
    homepage = "https://github.com/pnbruckner/ha-sun2";
    changelog = "${homepage}/releases/tag/${version}";
    maintainers = with lib.maintainers; [ sephalon ];
    license = lib.licenses.unlicense;
  };
}
