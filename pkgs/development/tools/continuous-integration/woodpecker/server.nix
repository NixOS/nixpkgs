<<<<<<< HEAD
{ buildGoModule, callPackage, woodpecker-frontend }:
=======
{ lib, buildGoModule, callPackage, fetchFromGitHub, woodpecker-frontend }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-server";
<<<<<<< HEAD
  inherit (common) version src ldflags postInstall vendorHash;
=======
  inherit (common) version src ldflags postBuild;
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    mainProgram = "woodpecker-server";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
