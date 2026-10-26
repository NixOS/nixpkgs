{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  frigidaire,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "bm1549";
  domain = "frigidaire";
  version = "1.0.0b2";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "home-assistant-frigidaire";
    tag = finalAttrs.version;
    hash = "sha256-t5NgHh96Chyz8u1djcopEfkHLIhmnEqQYoQ/GzzrbXE=";
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
})
