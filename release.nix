{ nixosSrc ? {outPath = ./.; revCount = 1234; shortRev = "abcdefg"; }
, nixpkgs ? {outPath = <nixpkgs>; revCount = 5678; shortRev = "gfedcba"; }
#, minimal ? false
}:

let

  version = builtins.readFile ./.version;
  versionSuffix = "pre${toString nixosSrc.revCount}_${nixosSrc.shortRev}-${nixpkgs.shortRev}";


  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"] }:
    { officialRelease ? false
    , system ? builtins.currentSystem
    }:

    with import <nixpkgs> {inherit system;};

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
          ensureDir $out/nix-support
          echo "file iso" $iso/iso/*.iso* >> $out/nix-support/hydra-build-products
        ''; # */


  makeSystemTarball =
    { module, maintainers ? ["viric"]}:
    { officialRelease ? false
    , system ? builtins.currentSystem
    }:

    with import <nixpkgs> {inherit system;};
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


  jobs = rec {


    tarball =
      { officialRelease ? false }:

      with import <nixpkgs> {};

      releaseTools.makeSourceTarball {
        name = "nixos-tarball";

        src = nixosSrc;

        inherit officialRelease version;
        versionSuffix = lib.optionalString (!officialRelease) versionSuffix;

        distPhase = ''
          echo -n $VERSION_SUFFIX > .version-suffix
          releaseName=nixos-$VERSION$VERSION_SUFFIX
          ensureDir "$out/tarballs"
          mkdir ../$releaseName
          cp -prd . ../$releaseName
          cd ..
          chmod -R u+w $releaseName
          tar cfvj $out/tarballs/$releaseName.tar.bz2 $releaseName
        ''; # */
      };


    channel =
      { officialRelease ? false }:

      with import <nixpkgs> {};

      releaseTools.makeSourceTarball {
        name = "nixos-channel";

        src = nixosSrc;

        inherit officialRelease version;
        versionSuffix = lib.optionalString (!officialRelease) versionSuffix;

        buildInputs = [ nixUnstable ];

        expr = builtins.readFile lib/channel-expr.nix;

        distPhase = ''
          echo -n $VERSION_SUFFIX > .version-suffix
          releaseName=nixos-$VERSION$VERSION_SUFFIX
          ensureDir "$out/tarballs"
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
      { officialRelease ? false }:

      (import "${nixosSrc}/doc/manual" {
        pkgs = import <nixpkgs> {};
        options =
          (import lib/eval-config.nix {
            modules = [
              { fileSystems = [];
                boot.loader.grub.device = "/dev/sda";
              } ];
          }).options;
        revision = toString nixosSrc.rev;
      }).manual;


    iso_minimal = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
      type = "minimal";
    };

    iso_graphical = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-graphical.nix;
      type = "graphical";
    };

    # A variant with a more recent (but possibly less stable) kernel
    # that might support more hardware.
    iso_new_kernel = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-new-kernel.nix;
      type = "new-kernel";
    };

    # A variant with efi booting support. Once cd-minimal has a newer kernel,
    # this should be enabled by default.
    iso_efi = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-efi.nix;
      type = "efi";
      maintainers = [ "shlevy" ];
    };

    # Provide a tarball that can be unpacked into an SD card, and easily
    # boot that system from uboot (like for the sheevaplug).
    # The pc variant helps preparing the expression for the system tarball
    # in a machine faster than the sheevpalug
    system_tarball_pc = makeSystemTarball {
      module = ./modules/installer/cd-dvd/system-tarball-pc.nix;
    };

    /*
    system_tarball_fuloong2f =
      assert builtins.currentSystem == "mips64-linux";
      makeSystemTarball {
        module = ./modules/installer/cd-dvd/system-tarball-fuloong2f.nix;
      } { system = "mips64-linux"; };

    system_tarball_sheevaplug =
      assert builtins.currentSystem == "armv5tel-linux";
      makeSystemTarball {
        module = ./modules/installer/cd-dvd/system-tarball-sheevaplug.nix;
      } { system = "armv5tel-linux"; };
    */


    tests = { system ? "x86_64-linux" }:
      let
        t = import ./tests { inherit system; };
      in {
        avahi = t.avahi.test;
        bittorrent = t.bittorrent.test;
        firefox = t.firefox.test;
        firewall = t.firewall.test;
        installer.grub1 = t.installer.grub1.test;
        installer.lvm = t.installer.lvm.test;
        installer.rebuildCD = t.installer.rebuildCD.test;
        installer.separateBoot = t.installer.separateBoot.test;
        installer.simple = t.installer.simple.test;
        installer.swraid = t.installer.swraid.test;
        ipv6 = t.ipv6.test;
        kde4 = t.kde4.test;
        login = t.login.test;
        misc = t.misc.test;
        mpich = t.mpich.test;
        mysql = t.mysql.test;
        mysql_replication = t.mysql_replication.test;
        nat = t.nat.test;
        nfs = t.nfs.test;
        openssh = t.openssh.test;
        proxy = t.proxy.test;
        quake3 = t.quake3.report;
        #subversion = t.subversion.report;
        tomcat = t.tomcat.test;
        trac = t.trac.test;
        xfce = t.xfce.test;
      };

  };


in jobs
