{ cabal, filepath, json, utf8String }:

cabal.mkDerivation (self: {
  pname = "hasktags";
  version = "0.68.7";
  sha256 = "0z98ha2xjc6npcyn15arp6h6ad87bs4acdhd1rnqrsy4lc0lny04";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath json utf8String ];
  meta = {
    homepage = "http://github.com/MarcWeber/hasktags";
    description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
