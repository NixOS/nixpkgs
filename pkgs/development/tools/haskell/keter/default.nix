{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, dataDefault, filepath, fsnotify, httpConduit
, httpReverseProxy, httpTypes, liftedBase, mtl, network
, networkConduit, networkConduitTls, random, regexTdfa, stm
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unixProcessConduit, unorderedContainers, vector, wai
, waiAppStatic, waiExtra, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.0.1.2";
  sha256 = "1rk0sf6riyb6r1sz0jkvwwj1yyxwjxgafpidp9rqwm8wnqyx6hh8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    dataDefault filepath fsnotify httpConduit httpReverseProxy
    httpTypes liftedBase mtl network networkConduit networkConduitTls
    random regexTdfa stm systemFileio systemFilepath tar text time
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
