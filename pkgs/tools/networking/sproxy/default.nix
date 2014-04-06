{ cabal, aeson, attoparsec, caseInsensitive, certificate
, concurrentExtra, cryptoRandom, curl, dataDefault, hslogger, hspec
, HTTP, httpTypes, interpolatedstringPerl6, mtl, network
, optparseApplicative, postgresqlSimple, safe, SHA, split
, stringConversions, time, tls, unorderedContainers, utf8String
, x509, yaml, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "sproxy";
  version = "0.7.4";
  src = fetchurl {
    url = "https://github.com/zalora/sproxy/archive/0.7.4.tar.gz";
    sha256 = "1zlsln0ihg7p8jk5gdvm9as6gk4fs8vaa547iq2yvna4c1wb4amr";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec caseInsensitive certificate concurrentExtra
    cryptoRandom curl dataDefault hslogger HTTP httpTypes
    interpolatedstringPerl6 mtl network optparseApplicative
    postgresqlSimple safe SHA split stringConversions time tls
    unorderedContainers utf8String x509 yaml
  ];
  testDepends = [
    aeson attoparsec caseInsensitive certificate concurrentExtra
    cryptoRandom curl dataDefault hslogger hspec HTTP httpTypes
    interpolatedstringPerl6 mtl network optparseApplicative
    postgresqlSimple safe SHA split stringConversions time tls
    unorderedContainers utf8String x509 yaml
  ];
  meta = {
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
