{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildFishPlugin {
  pname = "plugin-sudope";
  version = "0-unstable-2025-09-16";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-sudope";
    rev = "4ad91e49329811939c3a09221a95e620c3964b17";
    hash = "sha256-OsgThGY/tGF/XBQFyXTY9qYf50B01wEH93lqWEAxZPY=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fish plugin to quickly put 'sudo' in your command";
    homepage = "https://github.com/oh-my-fish/plugin-sudope";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
