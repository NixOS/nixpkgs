{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nix-zsh-completions";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "0.3";
    sha256 = "1vwkd4nppjrvy6xb0vx4z73awrhaah1433dp6h4ghi3cdrrjn7ri";
  };

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions
    cp _* $out/share/zsh/site-functions
  '';

  meta = {
    homepage = "http://github.com/spwhitt/nix-zsh-completions";
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.spwhitt stdenv.lib.maintainers.olejorgenb ];
  };
}
