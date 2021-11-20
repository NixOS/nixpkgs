{ lib, htop, fetchFromGitHub }:

htop.overrideAttrs (oldAttrs: rec {
  pname = "htop-vim";
  version = "unstable-2021-10-11";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = pname;
    rev = "ba6fd3891e9af60b41bd092524cc05f2469fec4b";
    sha256 = "sha256-G83+5GgEz41begDkdK8zNx48UleufFCJ9pOQ9nbtFNs=";
  };

  meta = with lib; {
    description = "An interactive process viewer for Linux, with vim-style keybindings";
    homepage = "https://github.com/KoffeinFlummi/htop-vim";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ thiagokokada ];
  };
})
