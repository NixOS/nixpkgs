{ lib, buildGoModule, callPackage, fetchFromGitHub, fetchpatch }:
let
  common = callPackage ./common.nix { };
in
buildGoModule {
  pname = "woodpecker-cli";
  inherit (common) version src ldflags postBuild;
  vendorSha256 = null;

  patches = [
    # Fixes https://github.com/NixOS/nixpkgs/issues/184875, until a new version
    # is released.
    (fetchpatch {
      name = "display-system-ca-error-only-if-there-is-an-error.patch";
      url = "https://github.com/woodpecker-ci/woodpecker/commit/1fb800329488de74c9db7cfc5dc43fb5a4efbad8.patch";
      sha256 = "sha256-wKI/7PhbxsAD/qrl4nnkHyyQhQcvGlySysnxytGJzfU=";
    })
  ];

  subPackages = "cmd/cli";

  CGO_ENABLED = 0;

  meta = common.meta // {
    description = "Command line client for the Woodpecker Continuous Integration server";
  };
}
