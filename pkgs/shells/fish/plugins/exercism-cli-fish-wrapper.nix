{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "exercism-cli-fish-wrapper";
  version = "0-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "glennj";
    repo = "exercism-cli-fish-wrapper";
    rev = "2b154d6363e16b60a3132ef93d5e1a2311209fa5";
    hash = "sha256-k0escPVR+5FqnxYzZPSsY7y927GhtWAEEOdURqN8aSk=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish wrapper for the Exercism CLI";
    homepage = "https://github.com/glennj/exercism-cli-fish-wrapper";
    license = lib.licenses.unfree; # No upstream license
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
