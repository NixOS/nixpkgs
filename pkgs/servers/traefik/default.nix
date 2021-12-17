{ lib, fetchzip, buildGoModule, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.5.4";

  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "sha256-OMzLRgpTUIosmlAdMiNplOx/Oj28gcqamsOPJdoFkN0=";
    stripRoot = false;
  };

  vendorSha256 = "sha256-BSempfKgRCj87XM8qPNEUs+sMILVS6bWwWgf7wWQviI=";

  doCheck = false;

  subPackages = [ "cmd/traefik" ];

  nativeBuildInputs = [ go-bindata ];

  passthru.tests = { inherit (nixosTests) traefik; };

  preBuild = ''
    go generate

    CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)

    buildFlagsArray+=("-ldflags=\
      -X github.com/traefik/traefik/v2/pkg/version.Version=${version} \
      -X github.com/traefik/traefik/v2/pkg/version.Codename=$CODENAME")
  '';

  meta = with lib; {
    homepage = "https://traefik.io";
    description = "A modern reverse proxy";
    changelog = "https://github.com/traefik/traefik/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
  };
}
