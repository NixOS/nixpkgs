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
, quickcheck-instances
, text
, unix
, unordered-containers
, utf8-string
, fetchFromGitHub
, dotenv
}:
mkDerivation rec {
  pname = "vaultenv";
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "channable";
    repo = "vaultenv";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EPu4unzXIg8naFUEZwbJ2VJXD/TeCiKzPHCXnRkdyBE=";
=======
    sha256 = "sha256-yoYkAypH+HQSVTvd/qKNFkL5krbB5mZw3ec9ojvy+Pw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    quickcheck-instances
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
