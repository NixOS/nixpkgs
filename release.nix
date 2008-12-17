let 


  jobs = rec {


    tarball =
      { nixosSrc ? {path = ./.; rev = 1234;}
      , nixpkgs ? {path = ../nixpkgs-wc;}
      , officialRelease ? false
      }:

      with import nixpkgs.path {};

      releaseTools.makeSourceTarball {
        name = "nixos-tarball";
        src = nixosSrc;
        inherit officialRelease;

        distPhase = ''
          releaseName=nixos-$(cat $src/VERSION)$VERSION_SUFFIX
          ensureDir "$out/tarballs"
          mkdir ../$releaseName
          cp -prd . ../$releaseName
          cd ..
          tar cfvj $out/tarballs/$releaseName.tar.bz2 $releaseName
        ''; # */
      };


    manual =
      { nixosSrc ? {path = ./.; rev = 1234;}
      , nixpkgs ? {path = ../nixpkgs-wc;}
      , officialRelease ? false
      }:

      import "${nixosSrc.path}/doc/manual" {
        nixpkgsPath = nixpkgs.path;
      };


    iso = 
      { nixosSrc ? {path = ./.; rev = 1234;}
      , nixpkgs ? {path = ../nixpkgs-wc;}
      , officialRelease ? false
      , system ? "i686-linux"
      }:

      with import nixpkgs.path {inherit system;};

      let

        iso = (import "${nixosSrc.path}/installer/cd-dvd/rescue-cd.nix" {
          platform = system;
          compressImage = true;
          nixpkgsPath = nixpkgs.path;
        }).rescueCD;

      in
        # Declare the ISO as a build product so that it shows up in Hydra.
        runCommand "nixos-iso"
          { meta = {
              description = "NixOS installation CD ISO image for ${system}";
            };
          }
          ''
            ensureDir $out/nix-support
            echo "file iso" ${iso}/iso/*.iso* >> $out/nix-support/hydra-build-products
          ''; # */
      

  };
  

in jobs