{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "exercism-cli-fish-wrapper";
  version = "0-unstable-2026-04-06";

  src = fetchFromGitHub {
    owner = "glennj";
    repo = "exercism-cli-fish-wrapper";
    rev = "948357dbc5ed00054e9ec6aae48084ce56efa76e";
    hash = "sha256-bbOZmSz6UWSNk0R5TYcuJFNZq0JQlGGRBO8bUabN+zQ=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish wrapper for the Exercism CLI";
    homepage = "https://github.com/glennj/exercism-cli-fish-wrapper";
    license = lib.licenses.unfree; # No upstream license
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
