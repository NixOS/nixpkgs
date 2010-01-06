{ pkgs, nixpkgs, system, ... }:

rec {

  # Build the ISO.  This is the regular installation CD but with test
  # instrumentation.
  iso =
    (import ../lib/eval-config.nix {
      inherit nixpkgs system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-minimal.nix
          ../modules/testing/test-instrumentation.nix
          { key = "serial"; 
            boot.kernelParams = [ "console=tty1" "console=ttyS0" ];
          }
        ];
    }).config.system.build.isoImage;

  testScript =
    ''
      #createDisk("harddisk", 2 * 1024);

      my $machine = Machine->new({ hda => "harddisk", cdrom => glob("${iso}/iso/*.iso") });
      $machine->start;

      $machine->mustSucceed("echo hello");
    '';   
}
