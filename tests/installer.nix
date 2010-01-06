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
            boot.loader.grub.timeout = pkgs.lib.mkOverride 0 {} 0; 
          }
        ];
    }).config.system.build.isoImage;

  testScript =
    ''
      createDisk("harddisk", 4 * 1024);

      my $machine = Machine->new({ hda => "harddisk", cdrom => glob("${iso}/iso/*.iso") });

      $machine->mustSucceed("echo hello");

      # Make sure that we get a login prompt etc.
      $machine->waitForJob("tty1");
      $machine->waitForJob("rogue");
      $machine->waitForJob("nixos-manual");

      # Partition the disk.
      $machine->mustSucceed(
          "parted /dev/vda mklabel msdos",
          "parted /dev/vda mkpart primary linux-swap 0 1G",
          "parted /dev/vda mkpart primary ext2 1G 3G",
          # It can take udev a moment to create /dev/vda*.
          "udevadm settle",
          "mkswap /dev/vda1 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda2",
          "mount LABEL=nixos /mnt",
      );

      $machine->shutdown;
    '';   
}
