{ buildGoModule, callPackage }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-server";
  inherit (common)
    version
    src
    ldflags
    postInstall
    vendorHash
    ;

  subPackages = "cmd/server";

  CGO_ENABLED = 1;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server";
    mainProgram = "woodpecker-server";
  };
}
