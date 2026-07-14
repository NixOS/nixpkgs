{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

buildFishPlugin rec {
  pname = "macos";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "halostatue";
    repo = "fish-macos";
    tag = "v${version}";
    hash = "sha256-yTwN2ztdU+vk+AXEfsJUN7J4KqrbLSWHgA0q5rUT5CE=";
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
