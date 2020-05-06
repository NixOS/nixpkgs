{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.20";

  # change to "go.etcd.io/etcd" for >= 3.4
  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "1iqq12kkky3cl28k7fabqqyx1i0a2wmbkq0bs8yhiwywp076k08w";
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

  passthru.tests = with nixosTests; {
    etcd = etcd;
    etcd-cluster = etcd-cluster;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
