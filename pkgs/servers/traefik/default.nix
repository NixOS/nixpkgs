{ lib, fetchzip, buildGoModule, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.4.6";

  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "1f2gj9axmdisp4yza5pa60x2s79vdybgsb5ddyfwkl5m89sh0r2z";
    stripRoot = false;
  };

  vendorSha256 = "1w9crp4bk5dk0ph558w9mj8cylm2z6bc81hghmv86ild524a0l9v";

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
