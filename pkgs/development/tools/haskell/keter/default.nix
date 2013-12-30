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
  version = "1.1.0.1";
  sha256 = "04hvwfs1dskaxl1fw29lf52389hy1yr3hwd05bl294zgfh995i0s";
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
