{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

buildFishPlugin rec {
  pname = "macos";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "halostatue";
    repo = "fish-macos";
    tag = "v${version}";
    hash = "sha256-E5HfcGEP5YnUXY50eSPPtLxXL9N7nDInlAw91dNehhc=";
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
