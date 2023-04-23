{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.25";

  vendorHash = "sha256-duqOIMIXAuJjvKDM15mDdi+LZUZm0uK0MjTv2Dsl3FA=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-CReSNWoRN2cBrhVujlAsOaI1gUfws962oLIVGWnLTAQ=";
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
