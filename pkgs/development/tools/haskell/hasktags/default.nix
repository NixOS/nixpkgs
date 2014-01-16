{ cabal, filepath, HUnit, interlude, json }:

cabal.mkDerivation (self: {
  pname = "hasktags";
  version = "0.68.4";
  sha256 = "1s4zblyklrq3grcvr6fp26jby6z61g3n1fpivmh69lh38axk7316";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath HUnit interlude json ];
  testDepends = [ filepath HUnit json ];
  meta = {
    homepage = "http://github.com/MarcWeber/hasktags";
    description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
