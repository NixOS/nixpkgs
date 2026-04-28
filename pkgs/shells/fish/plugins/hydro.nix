{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildFishPlugin {
  pname = "hydro";
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "hydro";
    rev = "24bb2375e3cb29c71ab790c8cfe98b9069de80c3";
    hash = "sha256-8ixve1ws80q5jNdKoooL25Lk7qopVitCMVTucW490fU=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Ultra-pure, lag-free prompt with async Git status";
    homepage = "https://github.com/jorgebucaran/hydro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ higherorderlogic ];
  };
}
