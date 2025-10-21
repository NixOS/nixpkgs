{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:

anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "fsrs-helper";
  version = "24.06.3";
  src = fetchFromGitHub {
    owner = "open-spaced-repetition";
    repo = "fsrs4anki-helper";
    tag = finalAttrs.version;
    hash = "sha256-QoCk+Ppao9oYCJvRleKPmBUivdx9O7oN+HfKbu79CBQ=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Anki add-on that supports Postpone & Advance & Load Balance & Easy Days & Disperse Siblings & Flatten";
    homepage = "https://github.com/open-spaced-repetition/fsrs4anki-helper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hey2022 ];
  };
})
