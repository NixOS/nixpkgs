{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, dataDefault, filepath, fsnotify, hspec, httpClient
, httpClientConduit, httpConduit, httpReverseProxy, httpTypes
, liftedBase, mtl, network, networkConduit, networkConduitTls
, random, regexTdfa, stm, systemFileio, systemFilepath, tar, text
, time, transformers, unixCompat, unorderedContainers, vector, wai
, waiAppStatic, waiExtra, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.2.1";
  sha256 = "160kw3c2h9i1rwhicm860ahanx9p9qskrnfxsa68484j0cmw1ga9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    dataDefault filepath fsnotify httpClient httpClientConduit
    httpConduit httpReverseProxy httpTypes liftedBase mtl network
    networkConduit networkConduitTls random regexTdfa stm systemFileio
    systemFilepath tar text time transformers unixCompat
    unorderedContainers vector wai waiAppStatic waiExtra warp warpTls
    yaml zlib
  ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
