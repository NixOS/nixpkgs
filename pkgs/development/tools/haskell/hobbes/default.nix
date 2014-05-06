{ cabal, filemanip, filepath, fsnotify, systemFilepath, text }:

cabal.mkDerivation (self: {
  pname = "hobbes";
  version = "0.2.2";
  sha256 = "1pri63d59q918jv1hdp2ib06m6lzw9a2b6bjyn86b2qrrx2512xd";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filemanip filepath fsnotify systemFilepath text ];
  meta = {
    homepage = "http://github.com/jhickner/hobbes";
    description = "A small file watcher for OSX";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
