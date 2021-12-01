/*

This file is a test that makes sure that the `pkgs.nixos` and
`pkgs.nixosTest` functions work. It's far from a perfect test suite,
but better than not checking them at all on hydra.

To run this test:

    nixpkgs$ nix-build -A tests.nixos-functions

 */
{ pkgs, lib, stdenv, ... }:

let
  dummyVersioning = {
    revision = "test";
    versionSuffix = "test";
    label = "test";
  };
in lib.optionalAttrs stdenv.hostPlatform.isLinux (
  pkgs.recurseIntoAttrs {

    nixos-test = (pkgs.nixos {
      system.nixos = dummyVersioning;
      boot.loader.grub.enable = false;
      fileSystems."/".device = "/dev/null";
    }).toplevel;

    nixosTest-test = pkgs.nixosTest ({ lib, pkgs, ... }: {
      name = "nixosTest-test";
      machine = { pkgs, ... }: {
        system.nixos = dummyVersioning;
        environment.systemPackages = [ pkgs.hello ];
      };
      testScript = ''
        machine.succeed("hello")
      '';
    });

  }
)
