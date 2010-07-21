{ pkgs, nixpkgs, system, ... }:

with pkgs.lib;
with import ../lib/qemu-flags.nix;

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
            boot.loader.grub.timeout = mkOverride 0 {} 0;
            
            # The test cannot access the network, so any sources we
            # need must be included in the ISO.
            isoImage.storeContents =
              [ pkgs.glibcLocales
                pkgs.sudo
                pkgs.docbook5
              ];
          }
        ];
    }).config.system.build.isoImage;

    
  # The configuration to install.
  config = { fileSystems, testChannel }: pkgs.writeText "configuration.nix"
    ''
      { config, pkgs, modulesPath, ... }:

      { require =
          [ ./hardware.nix
            "''${modulesPath}/testing/test-instrumentation.nix"
          ];

        boot.loader.grub.version = 2;
        boot.loader.grub.device = "/dev/vda";
        boot.loader.grub.extraConfig = "serial; terminal_output.serial";
        boot.initrd.kernelModules = [ "ext3" ];
      
        fileSystems = [ ${fileSystems} ];
        swapDevices = [ { label = "swap"; } ];

        environment.systemPackages = [ ${optionalString testChannel "pkgs.rlwrap"} ];
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

    
  # Configuration of a web server that simulates the Nixpkgs channel
  # distribution server.
  webserver = 
    { config, pkgs, ... }:

    { services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.servedDirs = singleton
        { urlPath = "/releases/nixpkgs/channels/nixpkgs-unstable";
          dir = "/tmp/channel";
        };

      # Make the Nix store in this VM writable using AUFS.  This
      # should probably be moved to qemu-vm.nix.
      boot.extraModulePackages = [ config.boot.kernelPackages.aufs2 ];
      boot.initrd.availableKernelModules = [ "aufs" ];

      boot.initrd.postMountCommands =
        ''
          mkdir /mnt-store-tmpfs
          mount -t tmpfs -o "mode=755" none /mnt-store-tmpfs
          mount -t aufs -o dirs=/mnt-store-tmpfs=rw:$targetRoot/nix/store=rr none $targetRoot/nix/store
        '';

      virtualisation.pathsInNixDB = channelContents;
    };

  channelContents = [ pkgs.hello.src pkgs.rlwrap ];
  

  # The test script boots the CD, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems, and a configuration.nix fragment
  # `fileSystems'.
  testScriptFun = { createPartitions, fileSystems, testChannel }:
    ''
      createDisk("harddisk", 4 * 1024);

      my $machine = Machine->new({ hda => "harddisk", cdrom => glob("${iso}/iso/*.iso"), qemuFlags => '${qemuNICFlags 1 1}' });
      $machine->start;

      ${optionalString testChannel ''
        # Create a channel on the web server containing a few packages
        # to simulate the Nixpkgs channel.
        $webserver->start;
        $webserver->waitForJob("httpd");
        $webserver->mustSucceed("mkdir /tmp/channel");
        $webserver->mustSucceed(
            "nix-push file:///tmp/channel " .
            "http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable " .
            "file:///tmp/channel/MANIFEST ${toString channelContents} >&2");
      ''}
      
      # Make sure that we get a login prompt etc.
      $machine->mustSucceed("echo hello");
      $machine->waitForJob("tty1");
      $machine->waitForJob("rogue");
      $machine->waitForJob("nixos-manual");

      # Make sure that we don't try to download anything.
      $machine->stopJob("dhclient");
      $machine->mustSucceed("rm /etc/resolv.conf");

      ${optionalString testChannel ''
        # Allow the machine to talk to the fake nixos.org.
        $machine->mustSucceed(
            "rm /etc/hosts",
            "echo 192.168.1.1 nixos.org > /etc/hosts",
            "ifconfig eth1 up 192.168.1.2",
            "nix-pull http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST",
        );

        # Test nix-env.
        $machine->mustFail("hello");
        $machine->mustSucceed("nix-env -i hello");
        $machine->mustSucceed("hello") =~ /Hello, world/
            or die "bad `hello' output";
      ''}

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
          "${ config { inherit fileSystems testChannel; } }",
          "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->mustSucceed("nixos-install >&2");
      
      $machine->mustSucceed("cat /mnt/boot/grub/grub.cfg >&2");
      
      $machine->shutdown;

      # Now see if we can boot the installation.
      my $machine = Machine->new({ hda => "harddisk" });
      
      # Did /boot get mounted, if appropriate?
      # !!! There is currently no good way to wait for the
      # `filesystems' task to finish.
      $machine->waitForFile("/boot/grub/grub.cfg");

      # Did the swap device get activated?
      # !!! Idem.
      $machine->waitUntilSucceeds("cat /proc/swaps | grep -q /dev");
      
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

    
  makeTest = { createPartitions, fileSystems, testChannel ? false }:
    { inherit iso;
      nodes = if testChannel then { inherit webserver; } else { };
      testScript = testScriptFun {
        inherit createPartitions fileSystems testChannel;
      };
    };
    

in {

  # !!! `parted mkpart' seems to silently create overlapping partitions.


  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeTest
    { createPartitions = 
        ''
          $machine->mustSucceed(
              "parted /dev/vda mklabel msdos",
              "parted /dev/vda -- mkpart primary linux-swap 1M 1024M",
              "parted /dev/vda -- mkpart primary ext2 1024M -1s",
              "udevadm settle",
              "mkswap /dev/vda1 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/vda2",
              "mount LABEL=nixos /mnt",
          );
        '';
      fileSystems = rootFS;
      testChannel = true;
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
              "parted /dev/vda -- mkpart primary 1M 2048M", # first PV
              "parted /dev/vda -- set 1 lvm on",
              "parted /dev/vda -- mkpart primary 2048M -1s", # second PV
              "parted /dev/vda -- set 2 lvm on",
              "udevadm settle",
              "pvcreate /dev/vda1 /dev/vda2",
              "vgcreate MyVolGroup /dev/vda1 /dev/vda2",
              "lvcreate --size 1G --name swap MyVolGroup",
              "lvcreate --size 2G --name nixos MyVolGroup",
              "mkswap -f /dev/MyVolGroup/swap -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/MyVolGroup/nixos",
              "mount LABEL=nixos /mnt",
          );
        '';
      fileSystems = rootFS;
    };

  swraid = makeTest
    { createPartitions =
        ''
          $machine->mustSucceed(
              "parted /dev/vda --"
              . " mklabel msdos"
              . " mkpart primary ext2 1M 30MB" # /boot
              . " mkpart extended 30M -1s"
              . " mkpart logical 31M 1531M" # md0 (root), first device
              . " mkpart logical 1540M 3040M" # md0 (root), second device
              . " mkpart logical 3050M 3306M" # md1 (swap), first device
              . " mkpart logical 3320M 3576M", # md1 (swap), second device
              "udevadm settle",
              "ls -l /dev/vda* >&2",
              "cat /proc/partitions >&2",
              "mdadm --create --force /dev/md0 --metadata 1.2 --level=raid1 --raid-devices=2 /dev/vda5 /dev/vda6",
              "mdadm --create --force /dev/md1 --metadata 1.2 --level=raid1 --raid-devices=2 /dev/vda7 /dev/vda8",
              "mkswap -f /dev/md1 -L swap",
              "swapon -L swap",
              "mkfs.ext3 -L nixos /dev/md0",
              "mount LABEL=nixos /mnt",
              "mkfs.ext3 -L boot /dev/vda1",
              "mkdir /mnt/boot",
              "mount LABEL=boot /mnt/boot",
          );
        '';
      fileSystems = rootFS + bootFS;
    };
      
}
