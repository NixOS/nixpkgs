{ lib, pkgs, ... }:
let
  nixpkgsFun = import ../../top-level;
in
lib.recurseIntoAttrs {
  platformEquality =
    let
      configsLocal = [
        # crossSystem is implicitly set to localSystem.
        {
          localSystem = {
            system = "x86_64-linux";
          };
        }
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = null;
        }
        # Both systems explicitly set to the same string.
        {
          localSystem = {
            system = "x86_64-linux";
          };
          crossSystem = {
            system = "x86_64-linux";
          };
        }
        # Vendor and ABI inferred from system double.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            config = "aarch64-unknown-linux-gnu";
          };
        }
      ];
      configsCross = [
        # GNU is inferred from double, but config explicitly requests musl.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            config = "aarch64-unknown-linux-musl";
          };
        }
        # Cross-compile from AArch64 to x86-64.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            system = "x86_64-unknown-linux-gnu";
          };
        }
      ];

      pkgsLocal = map nixpkgsFun configsLocal;
      pkgsCross = map nixpkgsFun configsCross;
    in
    assert lib.all (p: p.stdenv.buildPlatform == p.stdenv.hostPlatform) pkgsLocal;
    assert lib.all (p: p.stdenv.buildPlatform != p.stdenv.hostPlatform) pkgsCross;
    pkgs.emptyFile;
}
