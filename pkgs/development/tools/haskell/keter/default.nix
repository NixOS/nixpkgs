{ cabal, blazeBuilder, conduit, dataDefault, filepath, hinotify
, httpReverseProxy, httpTypes, network, networkConduit
, networkConduitTls, random, systemFileio, systemFilepath, tar
, text, time, transformers, unixCompat, unixProcessConduit, wai
, waiAppStatic, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "0.3.5.4";
  sha256 = "0dqlfb5cydqk33zp6wf18wr3idpn3bbb8im3rcrg4r9ny7sqfmp7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder conduit dataDefault filepath hinotify httpReverseProxy
    httpTypes network networkConduit networkConduitTls random
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
