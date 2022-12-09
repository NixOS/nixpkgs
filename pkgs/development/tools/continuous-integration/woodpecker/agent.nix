{ lib, buildGoModule, callPackage, fetchFromGitHub }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-agent";
  inherit (common) version src ldflags postBuild;
  vendorSha256 = null;

  subPackages = "cmd/agent";

  CGO_ENABLED = 0;

  meta = common.meta // {
    description = "Woodpecker Continuous Integration agent";
  };
}
