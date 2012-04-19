# Miscellaneous small tests that don't warrant their own VM run.

{ pkgs, ... }:

{

  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      subtest "nixos-version", sub {
          $machine->succeed("[ `nixos-version | wc -w` = 1 ]");
      };

      # Regression test for GMP aborts on QEMU.
      subtest "gmp", sub {
          $machine->succeed("expr 1 + 2");
      };
    '';

}
