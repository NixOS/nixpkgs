{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.5.1";

  vendorSha256 = "sha256-ad89jDLLeAJizQMmO0lPH8N9GdaBrn9NyXGCxVT3fHE=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-Ip7JAWbZBZcc8MXd+Sw05QmTs448fQXpQ5XXo6RW+Gs=";
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
    platforms = platforms.unix;
  };
}
