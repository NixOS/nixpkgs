{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SCa60HOLs8+uxVmFs73UmUjS4j9v2XmKas+SLmM1xTI=";
  };

  vendorSha256 = "sha256-+Aq54AAZ4094xZpTEOD63mHSff3Cm0oOQneJjGTe0To=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick ];
    license = with licenses; [ mit ];
  };
}
