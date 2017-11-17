{ stdenv, fetchFromGitHub }:

let
  version = "0.3.3";
in

stdenv.mkDerivation rec {
  name = "nix-zsh-completions-${version}";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "${version}";
    sha256 = "0gvqm6grz3s0llz20sa18n5d2anmsrk892lcv7blv8rai151whpw";
  };

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions
    cp _* $out/share/zsh/site-functions
  '';

  meta = {
    homepage = https://github.com/spwhitt/nix-zsh-completions;
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.spwhitt stdenv.lib.maintainers.olejorgenb stdenv.lib.maintainers.hedning ];
  };
}
