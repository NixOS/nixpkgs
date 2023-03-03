{ lib, buildGoModule, callPackage, fetchFromGitHub, woodpecker-frontend }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-server";
  inherit (common) version src ldflags postBuild;
  vendorSha256 = null;

  postPatch = ''
    cp -r ${woodpecker-frontend} web/dist
  '';

  subPackages = "cmd/server";

  CGO_ENABLED = 1;

  passthru = {
    inherit woodpecker-frontend;

    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server";
  };
}
