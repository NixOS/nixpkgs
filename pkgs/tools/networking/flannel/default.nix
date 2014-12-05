{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "flannel-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o flannel github.com/coreos/flannel
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv flannel $out/bin/flannel
  '';

  meta = with stdenv.lib; {
    description = "Flannel is an etcd backed network fabric for containers";
    homepage = https://github.com/coreos/flannel;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
