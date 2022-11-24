{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.22";

  vendorSha256 = "sha256-P3EQTraMdZ2fAHDue5cKAxyHbh6nNeFV9ykT0rH7KPs=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-LIhAvW/oIlPp6U4VVUvUlmOHCduIbzYnrKc4PyfcXQQ=";
  };

  buildPhase = ''
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
    maintainers = with maintainers; [ offline zowoq ];
  };
}
