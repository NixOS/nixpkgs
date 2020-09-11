{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.25";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "10cyy6jr2xzmla5yyn850cv323ixrk70fjpk8lxjjjvy0ffmb6hj";
  };

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    ./build
    ./functional/build
  '';

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  passthru.tests = { inherit (nixosTests) etcd etcd-cluster; };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline zowoq ];
    platforms = platforms.unix;
  };
}
