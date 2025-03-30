# These overrides are applied to the dependencies of the Nix components.

{
  # The raw Nixpkgs, not affected by this scope
  pkgs,

  stdenv,
}:

let
  prevStdenv = stdenv;
in

let
  stdenv = if prevStdenv.isDarwin && prevStdenv.isx86_64 then darwinStdenv else prevStdenv;

  # Fix the following error with the default x86_64-darwin SDK:
  #
  #     error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
  #
  # Despite the use of the 10.13 deployment target here, the aligned
  # allocation function Clang uses with this setting actually works
  # all the way back to 10.6.
  darwinStdenv = pkgs.overrideSDK prevStdenv { darwinMinVersion = "10.13"; };
in
scope: {
  inherit stdenv;

  aws-sdk-cpp =
    (pkgs.aws-sdk-cpp.override {
      apis = [
        "s3"
        "transfer"
      ];
      customMemoryManagement = false;
    }).overrideAttrs
      {
        # only a stripped down version is built, which takes a lot less resources
        # to build, so we don't need a "big-parallel" machine.
        requiredSystemFeatures = [ ];
      };

  boehmgc = pkgs.boehmgc.override {
    enableLargeConfig = true;
  };
}
