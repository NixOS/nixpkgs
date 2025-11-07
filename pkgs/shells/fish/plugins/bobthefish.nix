{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "bobthefish";
  version = "0-unstable-2024-09-24";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "theme-bobthefish";
    rev = "e3b4d4eafc23516e35f162686f08a42edf844e40";
    sha256 = "sha256-cXOYvdn74H4rkMWSC7G6bT4wa9d3/3vRnKed2ixRnuA=";
  };

  meta = with lib; {
    description = "Powerline-style, Git-aware fish theme optimized for awesome";
    homepage = "https://github.com/oh-my-fish/theme-bobthefish";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
