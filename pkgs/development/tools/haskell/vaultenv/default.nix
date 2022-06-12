{ mkDerivation
, async
, base
, bytestring
, connection
, containers
, directory
, hpack
, hspec
, hspec-discover
, hspec-expectations
, http-client
, http-conduit
, lens
, lens-aeson
, megaparsec
, mtl
, optparse-applicative
, parser-combinators
, retry
, lib
, text
, unix
, unordered-containers
, utf8-string
, fetchFromGitHub
, dotenv
}:
mkDerivation rec {
  pname = "vaultenv";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "channable";
    repo = "vaultenv";
    rev = "v${version}";
    sha256 = "sha256-sH4iaKQXgwI/WISXzMR7xqh9Dyx61U/gjYn7exgUetI=";
  };

  buildTools = [ hpack ];

  prePatch = ''
    substituteInPlace package.yaml \
        --replace -Werror ""
  '';

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async
    base
    bytestring
    connection
    containers
    http-client
    http-conduit
    lens
    lens-aeson
    megaparsec
    mtl
    optparse-applicative
    parser-combinators
    retry
    text
    unix
    unordered-containers
    utf8-string
    dotenv
  ];
  testHaskellDepends = [
    async
    base
    bytestring
    connection
    containers
    directory
    hspec
    hspec-discover
    hspec-expectations
    http-client
    http-conduit
    lens
    lens-aeson
    megaparsec
    mtl
    optparse-applicative
    parser-combinators
    retry
    text
    unix
    unordered-containers
    utf8-string
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/channable/vaultenv#readme";
  description = "Runs processes with secrets from HashiCorp Vault";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ lnl7 manveru ];
}
