{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easeprobe";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "megaease";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y9R2OgK+slQUvUMS3E6aX8WVCQ1fSMAruGKggxYRniA=";
  };

  vendorSha256 = "sha256-ZfqBSPnIm2GHPREowHmEEPnOovYjoarxrkPeYmZBkIc=";

  subPackages = [ "cmd/easeprobe" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
    "-X github.com/megaease/easeprobe/global.Ver=${version}"
    "-X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe"
  ];

  meta = with lib; {
    description = "A simple, standalone, and lightweight tool that can do health/status checking, written in Go";
    homepage = "https://github.com/megaease/easeprobe";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
