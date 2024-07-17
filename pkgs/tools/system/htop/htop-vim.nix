{
  lib,
  htop,
  fetchFromGitHub,
}:

htop.overrideAttrs (oldAttrs: rec {
  pname = "htop-vim";
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = pname;
    rev = "b2b58f8f152343b70c33b79ba51a298024278621";
    hash = "sha256-ZfdBAlnjoy8g6xwrR/i2+dGldMOfLlX6DRlNqB8pkGM=";
  };

  meta = with lib; {
    inherit (oldAttrs.meta) platforms license;
    description = "An interactive process viewer for Linux, with vim-style keybindings";
    homepage = "https://github.com/KoffeinFlummi/htop-vim";
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "htop";
  };
})
