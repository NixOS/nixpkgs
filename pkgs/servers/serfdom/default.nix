{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.3";
  name = "serfdom-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o serf github.com/hashicorp/serf
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv serf $out/bin/serf
  '';

  meta = with stdenv.lib; {
    description = "A service discovery and orchestration tool that is decentralized, highly available, and fault tolerant";
    homepage = http://www.serfdom.io/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ msackman cstrahan ];
    platforms = platforms.unix;
  };
}
