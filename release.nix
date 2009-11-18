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
      
      iso = (import lib/eval-config.nix {
        inherit system nixpkgs;
        modules = [ module versionModule ];
      }).config.system.build.isoImage;

    in
      # Declare the ISO as a build product so that it shows up in Hydra.
      runCommand "nixos-iso-${version}"
        { meta = {
            description = "NixOS installation CD (${description}) - ISO image for ${system}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit iso;
        }
        ''
          ensureDir $out/nix-support
          echo "file iso" $iso/iso/*.iso* >> $out/nix-support/hydra-build-products
        ''; # */


  jobs = rec {


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

    iso_minimal_fresh_kernel = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-minimal-fresh-kernel.nix;
      description = "minimal with 2.6.31-zen-branch";
      maintainers = ["raskin"];
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


    tests.subversion =
      { services ? ../services }:

      (import ./tests/subversion.nix {
        inherit nixpkgs services;
        system = "i686-linux";
      }).report;
    
    tests.kde4 =
      { services ? ../services }:

      (import ./tests/kde4.nix {
        inherit nixpkgs services;
        system = "i686-linux";
      }).test;

    tests.quake3 =
      { services ? ../services }:

      (import ./tests/quake3.nix {
        inherit nixpkgs services;
        system = "i686-linux";
      }).test;

  };
  

in jobs
