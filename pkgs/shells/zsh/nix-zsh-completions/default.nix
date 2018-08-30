{ stdenv, fetchFromGitHub }:

let
  version = "0.4.0";
in

stdenv.mkDerivation rec {
  name = "nix-zsh-completions-${version}";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "${version}";
    sha256 = "0m8b9xgbz2nvk1q7m0gqy83gbqa49n062gymhk9x93zhbdh8vwky";
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
