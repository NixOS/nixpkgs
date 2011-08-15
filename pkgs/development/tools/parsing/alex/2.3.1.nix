{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.3.1"; # Haskell Platform 2009.0.0
  name = self.fname;
  sha256 = "cdd42fd992a72fedeff1f38debc21aa315d90dc070f0945d7819c0bccd549a44";
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
