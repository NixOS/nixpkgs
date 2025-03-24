{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "plugin-sudope";
  version = "0-unstable-2021-04-11";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-sudope";
    rev = "83919a692bc1194aa322f3627c859fecace5f496";
    hash = "sha256-pD4rNuqg6TG22L9m8425CO2iqcYm8JaAEXIVa0H/v/U=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish plugin to quickly put 'sudo' in your command";
    homepage = "https://github.com/oh-my-fish/plugin-sudope";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
