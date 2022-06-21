{ lib, buildGoModule, fetchFromGitHub }:
let
  inherit (import ./common.nix { inherit lib fetchFromGitHub; })
    meta
    version
    src
    ;
in
buildGoModule {
  pname = "woodpecker-agent";
  inherit version src;
  vendorSha256 = null;

  subPackages = "cmd/agent";

  CGO_ENABLED = false;

  ldflags = [
    "-s"
    "-w"
    ''-extldflags "-static"''
    "-X github.com/woodpecker-ci/woodpecker/version.Version=${version}"
  ];

  meta = meta // {
    description = "Woodpecker Continuous Integration agent";
    mainProgram = "agent";
  };
}
