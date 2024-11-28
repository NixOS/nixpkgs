{ buildGoModule, callPackage }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-cli";
  inherit (common)
    version
    src
    ldflags
    postInstall
    vendorHash
    ;

  subPackages = "cmd/cli";

  env.CGO_ENABLED = 0;

  meta = common.meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
    mainProgram = "woodpecker";
  };
}
