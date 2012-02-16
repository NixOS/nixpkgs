{ cabal, Cabal, filepath, hint, mtl, network, syb }:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.6.0.2";
  sha256 = "13mi6z37fszrl97mll4injhq8dyhqzm344x7y2vw8krr5xjj3kw2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath hint mtl network syb ];
  meta = {
    homepage = "http://www.cs.kent.ac.uk/projects/refactor-fp";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
