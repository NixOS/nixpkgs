{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  voluptuous,
}:

buildHomeAssistantComponent rec {
  owner = "martindell";
  domain = "entity_notes";
  version = "3.3.11";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-entity-notes";
    tag = "v${version}";
    hash = "sha256-J+HIa8VgfObhuOY8jn39hQH3I4DEgVn65U9w9a/vNd4=";
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
