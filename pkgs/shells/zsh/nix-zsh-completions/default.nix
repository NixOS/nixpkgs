{ stdenv, fetchFromGitHub }:

let
  version = "0.4.2";
in

stdenv.mkDerivation rec {
  name = "nix-zsh-completions-${version}";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "${version}";
    sha256 = "1pfyn8kd9fc9fyy77imzg6xj00nzddkjagwjs2594db8ynp6cfil";
  };

  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/spwhitt/nix-zsh-completions;
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt olejorgenb hedning ma27 ];
  };
}
