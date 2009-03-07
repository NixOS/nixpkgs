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
        
        version = builtins.readFile ./VERSION;
        
        src = nixosSrc;
        
        inherit officialRelease;

        distPhase = ''
          releaseName=nixos-$VERSION
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

        version = builtins.readFile ./VERSION + (if officialRelease then "" else "pre${toString nixosSrc.rev}");

        iso = (import "${nixosSrc.path}/installer/cd-dvd/rescue-cd.nix" {
          platform = system;
          compressImage = true;
          nixpkgsPath = nixpkgs.path;
          relName = "nixos-${version}";
        }).rescueCD;

      in
        # Declare the ISO as a build product so that it shows up in Hydra.
        runCommand "nixos-iso-${version}"
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