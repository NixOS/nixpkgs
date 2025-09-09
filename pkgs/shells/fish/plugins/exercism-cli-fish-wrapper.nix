{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "exercism-cli-fish-wrapper";
  version = "0-unstable-2025-09-04";

  src = fetchFromGitHub {
    owner = "glennj";
    repo = "exercism-cli-fish-wrapper";
    rev = "446420f62144aa6b1cbdd64d0429ba8bd4123dfc";
    hash = "sha256-HTRC47BMQaVkxXr2f81enL2Tr9ZoFN3X5RZdmAiGXtU=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish wrapper for the Exercism CLI";
    homepage = "https://github.com/glennj/exercism-cli-fish-wrapper";
    license = lib.licenses.unfree; # No upstream license
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
