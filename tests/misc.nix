# Miscellaneous small tests that don't warrant their own VM run.

{ pkgs, ... }:

{

  machine =
    { config, pkgs, ... }:
    { swapDevices = pkgs.lib.mkOverride 0
        [ { device = "/root/swapfile"; size = 128; } ];
    };

  testScript =
    ''
      subtest "nixos-version", sub {
          $machine->succeed("[ `nixos-version | wc -w` = 1 ]");
      };

      # Sanity check for uid/gid assignment.
      subtest "users-groups", sub {
          $machine->succeed("[ `id -u messagebus` = 4 ]");
          $machine->succeed("[ `id -g messagebus` = 4 ]");
          $machine->succeed("[ `getent group users` = 'users:x:100:' ]");
      };

      # Regression test for GMP aborts on QEMU.
      subtest "gmp", sub {
          $machine->succeed("expr 1 + 2");
      };

      # Test that the swap file got created.
      subtest "swapfile", sub {
          $machine->waitForUnit("root-swapfile.swap");
          $machine->succeed("ls -l /root/swapfile | grep 134217728");
      };
    '';

}
