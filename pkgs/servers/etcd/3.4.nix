{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.28";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-M0iD05Wk3pC56kGKeIb0bfMUpy9idMKin0+DYhBo/cw=";
  };

  vendorHash = "sha256-DbDIz/cbXqYHaGqNqP+wYpuiaFiZYElRXmQwBXnCbMk=";

  buildPhase = ''
    patchShebangs .
    ./build
    ./functional/build
  '';

  doCheck = false;

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline ];
  };
}
