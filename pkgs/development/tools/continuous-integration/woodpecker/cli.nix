<<<<<<< HEAD
{ buildGoModule, callPackage }:
=======
{ lib, buildGoModule, callPackage, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-cli";
<<<<<<< HEAD
  inherit (common) version src ldflags postInstall vendorHash;
=======
  inherit (common) version src ldflags postBuild;
  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = "cmd/cli";

  CGO_ENABLED = 0;

  meta = common.meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
<<<<<<< HEAD
    mainProgram = "woodpecker-cli";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
