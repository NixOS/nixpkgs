{ lib
, fetchpatch
, fetchFromGitHub
# Haskell deps
, mkDerivation, aeson, ansi-terminal, base, base16-bytestring, binary, brick
, bytestring, cborg, containers, data-dword, data-has, deepseq, directory
, exceptions, filepath, hashable, hevm, hpack, lens, lens-aeson, megaparsec
, MonadRandom, mtl, optparse-applicative, process, random, stm, tasty
, tasty-hunit, tasty-quickcheck, temporary, text, transformers , unix, unliftio
, unliftio-core, unordered-containers, vector, vector-instances, vty
, wl-pprint-annotated, word8, yaml , extra, ListLike, semver
}:
mkDerivation rec {
  pname = "echidna";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "sha256-NkAAXYa1bbCNUO0eDM7LQbyC3//RRFAKmEHGH2Dhl/M=";
  };

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
}
