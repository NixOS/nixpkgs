{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "plugin-git";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jhillyerd";
    repo = "plugin-git";
    rev = "refs/tags/v${version}";
    hash = "sha256-DQLRat7uGoK57g/1x9Y514gtjvDdf9j4Iqnwif8QWVU=";
  };

  meta = with lib; {
    description = "Git plugin for fish (similar to oh-my-zsh git)";
    homepage = "https://github.com/jhillyerd/plugin-git";
    changelog = "https://github.com/jhillyerd/plugin-git/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      GaetanLepage
      unsolvedcypher
    ];
  };
}
