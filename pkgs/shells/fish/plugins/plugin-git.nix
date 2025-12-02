{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "plugin-git";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "jhillyerd";
    repo = "plugin-git";
    rev = "refs/tags/v${version}";
    hash = "sha256-p7vvwisu3mvVOE1DcALbzuGJqWBcE1h71UjaopGdxE0=";
  };

  meta = {
    description = "Git plugin for fish (similar to oh-my-zsh git)";
    homepage = "https://github.com/jhillyerd/plugin-git";
    changelog = "https://github.com/jhillyerd/plugin-git/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      unsolvedcypher
    ];
  };
}
