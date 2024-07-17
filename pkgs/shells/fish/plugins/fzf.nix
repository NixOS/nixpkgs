{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "fzf";
  version = "unstable-2021-05-12";

  src = fetchFromGitHub {
    owner = "jethrokuan";
    repo = pname;
    rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
    sha256 = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
  };

  meta = with lib; {
    description = "Ef-fish-ient fish keybindings for fzf";
    homepage = "https://github.com/jethrokuan/fzf";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
