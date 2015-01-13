{ stdenv, lib, go_1_3, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "golint";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go_1_3 ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o lint github.com/golang/lint/golint
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv lint $out/bin/golint
  '';

  meta = with lib; {
    description = "Linter for Go source code";
    homepage = https://github.com/golang/lint;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
