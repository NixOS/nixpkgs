{ lib
, fetchFromGitHub
# Haskell deps
, mkDerivation, aeson, base, base16-bytestring, binary, brick, bytestring
, containers, data-dword, data-has, directory, exceptions, extra, filepath
, hashable, hevm, hpack, html-entities, lens, ListLike, MonadRandom, mtl
, optparse-applicative, process, random, semver, tasty, tasty-hunit
, tasty-quickcheck, text, transformers, unix, unliftio, unordered-containers
, vector, vector-instances, vty, yaml, code-page, html-conduit, http-conduit
, with-utf8, xml-conduit
}:
mkDerivation rec {
  pname = "echidna";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "sha256-2Big7mg/ZdpLZgd26l0SjlgMNjwgIbkF41qmU8uoOlE=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base16-bytestring binary brick bytestring containers data-dword
    data-has directory exceptions extra filepath hashable hevm html-entities
    lens ListLike MonadRandom mtl optparse-applicative process random semver
    text transformers unix unliftio unordered-containers vector vector-instances
    vty yaml code-page html-conduit http-conduit with-utf8 xml-conduit
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = libraryHaskellDepends;
  testHaskellDepends = [
    tasty tasty-hunit tasty-quickcheck
  ];
  preConfigure = ''
    hpack
    # re-enable dynamic build for Linux
    sed -i -e 's/os(linux)/false/' echidna.cabal
  '';
  shellHook = "hpack";
  doHaddock = false;
  # tests depend on a specific version of solc
  doCheck = false;

  description = "Ethereum smart contract fuzzer";
  homepage = "https://github.com/crytic/echidna";
  license = lib.licenses.agpl3Plus;
  maintainers = with lib.maintainers; [ arturcygan ];
  platforms = lib.platforms.unix;
  mainProgram = "echidna-test";
}
