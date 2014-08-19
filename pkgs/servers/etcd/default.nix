{ stdenv, lib, go, fetchurl, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "etcd-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o etcd github.com/coreos/etcd
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv etcd $out/bin/etcd
  '';

  meta = with stdenv.lib; {
    description = "A highly-available key value store for shared configuration and service discovery";
    homepage = http://coreos.com/using-coreos/etcd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
