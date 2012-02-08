{ cabal, happy }:

cabal.mkDerivation (self: {
  pname = "Ebnf2ps";
  version = "1.0.9";
  sha256 = "0c8nbjyar5dqv33vnm3r1f2rbrmwnv1fm41cbgb6fbsf0cp3979w";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ happy ];
  meta = {
    homepage = "http://www.informatik.uni-freiburg.de/~thiemann/haskell/ebnf2ps/";
    description = "Peter's Syntax Diagram Drawing Tool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
