{ pkgs, nixpkgs, system, ... }:

let

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
  config = { fileSystems }: pkgs.writeText "configuration.nix"
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
          [ ${fileSystems}
          ];
          
        swapDevices =
          [ { label = "swap"; } ];
      }
    '';

  rootFS =
    ''
      { mountPoint = "/";
        device = "/dev/disk/by-label/nixos";
      }
    '';
    
  bootFS =
    ''
      { mountPoint = "/boot";
        device = "/dev/disk/by-label/boot";
      }
    '';

  # The test script boots the CD, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems, and a configuration.nix fragment
  # `fileSystems'.
  testScriptFun = { createPartitions, fileSystems }:
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
      ${createPartitions}

      # Create the NixOS configuration.
      $machine->mustSucceed(
          "mkdir -p /mnt/etc/nixos",
          "nixos-hardware-scan > /mnt/etc/nixos/hardware.nix",
      );

      my $cfg = $machine->mustSucceed("cat /mnt/etc/nixos/hardware.nix");
      print STDERR "Result of the hardware scan:\n$cfg\n";

      $machine->copyFileFromHost(
          "${ config { inherit fileSystems; } }",
          "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->mustSucceed("nixos-install >&2");
      
      $machine->mustSucceed("cat /mnt/boot/grub/grub.cfg >&2");
      
      $machine->shutdown;

      # Now see if we can boot the installation.
      my $machine = Machine->new({ hda => "harddisk" });
      
      # Did /boot get mounted, if appropriate?
      #$machine->mustSucceed("initctl start filesystems");
      #$machine->mustSucceed("test -e /boot/grub/grub.cfg");
      
      $machine->mustSucceed("nix-env -i coreutils >&2");
      $machine->mustSucceed("type -tP ls") =~ /profiles/
          or die "nix-env failed";

      $machine->mustSucceed("nixos-rebuild switch >&2");

      $machine->mustSucceed("cat /boot/grub/grub.cfg >&2");
      
      $machine->shutdown;

      # And just to be sure, check that the machine still boots after
      # "nixos-rebuild switch".
      my $machine = Machine->new({ hda => "harddisk" });
      $machine->mustSucceed("echo hello");
      $machine->shutdown;
    '';

  makeTest = { createPartitions, fileSystems }:
    { inherit iso;
      testScript = testScriptFun { inherit createPartitions fileSystems; };
    };
    

in {

  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeTest
    { createPartitions = 
        ''
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
        '';
      fileSystems = rootFS;
    };
      
  # Same as the previous, but now with a separate /boot partition.
  separateBoot = makeTest
    { createPartitions =
        ''
          $machine->mustSucceed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary ext2 1M 50MB", # /boot
              "parted /dev/vda -- mkpart primary linux-swap 50MB 1024M",
              "parted /dev/vda -- mkpart primary ext2 1024M -1s", # /
              "udevadm settle",
              "mkswap /dev/vda2 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/vda3",
              "mount LABEL=nixos /mnt",
              "mkfs.ext3 -L boot /dev/vda1",
              "mkdir /mnt/boot",
              "mount LABEL=boot /mnt/boot",
          );
        '';
      fileSystems = rootFS + bootFS;
    };
  
  # Create two physical LVM partitions combined into one volume group
  # that contains the logical swap and root partitions.
  lvm = makeTest
    { createPartitions =
        ''
          $machine->mustSucceed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary ext2 1M 50MB", # /boot
              "parted /dev/vda -- mkpart primary 1024M 2048M", # first PV
              "parted /dev/vda -- set 2 lvm on",
              "parted /dev/vda -- mkpart primary 2048M -1s", # second PV
              "parted /dev/vda -- set 3 lvm on",
              "fdisk -l /dev/vda >&2",
              "udevadm settle",
              "pvcreate /dev/vda2 /dev/vda3",
              "vgcreate MyVolGroup /dev/vda2 /dev/vda3",
              "lvcreate --size 1G --name swap MyVolGroup",
              "lvcreate --size 2G --name nixos MyVolGroup",
              "mkswap -f /dev/MyVolGroup/swap -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/MyVolGroup/nixos",
              "mount LABEL=nixos /mnt",
              "mkfs.ext3 -L boot /dev/vda1",
              "mkdir /mnt/boot",
              "mount LABEL=boot /mnt/boot",
          );
        '';
      fileSystems =
        ''
          { mountPoint = "/";
            device = " /dev/MyVolGroup/nixos";
          }
        '' + bootFS;
    };
  
}
