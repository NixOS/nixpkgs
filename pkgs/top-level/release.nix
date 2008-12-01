let

  allPackages = import ./all-packages.nix;

  test = f: {system}: f (allPackages {inherit system;});
  

  jobs = {

  
    tarball =
      { nixpkgs ? {path = ../../../nixpkgs-wc; rev = 1234;}
      , officialRelease ? false
      }:

      with import nixpkgs.path {};

      releaseTools.makeSourceTarball {
        name = "nixpkgs-tarball";
        src = nixpkgs;
        inherit officialRelease;

        buildInputs = [
          lzma
          libxml2 # Needed for the release notes.
          libxslt
          w3m
          nixUnstable # Needed to check whether the expressions are valid.
        ];
    
        configurePhase = ''
          eval "$preConfigure"
          releaseName=nixpkgs-$(cat $src/VERSION)$VERSION_SUFFIX
          echo "release name is $releaseName"
          echo $releaseName > relname
        '';

        dontBuild = false;
                
        buildPhase = ''
          echo "building docs..."
          (cd doc && make docbookxsl=${docbook5_xsl}/xml/xsl/docbook) || false
          ln -s doc/NEWS.txt NEWS
        '';
 
        doCheck = true;

        checkPhase = ''
          # Check that we can fully evaluate build-for-release.nix.
          header "checking pkgs/top-level/build-for-release.nix"
          nix-env --readonly-mode -f pkgs/top-level/build-for-release.nix \
              -qa \* --drv-path --system-filter \* --system
          stopNest

          # Check that all-packages.nix evaluates on a number of platforms.
          for platform in i686-linux x86_64-linux powerpc-linux i686-freebsd powerpc-darwin i686-darwin; do
              header "checking pkgs/top-level/all-packages.nix on $platform"
              nix-env --readonly-mode -f pkgs/top-level/all-packages.nix \
                  --argstr system "$platform" \
                  -qa \* --drv-path --system-filter \* --system
              stopNest
          done
        '';

        distPhase = ''
          ensureDir $out/tarballs
          mkdir ../$releaseName
          cp -prd . ../$releaseName
          (cd .. && tar cfa $out/tarballs/$releaseName.tar.bz2 $releaseName) || false
          (cd .. && tar cfa $out/tarballs/$releaseName.tar.lzma $releaseName) || false

          ensureDir $out/release-notes
          cp doc/NEWS.html $out/release-notes/index.html
          cp doc/style.css $out/release-notes/
          echo "doc release-notes $out/release-notes" >> $out/nix-support/hydra-build-products

          ensureDir $out/manual
          cp doc/manual.html $out/manual/index.html
          cp doc/style.css $out/manual/
          echo "doc manual $out/manual" >> $out/nix-support/hydra-build-products
        '';
      };


      # All the top-level packages that want to build in the build farm.
      # !!! notation is kinda clumsy

      MPlayer = test (pkgs: pkgs.MPlayer);
      autoconf = test (pkgs: pkgs.autoconf);
      bash = test (pkgs: pkgs.bash);
      firefox3 = test (pkgs: pkgs.firefox3);
      gcc = test (pkgs: pkgs.gcc);
      hello = test (pkgs: pkgs.hello);
      libtool = test (pkgs: pkgs.libtool);
      pan = test (pkgs: pkgs.pan);
      perl = test (pkgs: pkgs.perl);
      python = test (pkgs: pkgs.python);
      thunderbird = test (pkgs: pkgs.thunderbird);
      wine = test (pkgs: pkgs.wine);
              
  };

in jobs
