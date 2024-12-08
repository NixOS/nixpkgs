{ buildGoModule, callPackage }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-agent";
  inherit (common) version src ldflags postInstall vendorHash;

  subPackages = "cmd/agent";

  CGO_ENABLED = 0;

  meta = common.meta // {
    description = "Woodpecker Continuous Integration agent";
    mainProgram = "woodpecker-agent";
  };
}
