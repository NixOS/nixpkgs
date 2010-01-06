{ pkgs, nixpkgs, system, ... }:

rec {

  # Build the ISO.  This is the regular installation CD but with test
  # instrumentation.
  iso =
    (import ../lib/eval-config.nix {
      inherit nixpkgs system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-graphical.nix
          ../modules/testing/test-instrumentation.nix
          { key = "serial"; 
            boot.loader.grub.timeout = pkgs.lib.mkOverride 0 {} 0;
            
            # The test cannot access the network, so any sources we
            # need must be included in the ISO.
            isoImage.storeContents =
              [ pkgs.hello.src
                pkgs.glibcLocales
                pkgs.sudo
                pkgs.docbook5
              ];
          }
        ];
    }).config.system.build.isoImage;

  # The configuration to install.
  config = pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, modulesPath, ... }:

      { require =
          [ ./hardware.nix
            "''${modulesPath}/testing/test-instrumentation.nix"
          ];

        boot.loader.grub.version = 2;
        boot.loader.grub.device = "/dev/vda";
        boot.initrd.kernelModules = [ "ext3" ];
      
        fileSystems =
          [ { mountPoint = "/";
              device = "/dev/disk/by-label/nixos";
            }
          ];
          
        swapDevices =
          [ { label = "swap"; } ];
      }
    '';

  # The test script boots the CD, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.
  testScript =
    ''
      createDisk("harddisk", 4 * 1024);

      my $machine = Machine->new({ hda => "harddisk", cdrom => glob("${iso}/iso/*.iso") });

      $machine->mustSucceed("echo hello");

      # Make sure that we get a login prompt etc.
      $machine->waitForJob("tty1");
      $machine->waitForJob("rogue");
      $machine->waitForJob("nixos-manual");

      # Make sure that we don't try to download anything.
      $machine->stopJob("dhclient");
      $machine->mustSucceed("rm /etc/resolv.conf");

      # Test nix-env.
      $machine->mustFail("hello");
      $machine->mustSucceed("nix-env -i hello");
      $machine->mustSucceed("hello") =~ /Hello, world/
          or die "bad `hello' output";

      # Partition the disk.
      $machine->mustSucceed(
          "parted /dev/vda mklabel msdos",
          "parted /dev/vda -- mkpart primary linux-swap 1M 1024M",
          "parted /dev/vda -- mkpart primary ext2 1024M -1s",
          # It can take udev a moment to create /dev/vda*.
          "udevadm settle",
          "mkswap /dev/vda1 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda2",
          "mount LABEL=nixos /mnt",
      );

      # Create the NixOS configuration.
      $machine->mustSucceed(
          "mkdir -p /mnt/etc/nixos",
          "nixos-hardware-scan > /mnt/etc/nixos/hardware.nix",
      );

      my $cfg = $machine->mustSucceed("cat /mnt/etc/nixos/hardware.nix");
      print STDERR "Result of the hardware scan:\n$cfg\n";

      $machine->copyFileFromHost("${config}", "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->mustSucceed("nixos-install >&2");
      
      $machine->shutdown;

      # Now see if we can boot the installation.
      my $machine = Machine->new({ hda => "harddisk" });
      
      $machine->mustSucceed("echo hello");

      $machine->mustSucceed("nix-env -i coreutils");
      $machine->mustSucceed("type -tP ls") =~ /profiles/
          or die "nix-env failed";

      #$machine->mustSucceed("nixos-rebuild switch >&2");

      $machine->shutdown;
    '';

}
