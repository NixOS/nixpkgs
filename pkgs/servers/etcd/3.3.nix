{ lib, buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.27";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-zO+gwzaTgeFHhlkY/3AvRTEA4Yltlp+NqdlDe4dLJYg=";
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

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline ];
    broken = stdenv.isDarwin; # outdated golang.org/x/sys
    knownVulnerabilities = [ "CVE-2023-32082" ];
  };
}
