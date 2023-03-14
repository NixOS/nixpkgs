{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nix-zsh-completions";
  version = "unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-zsh-completions";
    rev = "6a1bfc024481bdba568f2ced65e02f3a359a7692";
    hash = "sha256-aXetjkl5nPuYHHyuX59ywXF+4Xg+PUCV6Y2u+g18gEk=";
  };

  strictDeps = true;
  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix
  '';

  meta = with lib; {
    homepage = "https://github.com/nix-community/nix-zsh-completions";
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt olejorgenb hedning ma27 ];
  };
}
