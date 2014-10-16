{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gotags";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o gotags github.com/jstemmer/gotags
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv gotags $out/bin
  '';

  meta = with lib; {
    description = "Ctags-compatible tag generator for Go";
    homepage = https://github.com/nsf/gotags;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
