{ lib, buildGoModule, fetchFromGitHub, etcd_3_4, testVersion }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.18";

  vendorSha256 = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-/bXcW5g8mNFEjvfg+1loLFi8+IaWdcTE/lUPsHzEaIo=";
  };

  buildPhase = ''
    patchShebangs .
    ./build
    ./functional/build
  '';

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  passthru.tests.version = testVersion { package = etcd_3_4; };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline zowoq ];
    platforms = platforms.unix;
  };
}
