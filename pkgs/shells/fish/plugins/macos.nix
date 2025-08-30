{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

buildFishPlugin rec {
  pname = "macos";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "halostatue";
    repo = "fish-macos";
    tag = "v${version}";
    hash = "sha256-gAbmpEmUvM3pFEZ6oSFM//dmu4sXu6ncMiOH75iq5A4=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MacOS functions for Fish";
    homepage = "https://github.com/halostatue/fish-macos";
    changelog = "https://github.com/halostatue/fish-macos/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
