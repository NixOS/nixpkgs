{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gitUpdater,
  fishtape_3,
}:

buildFishPlugin rec {
  pname = "node-version";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dudeofawesome";
    repo = "fish-plugin-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-WD7Kgn2WIg4jBIvN/nFGx5Qeo2JkL2o74e4+HJKi8y8=";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "Change Node versions based on a Node Version File";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dudeofawesome ];
  };

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  checkPlugins = [ fishtape_3 ];
  checkPhase = ''
    fishtape test/*.test.fish
  '';
}
