{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "exercism-cli-fish-wrapper";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "glennj";
    repo = "exercism-cli-fish-wrapper";
    rev = "f6627c00324b2599239e3835af39adce04e1091c";
    hash = "sha256-bS1NN6oWi5j9uPwhuMApDRZlVYwOwlIC9NcdBZ9noL8=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish wrapper for the Exercism CLI";
    homepage = "https://github.com/glennj/exercism-cli-fish-wrapper";
    license = lib.licenses.unfree; # No upstream license
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
