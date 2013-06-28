{ pkgs, system, ... }:

with pkgs.lib;

let
  ksExt = pkgs.writeText "ks-ext4" ''
    clearpart --all --initlabel --drives=vdb

    part /boot --recommended --label=boot --fstype=ext2 --ondisk=vdb
    part swap --recommended --label=swap --fstype=swap --ondisk=vdb
    part /nix --size=500 --label=nix --fstype=ext3 --ondisk=vdb
    part / --recommended --label=root --fstype=ext4 --ondisk=vdb
  '';

  ksBtrfs = pkgs.writeText "ks-btrfs" ''
    clearpart --all --initlabel --drives=vdb,vdc

    part swap1 --recommended --label=swap1 --fstype=swap --ondisk=vdb
    part swap2 --recommended --label=swap2 --fstype=swap --ondisk=vdc

    part btrfs.1 --grow --ondisk=vdb
    part btrfs.2 --grow --ondisk=vdc

    btrfs / --data=0 --metadata=1 --label=root btrfs.1 btrfs.2
  '';

  ksRaid = pkgs.writeText "ks-raid" ''
    clearpart --all --initlabel --drives=vdb,vdc

    part raid.01 --size=200 --ondisk=vdb
    part raid.02 --size=200 --ondisk=vdc

    part swap1 --size=500 --label=swap1 --fstype=swap --ondisk=vdb
    part swap2 --size=500 --label=swap2 --fstype=swap --ondisk=vdc

    part raid.11 --grow --ondisk=vdb
    part raid.12 --grow --ondisk=vdc

    raid /boot --level=1 --fstype=ext3 --device=md0 raid.01 raid.02
    raid / --level=1 --fstype=xfs --device=md1 raid.11 raid.12
  '';

  ksRaidLvmCrypt = pkgs.writeText "ks-lvm-crypt" ''
    clearpart --all --initlabel --drives=vdb,vdc

    part raid.1 --grow --ondisk=vdb
    part raid.2 --grow --ondisk=vdc

    raid pv.0 --level=1 --encrypted --passphrase=x --device=md0 raid.1 raid.2

    volgroup nixos pv.0

    logvol /boot --size=200 --fstype=ext3 --name=boot --vgname=nixos
    logvol swap --size=500 --fstype=swap --name=swap --vgname=nixos
    logvol / --size=1000 --grow --fstype=ext4 --name=root --vgname=nixos
  '';
in {
  machine = { config, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.pythonPackages.nixpart
      pkgs.file pkgs.btrfsProgs pkgs.xfsprogs pkgs.lvm2
    ];
    virtualisation.emptyDiskImages = [ 4096 4096 ];
  };

  testScript = ''
    startAll;
    $machine->waitForUnit("default.target");
    my $diskStart = $machine->succeed("dd if=/dev/vda bs=512 count=1");

    sub ensureSanity {
      # Check whether the filesystem in /dev/vda is still intact
      my $newDiskStart = $machine->succeed("dd if=/dev/vda bs=512 count=1");
      if ($diskStart ne $newDiskStart) {
        $machine->log("Something went wrong, the partitioner wrote " .
                      "something into the first 512 bytes of /dev/vda!");
        die;
      }
    }

    sub kickstart {
      $machine->copyFileFromHost($_[0], "/kickstart");
      $machine->succeed("nixpart -v /kickstart");
      ensureSanity;
    }

    sub ensurePartition {
      my ($name, $match) = @_;
      my $path = $name =~ /^\// ? $name : "/dev/disk/by-label/$name";
      my $out = $machine->succeed("file -Ls $path");
      my @matches = grep(/^$path: .*$match/i, $out);
      if (!@matches) {
        $machine->log("Partition on $path was expected to have a " .
                      "file system that matches $match, but instead has: $out");
        die;
      }
    }

    sub ensureNoPartition {
      $machine->succeed("test ! -e /dev/$_[0]");
    }

    subtest "ext2, ext3 and ext4 filesystems", sub {
      kickstart("${ksExt}");
      ensurePartition("boot", "ext2");
      ensurePartition("swap", "swap");
      ensurePartition("nix", "ext3");
      ensurePartition("root", "ext4");
      ensurePartition("/dev/vdb4", "boot sector");
      ensureNoPartition("vdb6");
      ensureNoPartition("vdc1");
    };

    subtest "btrfs filesystem", sub {
      kickstart("${ksBtrfs}");
      ensurePartition("swap1", "swap");
      ensurePartition("swap2", "swap");
      ensurePartition("/dev/vdb2", "btrfs");
      ensurePartition("/dev/vdc2", "btrfs");
      ensureNoPartition("vdb3");
      ensureNoPartition("vdc3");
    };

    subtest "RAID1 with XFS", sub {
      kickstart("${ksRaid}");
      ensurePartition("swap1", "swap");
      ensurePartition("swap2", "swap");
      ensurePartition("/dev/md0", "ext3");
      ensurePartition("/dev/md1", "xfs");
      ensureNoPartition("vdb4");
      ensureNoPartition("vdc4");
      ensureNoPartition("md2");
    };

    subtest "RAID1 with LUKS and LVM", sub {
      kickstart("${ksRaidLvmCrypt}");
      ensurePartition("/dev/vdb1", "data");
      ensureNoPartition("vdb2");
      ensurePartition("/dev/vdc1", "data");
      ensureNoPartition("vdc2");

      ensurePartition("/dev/md0", "luks");
      ensureNoPartition("md1");

      ensurePartition("/dev/nixos/boot", "ext3");
      ensurePartition("/dev/nixos/swap", "swap");
      ensurePartition("/dev/nixos/root", "ext4");
    };
  '';
}
