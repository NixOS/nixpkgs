{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gitUpdater,
  fishtape_3,
}:

buildFishPlugin rec {
  pname = "nvm";
  version = "2.2.16";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "${pname}.fish";
    rev = "refs/tags/${version}";
    hash = "sha256-GTEkCm+OtxMS3zJI5gnFvvObkrpepq1349/LcEPQRDo=";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Node.js version manager crafted just for Fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = gitUpdater { };
  };

  checkPlugins = [ fishtape_3 ];
  checkPhase = ''
    fishtape tests/*.fish
  '';
}
