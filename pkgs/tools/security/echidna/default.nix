{ mkDerivation, lib, fetchFromGitHub, aeson, ansi-terminal, base
, base16-bytestring, binary, brick, bytestring, containers, data-dword
, data-has, deepseq, directory, exceptions, filepath, hashable, hevm, hpack
, lens, lens-aeson, megaparsec, MonadRandom, mtl, optparse-applicative, process
, random, stm, tasty, tasty-hunit, tasty-quickcheck, temporary, text
, transformers, unix, unliftio, unliftio-core, unordered-containers, vector
, vector-instances, vty, wl-pprint-annotated, word8, yaml, extra, ListLike
}:

mkDerivation rec {
  pname = "echidna";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "0sn6yh9994lqz7qmmx3r89lysrxwj3812m9d3lk85pbysk6nxypb";
  };

  libraryHaskellDepends = [
    aeson ansi-terminal base base16-bytestring binary brick bytestring
    containers data-dword data-has deepseq directory exceptions filepath
    hashable hevm lens lens-aeson megaparsec MonadRandom mtl
    optparse-applicative process random stm temporary text transformers
    unix unliftio unliftio-core unordered-containers vector vector-instances
    vty wl-pprint-annotated word8 yaml extra ListLike
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [ tasty tasty-hunit tasty-quickcheck ];
  # re-enable dynamic build on Linux, linker fails otherwise
  prePatch = ''
    substituteInPlace package.yaml \
      --replace 'condition: os(linux)' 'condition: false'
  '';
  preConfigure = "hpack";
  # tests require specific version of solc
  doCheck = false;

  description = "A Fast Smart Contract Fuzzer";
  homepage = "https://github.com/crytic/echidna";
  license = lib.licenses.agpl3;
  platforms = lib.platforms.unix;
  maintainers = with lib.maintainers; [ arturcygan ];
}
