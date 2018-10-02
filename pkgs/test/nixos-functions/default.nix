{ pkgs, lib, stdenv, ... }:

lib.optionalAttrs stdenv.hostPlatform.isLinux (
  pkgs.recurseIntoAttrs {

    nixos-test = (pkgs.nixos {
      boot.loader.grub.enable = false;
      fileSystems."/".device = "/dev/null";
    }).toplevel;

    nixosTest-test = let
      # extend pkgs with an extra overlay to make sure pkgs is passed along properly to machines.
      altPkgs = pkgs.extend (self: super: {
        # To test pkgs in machine
        hello_s9e8ghsi = self.hello;
        # To test lib in test
        lib = super.lib // { testSubject_dohra8w = "nixosTest"; };
        # To test pkgs in test
        dash-test_ny3dseg = "-test";
       });
    in altPkgs.nixosTest ({ lib, pkgs, ... }: {
      name = "${lib.testSubject_dohra8w}${pkgs.dash-test_ny3dseg}"; # These would fail if it's the wrong pkgs or lib
      machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello_s9e8ghsi ];
      };
      testScript = ''
        $machine->succeed("hello");
      '';
    });

  }
)
