{ mkDerivation, async, base, bytestring, connection, containers
, directory, hpack, hspec, hspec-discover, hspec-expectations
, http-client, http-conduit, lens, lens-aeson, megaparsec, mtl
, optparse-applicative, parser-combinators, retry, stdenv, text
, unix, unordered-containers, utf8-string, fetchzip
}:
mkDerivation rec {
  pname = "vaultenv";
  version = "0.8.0";

  src = fetchzip {
    url = "https://github.com/channable/vaultenv/archive/v${version}.tar.gz";
    sha256 = "04hrwyy7gsybdwljrks4ym3pshqk1i43f8wpirjx7b0dfjgsd2l5";
  };

  buildTools = [ hpack ];

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async base bytestring connection containers http-client
    http-conduit lens lens-aeson megaparsec mtl optparse-applicative
    parser-combinators retry text unix unordered-containers utf8-string
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
  maintainers = with stdenv.lib.maintainers; [ lnl7 ];
}
