{ cabal, attoparsec, blazeBuilder, caseInsensitive, conduit
, dataDefault, filepath, fsnotify, httpConduit, httpReverseProxy
, httpTypes, mtl, network, networkConduit, networkConduitTls
, random, regexTdfa, systemFileio, systemFilepath, tar, text, time
, transformers, unixCompat, unixProcessConduit, wai, waiAppStatic
, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "0.4.0";
  sha256 = "0ny8z2rfn090vci262xvyrdbkmdb7qjb4x15r81l2691ibf09ppv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder caseInsensitive conduit dataDefault
    filepath fsnotify httpConduit httpReverseProxy httpTypes mtl
    network networkConduit networkConduitTls random regexTdfa
    systemFileio systemFilepath tar text time transformers unixCompat
    unixProcessConduit wai waiAppStatic warp warpTls yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
