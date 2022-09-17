{ lib, htop, fetchFromGitHub }:

htop.overrideAttrs (oldAttrs: rec {
  pname = "htop-vim";
  version = "unstable-2022-05-24";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = pname;
    rev = "830ef7144940875d9d9716e33aff8651d164026e";
    sha256 = "sha256-ojStkpWvhb+W3dWyRev0VwjtCVL/I9L8FhtXcQ+ODLA=";
  };

  meta = with lib; {
    inherit (htop.meta) platforms license;
    description = "An interactive process viewer for Linux, with vim-style keybindings";
    homepage = "https://github.com/KoffeinFlummi/htop-vim";
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "htop";
  };
})
