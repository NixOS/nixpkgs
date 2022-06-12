{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nix-zsh-completions";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = version;
    sha256 = "1n9whlys95k4wc57cnz3n07p7zpkv796qkmn68a50ygkx6h3afqf";
  };

  strictDeps = true;
  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix
  '';

  meta = with lib; {
    homepage = "https://github.com/spwhitt/nix-zsh-completions";
    description = "ZSH completions for Nix, NixOS, and NixOps";
    priority = 6; # prevent collisions with nix 2.4's built-in completions
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt olejorgenb hedning ma27 ];
  };
}
