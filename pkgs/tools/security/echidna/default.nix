{ lib
, fetchFromGitHub
# Haskell deps
, mkDerivation, aeson, ansi-terminal, base, base16-bytestring, binary, brick
, bytestring, cborg, containers, data-dword, data-has, deepseq, directory
, exceptions, filepath, hashable, hevm, hpack, lens, lens-aeson, megaparsec
, MonadRandom, mtl, optparse-applicative, process, random, stm, tasty
, tasty-hunit, tasty-quickcheck, temporary, text, transformers , unix, unliftio
, unliftio-core, unordered-containers, vector, vector-instances, vty
, wl-pprint-annotated, word8, yaml, extra, ListLike, semver
}:
mkDerivation rec {
  pname = "echidna";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "sha256-ZLk3K00O6aERf+G5SagDVUk1/ba9U+9n9dqCImkczJs=";
  };

  # NOTE: echidna is behind with aeson because of hevm, this patch updates
  # the code to work with the major aeson update that broke the build
  # it's temporary until hevm version 0.50.0 is released - https://github.com/ethereum/hevm/milestone/1
  patches = [ ./echidna-update-aeson.patch ];

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-terminal base base16-bytestring binary brick bytestring cborg
    containers data-dword data-has deepseq directory exceptions filepath
    hashable hevm lens lens-aeson megaparsec MonadRandom mtl
    optparse-applicative process random stm temporary text transformers unix
    unliftio unliftio-core unordered-containers vector vector-instances vty
    wl-pprint-annotated word8 yaml extra ListLike semver
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
