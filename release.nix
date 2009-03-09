{ nixpkgs ? ../nixpkgs-wc }:

let 


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
          releaseName=nixos-$VERSION
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
        nixpkgsPath = nixpkgs.outPath;
      };


    iso = 
      { nixosSrc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false
      , system ? "i686-linux"
      }:

      with import nixpkgs {inherit system;};

      let

        version = builtins.readFile ./VERSION + (if officialRelease then "" else "pre${toString nixosSrc.rev}");

        iso = (import "${nixosSrc}/installer/cd-dvd/rescue-cd.nix" {
          platform = system;
          compressImage = true;
          nixpkgsPath = nixpkgs.outPath;
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