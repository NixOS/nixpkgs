{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, conduitExtra, dataDefault, filepath, fsnotify, hspec
, httpConduit, httpReverseProxy, httpTypes, liftedBase, mtl
, network, networkConduitTls, random, regexTdfa, stm, systemFileio
, systemFilepath, tar, text, time, transformers, unixCompat
, unorderedContainers, vector, wai, waiAppStatic, waiExtra, warp
, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.3.0";
  sha256 = "1fvb93iga4c0kfv29ksrmn9bjznl7wfspg1v9a5d3svwrszl4is3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    conduitExtra dataDefault filepath fsnotify httpConduit
    httpReverseProxy httpTypes liftedBase mtl network networkConduitTls
    random regexTdfa stm systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers vector wai waiAppStatic
    waiExtra warp warpTls yaml zlib
  ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
