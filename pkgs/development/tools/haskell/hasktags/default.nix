{ cabal, filepath, HUnit, json }:

cabal.mkDerivation (self: {
  pname = "hasktags";
  version = "0.68.6";
  sha256 = "1r5vnn9n2jva1ccjv8vnp3j0z3bh3xsi7yjv9llnvj0jw308aq9r";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath json ];
  testDepends = [ filepath HUnit json ];
  meta = {
    homepage = "http://github.com/MarcWeber/hasktags";
    description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
