{
  ascii-magic,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  weconnect,
}:

buildHomeAssistantComponent rec {
  owner = "mitch-dc";
  domain = "volkswagen_we-connect_id";
  version = "0.2.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "volkswagen_we_connect_id";
    rev = "refs/tags/v${version}";
    hash = "sha256-Pmx1jXWXYta/kY51Ih1YRB+QeIfklVvBKcUYU5bHbsQ=";
  };

  dependencies = [
    ascii-magic
    weconnect
  ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/mitch-dc/volkswagen_we_connect_id/releases/tag/v${version}";
    description = "Statistics from the Volkswagen ID API";
    homepage = "https://github.com/mitch-dc/volkswagen_we_connect_id";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
