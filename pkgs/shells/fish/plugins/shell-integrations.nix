{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gitUpdater,
}:

buildFishPlugin rec {
  pname = "shell-integrations";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "dudeofawesome";
    repo = "fish-plugin-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-fvtimmdxFDA+MQkZODMMQTnH7ICVHtsofPSk0fl7nm0=";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Loads a number of shell integrations when available";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };
}
