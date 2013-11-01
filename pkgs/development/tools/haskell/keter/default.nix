{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, dataDefault, filepath, fsnotify, httpConduit
, httpReverseProxy, httpTypes, mtl, network, networkConduit
, networkConduitTls, random, regexTdfa, stm, systemFileio
, systemFilepath, tar, text, time, transformers, unixCompat
, unixProcessConduit, unorderedContainers, vector, wai
, waiAppStatic, waiExtra, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.0.1.1";
  sha256 = "1bcp9yxmh5z7cvap4nrj8gxnndwws21w6y352yasf35bf432nxa9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    dataDefault filepath fsnotify httpConduit httpReverseProxy
    httpTypes mtl network networkConduit networkConduitTls random
    regexTdfa stm systemFileio systemFilepath tar text time
    transformers unixCompat unixProcessConduit unorderedContainers
    vector wai waiAppStatic waiExtra warp warpTls yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
