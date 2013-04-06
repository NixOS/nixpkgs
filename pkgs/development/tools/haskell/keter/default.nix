{ cabal, attoparsec, blazeBuilder, caseInsensitive, conduit
, dataDefault, filepath, hinotify, httpConduit, httpReverseProxy
, httpTypes, mtl, network, networkConduit, networkConduitTls
, random, regexTdfa, systemFileio, systemFilepath, tar, text, time
, transformers, unixCompat, unixProcessConduit, wai, waiAppStatic
, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "0.3.6.1";
  sha256 = "0jww64q74kx5h69mnv9wgc4kx0nlb06r7lf651gjkai8mf9dkqf2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder caseInsensitive conduit dataDefault
    filepath hinotify httpConduit httpReverseProxy httpTypes mtl
    network networkConduit networkConduitTls random regexTdfa
    systemFileio systemFilepath tar text time transformers unixCompat
    unixProcessConduit wai waiAppStatic yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
