{ cabal, Cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck
, random, stm, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time, zlib
}:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "1.20.0.2";
  sha256 = "1nsc8qklhlg2xpaj7k158gg45rlrp7mn15zyfsgjpaqf3rjm9dl4";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal filepath HTTP mtl network random stm time zlib
  ];
  testDepends = [
    Cabal filepath HTTP HUnit mtl network QuickCheck stm testFramework
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
