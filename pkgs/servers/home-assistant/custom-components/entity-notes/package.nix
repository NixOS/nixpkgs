{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  voluptuous,
}:

buildHomeAssistantComponent rec {
  owner = "martindell";
  domain = "entity_notes";
  version = "3.3.10";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-entity-notes";
    tag = "v${version}";
    hash = "sha256-2ZwIqqF3OQ6wjfi5c3cV8NyJNcucd95Nkrs/OimHrb0=";
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
