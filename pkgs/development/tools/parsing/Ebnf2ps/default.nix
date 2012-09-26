{ cabal, happy }:

cabal.mkDerivation (self: {
  pname = "Ebnf2ps";
  version = "1.0.11";
  sha256 = "0n0maihalnrks3l7ay1i16p6i7f69xv33jxhlsyshzck0v64qivb";
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
