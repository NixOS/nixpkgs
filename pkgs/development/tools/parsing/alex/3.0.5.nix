{ cabal, fetchpatch, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.0.5";
  sha256 = "0ncnp7cl7dlfcrwzzcp8j59i9j5r66wim1yib9g3b3jkl0bn8cn3";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ QuickCheck ];
  buildTools = [ perl ];
  patches = [ (fetchpatch { url="http://github.com/simonmar/alex/pull/21.patch"; sha256="050psfwmjlxhyxiy65jsn3v6b9rnfzy8x5q9mmhzwbirqwi0zkfm"; }) ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
