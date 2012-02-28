{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "hasktags";
  version = "0.68.2";
  sha256 = "0lb28vj8mhaskw3n7wpjgbj0311ywh76yc0ajczzsiqa3p6mypss";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath ];
  meta = {
    description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
