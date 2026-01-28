{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "fzf";
  version = "0.16.6-unstable-2021-05-12";

  src = fetchFromGitHub {
    owner = "jethrokuan";
    repo = "fzf";
    rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
    sha256 = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
  };

  meta = {
    description = "Ef-fish-ient fish keybindings for fzf";
    homepage = "https://github.com/jethrokuan/fzf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
