{ lib, fetchzip, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.10.5";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    hash = "sha256-b6CqpVDgyZvgBInlgni1+zukZ7DMzFUV3JdXmh+A+18=";
    stripRoot = false;
  };

  vendorHash = "sha256-bQy003IqezNSZU4K9qvApvYW+W4g6RkIqr4okkN/0gI=";

  subPackages = [ "cmd/traefik" ];

  preBuild = ''
    go generate

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
