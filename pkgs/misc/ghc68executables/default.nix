args: with args;
let inherit (bleedingEdgeRepos)  sourceByName;
# map ghcCabalExecutableFun and add cabal dependency to all 
executables = lib.mapAttrs ( name_dummy : a : ghcCabalExecutableFun (a // { libsFun = x : (a.libsFun x) ++ [x.cabal_darcs]; } ) )
({
  nixRepositoryManager = import ./nix-repository-manager.nix {
    inherit (args) lib pkgs;
    inherit bleedingEdgeRepos;
  };

  hasktags = {
    # calling it hasktags-modified to not clash with the one distributed with ghc
    name = "hasktags-modified";
    src = args.fetchurl {
      url = http://mawercer.de/~nix/hasktags.hs;
      sha256 = "9d1be56133f468f5a2302d8531742eba710ad89d5a271308453b44cc9f47e94a";
    };
    libsFun = x : [x.base x.directory x.haskell98 x.mtl];
    pass = {
      phases = "buildPhase";
      buildPhase = "
        ensureDir \$out/bin; cp $src hasktags.hs
        ghc --make hasktags.hs -o \$out/bin/hasktags-modified
      ";
    };
    meta = {
        # this package can be removed again when somone comitts my changes into the distribution
        description = "Marc's modified hasktags";
    };
  };

  happy = {
    name = "happy-1.17";
    libsFun = x : [x.base x.directory x.haskell98 x.mtl];
    src = fetchurl {
      url =  "http://hackage.haskell.org/packages/archive/happy/1.17/happy-1.17.tar.gz";
      sha256 = "0aqaqy27fkkilj3wk03krx2gdgrw5hynn8wnahrkimg52xyy996w";
    };
    meta = {
      executables = ["happy"];
      description = "A lexical analyser generator for Haskell";
      homepage = http://www.haskell.org/happy/;
      license = "BSD3";
    };
    pass = {
      patchPhase = '' sed -e "s/buildVerbose flags/fromFlag (buildVerbosity flags)/g" -e "s/BuildFlags(..)/BuildFlags(..), fromFlag/g" -i Setup.lhs '';
    };
  };
  alex = {
    name = "alex-2.2";
    libsFun = x : [x.base x.haskell98];
    src = fetchurl {
      url =  "http://hackage.haskell.org/packages/archive/alex/2.2/alex-2.2.tar.gz";
      sha256 = "1zhzlhwljbd52hwd8dm7fcbinfzjhal5x91rvi8x7cgxdkyd8n79";
    };
    meta = {
      executables = ["alex"];
      description = "tool generating lexical analysers";
      homepage = http://www.haskell.org/alex/;
      license = "BSD3";
    };
    pass = {
      patchPhase = '' sed -e "s/buildVerbose flags/fromFlag (buildVerbosity flags)/g" -e "s/BuildFlags(..)/BuildFlags(..), fromFlag/g" -i Setup.lhs '';
    };
  };
  drift = {
    name = "DrIFT-2.2.3";
    libsFun = x : [ x.base x.haskell98 ];
    src = fetchurl {
      url = http://hackage.haskell.org/packages/archive/DrIFT/2.2.3/DrIFT-2.2.3.tar.gz;
      sha256 = "1615ijdz1bcmgnz86yx54ap6r7q08flh309jfyc7xaxxq5cdib0k";
    };
    meta = { 
      description = "DrIFT is a type sensitive preprocessor for Haskell";
      homepage = http://repetae.net/computer/haskell/DrIFT/;
      license = "BSD3";
    };
  };
  hxq = { 
    name="hxq-0.7";
    libsFun = x: [ x.base x.haskell98 x.template_haskell ];
    src = fetchurl { url = http://hackage.haskell.org/packages/archive/HXQ/0.7/HXQ-0.7.tar.gz; sha256 = "0zwar8fykks1n86zm0alkdx4yg903hkdr66wffsji6fhhpkzcmrh";};
  };
  #leksah = {
    #name="leksah-darcs";
    #libsFun = x: [ x.base x.filepath x.parsec x.mtl x.process x.old_time x.containers x.pretty x.directory x.gtk2hs x.binary x.bytestring x.cabal_darcs x.ghc ];
    #src = sourceByName "leksah";
  #};
  #hsffig = 
  #  let version = "0.1.2-08-29-2007"; in
  #  rec {
  #  name = "hsffig-${version}";
  #  src = fetchurl {
  #    url = "http://www.golubovsky.org/software/hsffig/nightly/hsffig.${version}.tar.gz";
  #    sha256 = "0pp27dchp5jshsacc1n15jvabsvc60l6phyfw0x9y6cmcwq72blg";
  #  };
  #  pass = { patchPhase = ''
  #    sed -e "s/ALEX =.*/ALEX=alex/" -e "s/-package text//" -i Makefile 
  #  '';
  #    buildPhase = "unset buildPhase; buildPhase"; [> force using default buildPhase 
  #  };
  #  libsFun = x : [ x.base x.directory x.process x.cabal_darcs x.finitemap executables.alex executables.happy ];
  #  meta = { 
  #      description = "automatically generates C bindings for haskell (needs hsc2hs)";
  #      homepage = "now sourceforge";
  #      license = "BSD";
  #      executables = ["hsffig"];
  #  };
  #};
  flapjax = {
  name = "flapjax-source-20070514";
    src = args.fetchurl {
      url = http://www.flapjax-lang.org/download/20070514/flapjax-source.tar.gz;
      sha256 = "188dafpggbfdyciqhrjaq12q0q01z1rp3mpm2iixb0mvrci14flc";
    };
    pass = { buildPhase  = "
      ensureDir \$out/bin
      cd compiler;
      ghc --make Fjc.hs -o \$out/bin/fjc
    "; };
    libsFun = x : [x.mtl x.parsec x.random];
    meta = { 
        description = "programming language designed around the demands of modern, client-based Web applications";
        homepage = http://www.flapjax-lang.org/;
        license = "BSD";
        executables = ["fjc"];
    };
  };
  /*
  xmonad = {
    name = "xmonad-darcs";
    libsFun = x : [x.base x.mtl x.unix x.x11 x.x11extras xmessage  ];
    src = sourceByName "xmonad";
  };
  darcs_unstable = {
    name = "darcs_unstable";
    libsFun = x : [x.base x.haskell98 x.http_darcs x.regex_compat x.quickcheck x.bytestring x.parsec x.html x.containers];
    src = sourceByName "pg_darcsone";
    pass = {
      buildInputs = [  autoconf zlib ];
      postUnpack = "cd nix_*; pwd; autoconf; cd ..";
        NIX_LDFLAGS = "-lz";
    };
  };

  */
  mkcabal = { 
    name = "mkcabal-0.4.1"; 
    libsFun = x : [x.base x.readline x.pcreLight x.mtl];
    src = sourceByName "mkcabal";
    meta = { 
      executables = ["mkcabal"]; 
      description = "mkcabal"; 
      homepage = "hackage"; 
      license = "BSD3"; 
    }; 
    pass = { 
      patchPhase = "sed -i s/0.3/0.3.1/g -i mkcabal.cabal";
      buildInputs = pkgs.readline; # hack - this shouldn't be needed! 
    }; 
  }; 
} // getConfig ["ghc68CustomExecutables"] (x : {} ) pkgs  ); in executables

