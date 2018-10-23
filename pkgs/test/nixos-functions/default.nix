{ pkgs, lib, stdenv, ... }:

lib.optionalAttrs stdenv.hostPlatform.isLinux (
  pkgs.recurseIntoAttrs {

    nixos-test = (pkgs.nixos {
      boot.loader.grub.enable = false;
      fileSystems."/".device = "/dev/null";
    }).toplevel;

    nixosTest-test = pkgs.nixosTest ({ lib, pkgs, ... }: {
      name = "nixosTest-test";
      machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello ];
      };
      testScript = ''
        $machine->succeed("hello");
      '';
    });

  }
)
