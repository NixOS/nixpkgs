{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nix-zsh-completions";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-zsh-completions";
    rev = "refs/tags/${version}";
    hash = "sha256-bgbMc4HqigqgdkvUe/CWbUclwxpl17ESLzCIP8Sz+F8=";
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
    maintainers = with maintainers; [ olejorgenb hedning ma27 sebtm ];
  };
}
