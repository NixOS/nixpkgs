{ lib, buildGoModule, fetchFromGitHub, mkYarnPackage }:
let
  inherit (import ./common.nix { inherit lib fetchFromGitHub; })
    meta
    version
    src
    ;
in
buildGoModule {
  pname = "woodpecker-cli";
  inherit version src;
  vendorSha256 = null;

  subPackages = "cmd/cli";

  CGO_ENABLED = false;

  ldflags = [
    "-s"
    "-w"
    ''-extldflags "-static"''
    "-X github.com/woodpecker-ci/woodpecker/version.Version=${version}"
  ];

  meta = meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
    mainProgram = "cli";
  };
}
