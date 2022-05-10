{ lib, fetchzip, buildGoModule, go-bindata, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "traefik";
  version = "2.5.3";

  src = fetchzip {
    url = "https://github.com/traefik/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "sha256-Bq7wuc127aC/GO5wsgNkwvZsRbxFnZk2fzTWTygl6Sw=";
    stripRoot = false;
  };

  vendorSha256 = "sha256-NyIPT2NmJFB1wjNNteAEpTPYSYQZtEWJBOvG0YtxUGc=";

  patches = [
    (fetchpatch {
      name = "CVE-2022-23632.patch";
      url = "https://github.com/traefik/traefik/commit/0c83ee736ca4aa93bba2d4cce4c00fd247785915.patch";
      sha256 = "0sjd9mvkilnihs5y43gh4lijxkkrf4l9kx8jf89wzs1dy5jm6fl8";
    })
  ];

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
