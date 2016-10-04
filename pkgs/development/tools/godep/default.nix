{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "73";
  name = "godep-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o godep github.com/tools/godep
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv godep $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Dependency tool for go";
    homepage = https://github.com/tools/godep;
    license = licenses.bsd3;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
