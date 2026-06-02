{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  voluptuous,
}:

buildHomeAssistantComponent rec {
  owner = "martindell";
  domain = "entity_notes";
  version = "3.3.4";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-entity-notes";
    tag = "v${version}";
    hash = "sha256-5JKZ/KC2sSDQQeg3taLyuZdF6QJHdc7pJ1jaFD9S3kc=";
  };

  dependencies = [
    voluptuous
  ];

  meta = {
    description = "Home Assistant custom component for adding notes to entities";
    homepage = "https://github.com/martindell/ha-entity-notes";
    changelog = "https://github.com/martindell/ha-entity-notes/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
