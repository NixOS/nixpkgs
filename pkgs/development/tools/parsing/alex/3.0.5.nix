{ cabal, fetchurl, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.0.5";
  sha256 = "0ncnp7cl7dlfcrwzzcp8j59i9j5r66wim1yib9g3b3jkl0bn8cn3";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ QuickCheck ];
  buildTools = [ perl ];
  patches = [ (fetchurl { url="https://github.com/simonmar/alex/pull/21.patch"; sha256="0apv3rk00gwkf5rqw3467bg6pnamr07zdksbp9khhzzi73k9aq4f"; }) ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
