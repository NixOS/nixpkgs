{ nixpkgs ? ../nixpkgs }:

let


  makeIso =
    { module, description }:
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
            maintainers = [lib.maintainers.eelco];
          };
        }
        ''
          ensureDir $out/nix-support
          echo "file iso" ${iso}/iso/*.iso* >> $out/nix-support/hydra-build-products
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
        optionDeclarations =
          (import lib/eval-config.nix {
            inherit nixpkgs;
            modules = [ ];
          }).optionDeclarations;
      };


    iso_minimal = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
      description = "minimal";
    };
    
    iso_rescue = makeIso {
      module = ./modules/installer/cd-dvd/installation-cd-rescue.nix;
      description = "rescue";
    };
    
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
    

  };
  

in jobs
