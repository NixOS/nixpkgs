{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.3.3"; # Haskell Platform 2010.2.0.0
  name = self.fname;
  sha256 = "338fc492a1fddd6c528d0eb89857cadab211cb42680aeee1f9702bbfa7c5e1c8";
  extraBuildInputs = [perl];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
