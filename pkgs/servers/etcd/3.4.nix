{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.19";

  vendorSha256 = "sha256-ZONIsizxRiwZWRu4y9VzZcCpyBKoa0j3h3JqoMMPGu0=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-8X7xTZrZ/AjUgrW9XgD8B7eKFfOulj8WBjXoImAtJoM=";
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
