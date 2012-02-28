{ cabal, Cabal, filepath, HSH }:

cabal.mkDerivation (self: {
  pname = "haskdogs";
  version = "0.3";
  sha256 = "0aji59sazlhn5yardgrsdpf85fvb0mwn4bpslcjxr7mnmpa7j0kz";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath HSH ];
  meta = {
    homepage = "http://github.com/ierton/haskdogs";
    description = "Generate ctags file for haskell project directory and it's deps";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
