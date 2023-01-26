{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZbKkyRCzfnX8TPBeUYZk2b5M//g1cyiksUMBg0z7nlQ=";
  };

  vendorHash = "sha256-TrJtuFzreIjq7fCw/XT1jniw9Ey9k6xmXotby6A651g=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick ];
    license = with licenses; [ mit ];
  };
}
