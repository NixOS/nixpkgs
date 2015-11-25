{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nix-zsh-completions";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    rev = "0.2";
    sha256 = "0wimjdxnkw1lzhjn28zm4pgbij86ym0z17ayivpzz27g0sacimga";
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
    maintainers = [ stdenv.lib.maintainers.spwhitt ];
  };
}
