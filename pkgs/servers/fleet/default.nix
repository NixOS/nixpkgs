{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "fleet-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o fleet github.com/coreos/fleet
  '';

  installPhase = ''
    ensureDir $out/bin
    mv fleet $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A distributed init system";
    homepage = http://coreos.com/using-coreos/clustering/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
