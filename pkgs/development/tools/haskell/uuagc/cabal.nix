{ cabal, Cabal, filepath, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-cabal";
  version = "1.0.4.0";
  sha256 = "0m6q8lfbrzcdxd923s175x0z1rnniv7gk08ninzpq16fisscr4lf";
  buildDepends = [ Cabal filepath mtl uulib ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Cabal plugin for the Universiteit Utrecht Attribute Grammar System";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
