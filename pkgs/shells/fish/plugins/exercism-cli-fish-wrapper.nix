{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "exercism-cli-fish-wrapper";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "glennj";
    repo = "exercism-cli-fish-wrapper";
    rev = "6b6ac90236308c4cac807225f36fac9283974052";
    hash = "sha256-zfES9Q3NG3UkUekkZ3s/DkPgPsmbfjV4q2LSQFuZFVY=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish wrapper for the Exercism CLI";
    homepage = "https://github.com/glennj/exercism-cli-fish-wrapper";
    license = lib.licenses.unfree; # No upstream license
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
