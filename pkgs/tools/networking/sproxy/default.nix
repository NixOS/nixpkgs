{ cabal, aeson, attoparsec, caseInsensitive, certificate
, concurrentExtra, conduit, connection, cryptoRandom, curl
, dataDefault, hslogger, hspec, httpConduit, httpKit, httpTypes
, interpolatedstringPerl6, mtl, network, optparseApplicative
, postgresqlSimple, safe, SHA, split, stringConversions, time, tls
, unorderedContainers, utf8String, wai, warp, x509, yaml, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "sproxy";
  version = "0.8.0";
  src = fetchurl {
    url = "https://github.com/zalora/sproxy/archive/0.8.0.tar.gz";
    sha256 = "11xn4k509ck73pacyz2kh0924n2vy8rwakwd42dwbvhhysf47rdx";
  };
  isLibrary = false;
  isExecutable = true;
  patches = [ ./new-http-kit.patch ];
  doCheck = false;
  buildDepends = [
    aeson attoparsec caseInsensitive certificate concurrentExtra
    cryptoRandom curl dataDefault hslogger httpKit httpTypes
    interpolatedstringPerl6 mtl network optparseApplicative
    postgresqlSimple safe SHA split stringConversions time tls
    unorderedContainers utf8String x509 yaml
  ];
  testDepends = [
    aeson attoparsec caseInsensitive certificate concurrentExtra
    conduit connection cryptoRandom curl dataDefault hslogger hspec
    httpConduit httpKit httpTypes interpolatedstringPerl6 mtl network
    optparseApplicative postgresqlSimple safe SHA split
    stringConversions time tls unorderedContainers utf8String wai warp
    x509 yaml
  ];
  meta = {
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    broken = true;
  };
})
