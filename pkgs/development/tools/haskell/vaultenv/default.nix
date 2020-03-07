{ mkDerivation, async, base, bytestring, connection, containers
, directory, hpack, hspec, hspec-discover, hspec-expectations
, http-client, http-conduit, lens, lens-aeson, megaparsec, mtl
, optparse-applicative, parser-combinators, retry, stdenv, text
, unix, unordered-containers, utf8-string, fetchzip, dotenv
}:
mkDerivation rec {
  pname = "vaultenv";
  version = "0.13.0";

  src = fetchzip {
    url = "https://github.com/channable/vaultenv/archive/v${version}.tar.gz";
    sha256 = "0kz5p57fq855mhbqrpb737sqrax9cdcyh2g57460hc8fyvs97lq0";
  };

  buildTools = [ hpack ];

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async base bytestring connection containers http-client
    http-conduit lens lens-aeson megaparsec mtl optparse-applicative
    parser-combinators retry text unix unordered-containers utf8-string
    dotenv
  ];
  testHaskellDepends = [
    async base bytestring connection containers directory hspec
    hspec-discover hspec-expectations http-client http-conduit lens
    lens-aeson megaparsec mtl optparse-applicative parser-combinators
    retry text unix unordered-containers utf8-string
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/channable/vaultenv#readme";
  description = "Runs processes with secrets from HashiCorp Vault";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ lnl7 manveru ];
}
