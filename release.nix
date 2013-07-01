{ nixosSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdefg"; }
, nixpkgs ? { outPath = <nixpkgs>; revCount = 5678; shortRev = "gfedcba"; }
, officialRelease ? false
}:

let

  version = builtins.readFile ./.version;
  versionSuffix = "pre${toString nixosSrc.revCount}_${nixosSrc.shortRev}-${nixpkgs.shortRev}";

  systems = [ "x86_64-linux" "i686-linux" ];

  pkgs = import <nixpkgs> { system = "x86_64-linux"; };


  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"], system }:

    with import <nixpkgs> { inherit system; };

    let

      versionModule =
        { system.nixosVersionSuffix = lib.optionalString (!officialRelease) versionSuffix;
          isoImage.isoBaseName = "nixos-${type}";
        };

      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ module versionModule ];
      }).config;

      iso = config.system.build.isoImage;

    in
      # Declare the ISO as a build product so that it shows up in Hydra.
      runCommand "nixos-iso-${config.system.nixosVersion}"
        { meta = {
            description = "NixOS installation CD (${description}) - ISO image for ${system}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit iso;
          passthru = { inherit config; };
        }
        ''
          mkdir -p $out/nix-support
          echo "file iso" $iso/iso/*.iso* >> $out/nix-support/hydra-build-products
        ''; # */


  makeSystemTarball =
    { module, maintainers ? ["viric"], system }:

    with import <nixpkgs> { inherit system; };

    let
      versionModule = { system.nixosVersionSuffix = lib.optionalString (!officialRelease) versionSuffix; };

      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ module versionModule ];
      }).config;

      tarball = config.system.build.tarball;
    in
      tarball //
        { meta = {
            description = "NixOS system tarball for ${system} - ${stdenv.platform.name}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit config;
        };


in {

  tarball =
    pkgs.releaseTools.makeSourceTarball {
      name = "nixos-tarball";

      src = nixosSrc;

      inherit officialRelease version;
      versionSuffix = pkgs.lib.optionalString (!officialRelease) versionSuffix;

      distPhase = ''
        echo -n $VERSION_SUFFIX > .version-suffix
        releaseName=nixos-$VERSION$VERSION_SUFFIX
        mkdir -p $out/tarballs
        mkdir ../$releaseName
        cp -prd . ../$releaseName
        cd ..
        chmod -R u+w $releaseName
        tar cfvj $out/tarballs/$releaseName.tar.bz2 $releaseName
      ''; # */
    };


  channel =
    pkgs.releaseTools.makeSourceTarball {
      name = "nixos-channel";

      src = nixosSrc;

      inherit officialRelease version;
      versionSuffix = pkgs.lib.optionalString (!officialRelease) versionSuffix;

      buildInputs = [ pkgs.nixUnstable ];

      expr = builtins.readFile lib/channel-expr.nix;

      distPhase = ''
        echo -n $VERSION_SUFFIX > .version-suffix
        releaseName=nixos-$VERSION$VERSION_SUFFIX
        mkdir -p $out/tarballs
        mkdir ../$releaseName
        cp -prd . ../$releaseName/nixos
        cp -prd ${nixpkgs} ../$releaseName/nixpkgs
        echo "$expr" > ../$releaseName/default.nix
        NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --xml \* > /dev/null
        cd ..
        chmod -R u+w $releaseName
        tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
      ''; # */
    };


  manual =
    (import "${nixosSrc}/doc/manual" {
      inherit pkgs;
      options =
        (import lib/eval-config.nix {
          modules = [
            { fileSystems = [];
              boot.loader.grub.device = "/dev/sda";
            } ];
        }).options;
      revision = toString (nixosSrc.rev or nixosSrc.shortRev);
    }).manual;


  iso_minimal = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_minimal_new_kernel = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });

  iso_graphical = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical.nix;
    type = "graphical";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_new_kernel = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-new-kernel.nix;
    type = "new-kernel";
    inherit system;
  });

  # A variant with efi booting support. Once cd-minimal has a newer kernel,
  # this should be enabled by default.
  iso_efi = pkgs.lib.genAttrs systems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-efi.nix;
    type = "efi";
    maintainers = [ "shlevy" ];
    inherit system;
  });


  # A bootable VirtualBox image.  FIXME: generate a OVF appliance?
  vdi.x86_64-linux =
    with import <nixpkgs> { system = "x86_64-linux"; };

    let

      config = (import lib/eval-config.nix {
        inherit system;
        modules =
          [ ./modules/virtualisation/virtualbox-image.nix
            ./modules/installer/cd-dvd/channel.nix
            ./modules/profiles/demo.nix
          ];
      }).config;

    in
      # Declare the VDI as a build product so that it shows up in Hydra.
      runCommand "nixos-vdi-${config.system.nixosVersion}"
        { meta = {
            description = "NixOS VirtualBox disk image (64-bit)";
            maintainers = lib.maintainers.eelco;
          };
          vdi = config.system.build.virtualBoxImage;
        }
        ''
          mkdir -p $out/nix-support
          fn=$out/nixos-${config.system.nixosVersion}.vdi.xz
          xz < $vdi/*.vdi > $fn
          echo "file vdi $fn" >> $out/nix-support/hydra-build-products
        ''; # */


  # Provide a tarball that can be unpacked into an SD card, and easily
  # boot that system from uboot (like for the sheevaplug).
  # The pc variant helps preparing the expression for the system tarball
  # in a machine faster than the sheevpalug
  system_tarball_pc = pkgs.lib.genAttrs systems (system: makeSystemTarball {
    module = ./modules/installer/cd-dvd/system-tarball-pc.nix;
    inherit system;
  });

  /*
  system_tarball_fuloong2f =
    assert builtins.currentSystem == "mips64-linux";
    makeSystemTarball {
      module = ./modules/installer/cd-dvd/system-tarball-fuloong2f.nix;
      system = "mips64-linux";
    };

  system_tarball_sheevaplug =
    assert builtins.currentSystem == "armv5tel-linux";
    makeSystemTarball {
      module = ./modules/installer/cd-dvd/system-tarball-sheevaplug.nix;
      system = "armv5tel-linux";
    };
  */


  tests =
    let
      runTest = f: pkgs.lib.genAttrs systems (system:
        f (import ./tests { inherit system; })
      );
    in {
      avahi = runTest (t: t.avahi.test);
      bittorrent = runTest (t: t.bittorrent.test);
      firefox = runTest (t: t.firefox.test);
      firewall = runTest (t: t.firewall.test);
      installer.grub1 = runTest (t: t.installer.grub1.test);
      installer.lvm = runTest (t: t.installer.lvm.test);
      installer.rebuildCD = runTest (t: t.installer.rebuildCD.test);
      installer.separateBoot = runTest (t: t.installer.separateBoot.test);
      installer.simple = runTest (t: t.installer.simple.test);
      installer.swraid = runTest (t: t.installer.swraid.test);
      ipv6 = runTest (t: t.ipv6.test);
      kde4 = runTest (t: t.kde4.test);
      login = runTest (t: t.login.test);
      misc = runTest (t: t.misc.test);
      mpich = runTest (t: t.mpich.test);
      mysql = runTest (t: t.mysql.test);
      mysql_replication = runTest (t: t.mysql_replication.test);
      nat = runTest (t: t.nat.test);
      nfs = runTest (t: t.nfs.test);
      openssh = runTest (t: t.openssh.test);
      partition = runTest (t: t.partition.test);
      proxy = runTest (t: t.proxy.test);
      quake3 = runTest (t: t.quake3.report);
      #subversion = runTest (t: t.subversion.report);
      tomcat = runTest (t: t.tomcat.test);
      trac = runTest (t: t.trac.test);
      xfce = runTest (t: t.xfce.test);
    };

}
