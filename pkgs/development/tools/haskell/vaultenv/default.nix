{
  mkDerivation,
  HsOpenSSL,
  QuickCheck,
  aeson,
  async,
  base,
  bytestring,
  containers,
  crypton-connection,
  directory,
  hpack,
  hspec,
  hspec-discover,
  hspec-expectations,
  http-client,
  http-client-openssl,
  http-conduit,
  lib,
  megaparsec,
  network-uri,
  optparse-applicative,
  parser-combinators,
  quickcheck-instances,
  retry,
  text,
  unix,
  unordered-containers,
  utf8-string,
  dotenv,
  fetchFromGitHub,
}:
mkDerivation rec {
  pname = "vaultenv";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "channable";
    repo = "vaultenv";
    rev = "v${version}";
    hash = "sha256-Jb+Y/Cbapw2ZCXMwXMw1hsy0vT/K8mM/A/Z1all7y+A=";
  };

  buildTools = [ hpack ];

  prePatch = ''
    substituteInPlace package.yaml \
        --replace -Werror ""
  '';

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    HsOpenSSL
    aeson
    async
    base
    bytestring
    containers
    crypton-connection
    directory
    dotenv
    http-client
    http-client-openssl
    http-conduit
    megaparsec
    network-uri
    optparse-applicative
    optparse-applicative
    parser-combinators
    retry
    text
    unix
    unordered-containers
    utf8-string
  ];
  testHaskellDepends = executableHaskellDepends ++ [
    QuickCheck
    directory
    hspec
    hspec-discover
    hspec-expectations
    quickcheck-instances
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/channable/vaultenv#readme";
  description = "Runs processes with secrets from HashiCorp Vault";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [
    lnl7
    manveru
  ];
}
