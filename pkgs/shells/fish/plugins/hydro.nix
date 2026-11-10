{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildFishPlugin {
  pname = "hydro";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "hydro";
    rev = "f130b55ee3eaf099eccf588e2a62e5447068d120";
    hash = "sha256-Dfq974KpD1mtQKznIlkXfZfDnSF/4MfLTA18Ak0LADE=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Ultra-pure, lag-free prompt with async Git status";
    homepage = "https://github.com/jorgebucaran/hydro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ higherorderlogic ];
  };
}
