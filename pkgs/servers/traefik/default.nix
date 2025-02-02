{ lib, fetchzip, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "3.0.1";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-FoKmoestbPu95E4dzBdG2rB0zEYocD/16yt9Je4M3GU=";
    stripRoot = false;
  };

  vendorHash = "sha256-nEPcq4lUvs/hTobciIZAQKQ13MgKMLjYUkyYMd3EHms=";

  subPackages = [ "cmd/traefik" ];

  preBuild = ''
    GOOS= GOARCH= CGO_ENABLED=0 go generate

    CODENAME=$(grep -Po "CODENAME \?=\s\K.+$" Makefile)

    ldflags="-s"
    ldflags+=" -w"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Version=${version}"
    ldflags+=" -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Codename=$CODENAME"
  '';

  doCheck = false;

  passthru.tests = { inherit (nixosTests) traefik; };

  meta = with lib; {
    homepage = "https://traefik.io";
    description = "Modern reverse proxy";
    changelog = "https://github.com/traefik/traefik/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
    mainProgram = "traefik";
  };
}
