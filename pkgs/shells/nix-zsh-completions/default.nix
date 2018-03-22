{ stdenv, fetchFromGitHub }:

let
  version = "0.3.8";
in

stdenv.mkDerivation rec {
  name = "nix-zsh-completions-${version}";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "${version}";
    sha256 = "05ynd38br2kn657g7l01jg1q8ja9xwrdyb95w02gh7j9cww2k06w";
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
