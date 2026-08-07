{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

buildFishPlugin rec {
  pname = "macos";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "halostatue";
    repo = "fish-macos";
    tag = "v${version}";
    hash = "sha256-VKJp+7YzqHMNniWs4aGq0gR11mPJU4gPIEgUPhdfA30=";
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
