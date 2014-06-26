{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, conduitExtra, dataDefault, filepath, fsnotify, hspec
, httpClient, httpConduit, httpReverseProxy, httpTypes, liftedBase
, mtl, network, networkConduitTls, random, regexTdfa, stm
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unorderedContainers, vector, wai, waiAppStatic
, waiExtra, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.3.2";
  sha256 = "1vmn7aaljwg3gv6vbj9z5w2mffsls5d6mzs4rg9s3rh8khb14cr0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    conduitExtra dataDefault filepath fsnotify httpClient httpConduit
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
