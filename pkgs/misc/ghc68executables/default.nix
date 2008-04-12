args: with args;
     let inherit (bleedingEdgeRepos)  sourceByName;
     in
# map ghcCabalExecutableFun and add cabal dependency to all 
lib.mapAttrs ( name_dummy : a : ghcCabalExecutableFun (a // { libsFun = x : (a.libsFun x) ++ [x.cabal_darcs]; } ) )
{
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
      patchPhase = '' sed -e "s/buildVerbose flags/fromFlag (buildVerbose flags)/g" -e "s/BuildFlags(..)/BuildFlags(..), fromFlag/g" -i Setup.lhs '';
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
      patchPhase = '' sed -e "s/buildVerbose flags/fromFlag (buildVerbose flags)/g" -e "s/BuildFlags(..)/BuildFlags(..), fromFlag/g" -i Setup.lhs '';
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
}
