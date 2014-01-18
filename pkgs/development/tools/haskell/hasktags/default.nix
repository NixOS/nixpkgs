{ cabal, filepath, HUnit, interlude, json }:

cabal.mkDerivation (self: {
  pname = "hasktags";
  version = "0.68.5";
  sha256 = "0yr7icaww5kiczmi64n2ypkwabs4yl8wl2kf67zmgclp12kqik81";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath HUnit interlude json ];
  meta = {
    homepage = "http://github.com/MarcWeber/hasktags";
    description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
