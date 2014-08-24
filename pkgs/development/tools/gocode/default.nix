{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gocode";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o gocode github.com/nsf/gocode
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv gocode $out/bin
  '';

  meta = with lib; {
    description = "An autocompletion daemon for the Go programming language";
    homepage = https://github.com/nsf/gocode;
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
