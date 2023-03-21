{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easeprobe";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "megaease";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FBraLP/wsoJiVLjAqNZettMDOd8W8l1j4t8ETyvqrcQ=";
  };

  vendorHash = "sha256-Z2JLFLVTdPGFFHnjNA1JS1lYjGimdvMLiXQyNi+91Hc=";

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
