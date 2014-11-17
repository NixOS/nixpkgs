{ cabal, CabalGhcjs, filepath, HTTP, HUnit, mtl, network, QuickCheck
, random, stm, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time, zlib, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "cabal-install-ghcjs";
  version = CabalGhcjs.version;
  src = CabalGhcjs.src;
  isLibrary = true;
  isExecutable = true;
  doCheck = false;
  configureFlags = "--program-suffix=-js";
  preConfigure = "cd cabal-install";
  noHaddock = true;
  buildDepends = [
    CabalGhcjs filepath HTTP mtl network random stm time zlib
  ];
  testDepends = [
    CabalGhcjs filepath HTTP HUnit mtl network QuickCheck stm testFramework
    testFrameworkHunit testFrameworkQuickcheck2 time zlib
  ];
  postInstall = ''
    mkdir $out/etc
    mv bash-completion $out/etc/bash_completion.d
  '';
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "The command-line interface for Cabal and Hackage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
