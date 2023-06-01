{ lib, fetchzip, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.10.1";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "sha256-KvbWto3erR7ylYk59sKKZwZ961aLFi8KyZhLQJitmng=";
    stripRoot = false;
  };

  vendorHash = "sha256-Wa3Pm+5Knhua18IHME8S4PIdgt94QdhU1jY5pudlwp0=";

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
  };
}
