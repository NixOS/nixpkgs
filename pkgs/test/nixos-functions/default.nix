/*
  This file is a test that makes sure that the `pkgs.nixos` and
  `pkgs.testers.nixosTest` functions work. It's far from a perfect test suite,
  but better than not checking them at all on hydra.

  To run this test:

      nixpkgs$ nix-build -A tests.nixos-functions
*/
{
  pkgs,
  lib,
  stdenv,
  ...
}:

let
  dummyVersioning = {
    revision = "test";
    versionSuffix = "test";
    label = "test";
  };

  minimalSystem =
    module:
    pkgs.nixos [
      {
        system.nixos = dummyVersioning;
        boot.loader.grub.enable = false;
        fileSystems."/" = {
          device = "/dev/null";
          fsType = "none";
        };
        system.stateVersion = lib.trivial.release;
      }
      module
    ];
in
lib.optionalAttrs (stdenv.hostPlatform.isLinux) (
  lib.recurseIntoAttrs {
    nixos-test = (minimalSystem { }).toplevel;

    # Cheap attributes of the toplevel derivation, such as its name (which
    # `nix flake show` evaluates), must be accessible without checking
    # assertions, since those force large parts of the configuration and can
    # instantiate thousands of derivations. The assertions must still be
    # checked when the derivation itself is instantiated.
    nixos-toplevel-assertions-are-lazy =
      let
        toplevel =
          (minimalSystem {
            assertions = [
              {
                assertion = false;
                message = "failed assertions must not block evaluation of the system name";
              }
            ];
          }).toplevel;
      in
      assert (builtins.tryEval toplevel.name).success;
      assert lib.hasPrefix "nixos-system-" toplevel.name;
      assert !(builtins.tryEval toplevel.drvPath).success;
      pkgs.emptyFile;
  }
)
