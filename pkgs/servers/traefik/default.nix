{ lib, fetchzip, buildGoModule, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.4.13";

  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "sha256-kGCzw8B7fCh6oh0ziB1eBedWEeGOBJVBvUf++TK/Lo0=";
    stripRoot = false;
  };

  vendorSha256 = "sha256-jn4Ud+MrX7no+s69LAAbDOoFg1yIQ2lmoy8r37JIVz8=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
  };
}
