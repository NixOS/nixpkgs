{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, dataDefault, filepath, fsnotify, httpClient
, httpClientConduit, httpConduit, httpReverseProxy, httpTypes
, liftedBase, mtl, network, networkConduit, networkConduitTls
, random, regexTdfa, stm, systemFileio, systemFilepath, tar, text
, time, transformers, unixCompat, unixProcessConduit
, unorderedContainers, vector, wai, waiAppStatic, waiExtra, warp
, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.2.0";
  sha256 = "06iz01ci1mcxjqs7dknxgjlkl783sdf680b54schxxirg268cxh3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    dataDefault filepath fsnotify httpClient httpClientConduit
    httpConduit httpReverseProxy httpTypes liftedBase mtl network
    networkConduit networkConduitTls random regexTdfa stm systemFileio
    systemFilepath tar text time transformers unixCompat
    unixProcessConduit unorderedContainers vector wai waiAppStatic
    waiExtra warp warpTls yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
