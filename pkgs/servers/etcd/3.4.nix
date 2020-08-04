{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.10";

  #vendorSha256 = null; revert to `null` for > 3.4.10

  vendorSha256 = "1fhrycl8m8ddb7mwasbyfiwrl4d9lfdk7zd3mxb7ahkipdp2c94z";
  deleteVendor = true;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "07kzgh2rm7kzprlpnay6fq8lziiyhiqyikf1qjx8gjjsdsjy180f";
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
