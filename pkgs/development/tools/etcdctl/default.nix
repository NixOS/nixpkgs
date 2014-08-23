{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "etcdctl-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o etcdctl github.com/coreos/etcdctl
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv etcdctl $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A simple command line client for etcd";
    homepage = http://coreos.com/using-coreos/etcd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
