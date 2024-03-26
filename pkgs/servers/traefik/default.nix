{ lib, fetchzip, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.10.7";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-I+jmMtqWadWfT7nk2D9im6C2BGpPLts/7cdJ3NHsIks=";
    stripRoot = false;
  };

  vendorHash = "sha256-3SyD1mC+tc8cf5MGcw891W5VbX+b7d0cIJQfwNq2NU8=";

  subPackages = [ "cmd/traefik" ];

  preBuild = ''
    GOOS= GOARCH= CGO_ENABLED=0 go generate

    CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)

    buildFlagsArray+=("-ldflags= -s -w \
      -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Version=${version} \
      -X github.com/traefik/traefik/v${lib.versions.major version}/pkg/version.Codename=$CODENAME")
  '';

  doCheck = false;

  passthru.tests = { inherit (nixosTests) traefik; };

  meta = with lib; {
    homepage = "https://traefik.io";
    description = "A modern reverse proxy";
    changelog = "https://github.com/traefik/traefik/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
    mainProgram = "traefik";
  };
}
