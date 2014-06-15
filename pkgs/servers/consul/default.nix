{ stdenv, lib, go, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

let
  version = "0.3.0";
in

stdenv.mkDerivation {
  name = "consul-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o consul github.com/hashicorp/consul
  '';

  installPhase = ''
    ensureDir $out/bin
    cp consul $out/bin
  '';

  meta = with lib; {
    homepage    = http://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
