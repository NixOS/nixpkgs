{ nixosSrc ? {outPath = ./.; rev = 1234;}
, nixpkgs ? {outPath = <nixpkgs>; rev = 5678;}
}:

let

  versionSuffix = "pre${toString nixosSrc.rev}-${toString nixpkgs.rev}";


  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"] }:
    { officialRelease ? false
    , system ? builtins.currentSystem
    }:

    with import <nixpkgs> {inherit system;};

    let

      version = builtins.readFile ./VERSION + (lib.optionalString (!officialRelease) versionSuffix);

      versionModule =
        { system.nixosVersion = version;
          isoImage.isoBaseName = "nixos-${type}";
        };

      config = (import lib/eval-config.nix {
        inherit system;
        modules = [ module versionModule ];
      }).config;

      iso = config.system.build.isoImage;

    in
      # Declare the ISO as a build product so that it shows up in Hydra.
      runCommand "nixos-iso-${version}"
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
      version = builtins.readFile ./VERSION + (lib.optionalString (!officialRelease) versionSuffix);

      versionModule = { system.nixosVersion = version; };

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

        version = builtins.readFile ./VERSION;

        src = nixosSrc;

        inherit officialRelease;

        distPhase = ''
          releaseName=nixos-$VERSION$VERSION_SUFFIX
          ensureDir "$out/tarballs"
          mkdir ../$releaseName
          cp -prd . ../$releaseName
          cd ..
          tar cfvj $out/tarballs/$releaseName.tar.bz2 $releaseName
        ''; # */
      };


    channel =
      { officialRelease ? false }:

      with import <nixpkgs> {};

      releaseTools.makeSourceTarball {
        name = "nixos-channel";

        version = builtins.readFile ./VERSION;

        src = nixosSrc;

        inherit officialRelease versionSuffix;

        buildInputs = [ nixUnstable ];

        expr =
          ''
            { system ? builtins.currentSystem }:
            { pkgs = (import nixpkgs/default.nix { inherit system; }) // { recurseForDerivations = true; }; }
          '';

        distPhase = ''
          releaseName=nixos-$VERSION$VERSION_SUFFIX
          ensureDir "$out/tarballs"
          mkdir ../$releaseName
          cp -prd . ../$releaseName/nixos
          cp -prd ${nixpkgs} ../$releaseName/nixpkgs
          echo "$expr" > ../$releaseName/default.nix
          NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --xml \* > /dev/null
          cd ..
          tar cfj $out/tarballs/$releaseName.tar.bz2 $releaseName
        ''; # */
      };


    manual =
      { officialRelease ? false }:

      (import "${nixosSrc}/doc/manual" {
        pkgs = import <nixpkgs> {};
        options =
          (import lib/eval-config.nix {
            modules = [ { fileSystems = []; } ];
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

    # A variant with experimental efi booting support. Currently requires
    # an RC kernel. Eventually this should probably be merged into cd-minimal
    iso_efi = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-efi.nix;
      type = "efi";
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


    tests =
      let
        t = import ./tests { system = "i686-linux"; };
        t_64 = import ./tests { system = "x86_64-linux"; };
      in {
        avahi = t.avahi.test;
        bittorrent = t.bittorrent.test;
        firefox = t.firefox.test;
        firewall = t.firewall.test;
        installer.lvm = t.installer.lvm.test;
        installer.separateBoot = t.installer.separateBoot.test;
        installer.simple = t.installer.simple.test;
        installer.simple_64 = t_64.installer.simple.test;
        installer.swraid = t.installer.swraid.test;
        installer.rebuildCD = t.installer.rebuildCD.test;
        ipv6 = t.ipv6.test;
        kde4 = t.kde4.test;
        login = t.login.test;
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
