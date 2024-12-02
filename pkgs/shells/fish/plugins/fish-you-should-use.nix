{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "fish-you-should-use";
  version = "0-unstable-2022-02-13";

  src = fetchFromGitHub {
    owner = "paysonwallach";
    repo = "fish-you-should-use";
    rev = "a332823512c0b51e71516ebb8341db0528c87926";
    hash = "sha256-MmGDFTgxEFgHdX95OjH3jKsVG1hdwo6bRht+Lvvqe5Y=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish plugin that reminds you to use your aliases";
    homepage = "https://github.com/paysonwallach/fish-you-should-use";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
