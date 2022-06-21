{ lib, buildGoModule, fetchFromGitHub, mkYarnPackage, glibc }:
let
  inherit (import ./common.nix { inherit lib fetchFromGitHub; })
    meta
    version
    src
    ;

  frontend = mkYarnPackage {
    pname = "woodpecker-frontend";
    inherit version;

    src = "${src}/web";

    packageJSON = "${src}/web/package.json";
    yarnLock = "${src}/web/yarn.lock";

    buildPhase = ''
      yarn build
    '';

    distPhase = "true";
  };
in
buildGoModule {
  pname = "woodpecker-server";
  inherit version src;
  vendorSha256 = null;

  subPackages = "cmd/server";

  buildInputs = [
    glibc.static
  ];

  CGO_ENABLED = true;

  # FIXME: what about stdenv.hostPlatform.isMusl
  cflags = [
    "-I${lib.getDev glibc}/include"
  ];

  ldflags = [
    "-s"
    "-w"
    ''-extldflags "-static"''
    "-X github.com/woodpecker-ci/woodpecker/version.Version=${version}"
    "-L ${lib.getLib glibc}/lib"
  ];

  postPatch = ''
    cp -r ${frontend}/libexec/woodpecker-ci/deps/woodpecker-ci/dist web/dist
  '';

  meta = meta // {
    description = "Woodpecker Continuous Integration server";
    mainProgram = "server";
  };
}
