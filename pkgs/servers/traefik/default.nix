{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "sha256-uTE0Z7lgxKNq1wQSMUSp9dMfxV+aIm7cwYSkZBUdnug=";
  };

  vendorSha256 = "sha256-WlLntYrXs1kOu26yNeZI1xpb6FsHPiA/bNzaxCZTG4Y=";

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
