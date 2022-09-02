{ lib, fetchzip, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.8.3";

  # Archive with static assets for webui
  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "sha256-ww5yy4W6voP5Wo1wVuCXUtmyA9CoVk1HU5UzPUoHf/E=";
    stripRoot = false;
  };

  vendorSha256 = "sha256-ogq/4gBX4+5GZomk00Yu8J3JSbkhEFOWE6Ik+HqtkWk=";

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
