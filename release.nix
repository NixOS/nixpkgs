{ nixpkgs ? ../nixpkgs }:

let


  makeIso =
    { module, description, maintainers ? ["eelco"]}:
    { nixosSrc ? {outPath = ./.; rev = 1234;}
    , officialRelease ? false
    , system ? "i686-linux"
    }:

    with import nixpkgs {inherit system;};

    let

      version = builtins.readFile ./VERSION + (if officialRelease then "" else "pre${toString nixosSrc.rev}");

      versionModule = { system.nixosVersion = version; };

      config = (import lib/eval-config.nix {
        inherit system nixpkgs;
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


  jobs = rec {

    inherit makeIso; # used by tests/test-nixos-install-from-cd/


    tarball =
      { nixosSrc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false
      }:

      with import nixpkgs {};

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


    manual =
      { nixosSrc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false
      }:

      import "${nixosSrc}/doc/manual" {
        pkgs = import nixpkgs {};
        options =
          (import lib/eval-config.nix {
            inherit nixpkgs;
            modules = [ ];
          }).options;
        revision = with nixosSrc;
          if rev == 1234 then "HEAD" else toString rev;
      };


    iso_minimal = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
      description = "minimal";
    };

    /*    
    iso_rescue = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-rescue.nix;
      description = "rescue";
    };
    */
    
    iso_graphical = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-graphical.nix;
      description = "graphical";
    };

    # Hacky: doesn't depend on configuration. Yet configuration is evaluated (TODO)
    minimal_install_archive = {system ? "i686-linux"}: (iso_minimal {inherit system;})
      .config.system.build.minimalInstallArchive;

    # the archive installer can't be tested without chroot which requires being root
    # options: run in kvm or uml ?
    # TODO

    tests = 
      { services ? ../services }:
      let
        t = import ./tests { 
          inherit nixpkgs services;
          system = "i686-linux";
        };
      in {
        firefox = t.firefox.test;
        installer.lvm = t.installer.lvm.test;
        installer.separateBoot = t.installer.separateBoot.test;
        installer.simple = t.installer.simple.test;
        kde4 = t.kde4.test;
        quake3 = t.quake3.test;
        subversion = t.subversion.report;
        trac = t.trac.test;
      };

  };
  

in jobs
