{ cabal, Cabal, happy }:

cabal.mkDerivation (self: {
  pname = "Ebnf2ps";
  version = "1.0.10";
  sha256 = "0xim32bnfapfs53lvmdz2af08rqd15lp5b0rh6yjqm7n1g2061zs";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal ];
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
