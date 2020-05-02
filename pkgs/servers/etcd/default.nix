{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.22";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "1rd390qfx9k20j9gh1wp1g9ygc571f2kv1dg2wvqij3kwydhymcj";
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
    maintainers = with maintainers; [ offline zowoq ];
    platforms = platforms.unix;
  };
}
