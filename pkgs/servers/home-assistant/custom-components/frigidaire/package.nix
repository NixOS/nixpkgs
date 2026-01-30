{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  frigidaire,
}:
buildHomeAssistantComponent rec {
  owner = "bm1549";
  domain = "frigidaire";
  version = "0.1.6";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-frigidaire";
    tag = version;
    hash = "sha256-KAg/DvDtUKA8GdapXlONC5zs8LLFdtZJZDeGrXNdcLQ=";
  };

  dependencies = [ frigidaire ];

  # NOTE: The manifest.json specifies an exact version requirement for the
  # frigidaire dependency
  ignoreVersionRequirement = [ "frigidaire" ];

  meta = {
    description = "Custom component for the Frigidaire integration";
    homepage = "https://github.com/bm1549/home-assistant-frigidaire";
    maintainers = with lib.maintainers; [ nullcube ];
    license = lib.licenses.mit;
  };
}
