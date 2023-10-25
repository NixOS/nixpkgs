{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "plugin-git";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "jhillyerd";
    repo = "plugin-git";
    rev = "v0.1";
    sha256 = "sha256-MfrRQdcj7UtIUgtqKjt4lqFLpA6YZgKjE03VaaypNzE";
  };

  meta = with lib; {
    description = "Git plugin for fish (similar to oh-my-zsh git)";
    homepage = "https://github.com/jhillyerd/plugin-git";
    license = licenses.mit;
    maintainers = with maintainers; [ unsolvedcypher ];
  };
}
