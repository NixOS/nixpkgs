{ mkDerivation
, fetchFromGitHub
, aeson
, base
, bytestring
, containers
, hspec
, HUnit
, lib
, megaparsec
, optparse-applicative
, pandoc-types
, parser-combinators
, text
, these
, transformers
, vector
}:

mkDerivation rec {
  pname = "neorg-haskell-parser";
  version = "unstable-2023-03-17";

  src = fetchFromGitHub {
    owner = "Simre1";
    repo = pname;
    rev = "685cd09f5ac7ff06dac4609a30eca3db693cf548";
    hash = "sha256-8EmRGUWyaP9cBGwlNBO5vJXBCCNK6691tPX7gbTulNo=";
  };

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    bytestring
    containers
    megaparsec
    parser-combinators
    text
    these
    transformers
    vector
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    containers
    optparse-applicative
    pandoc-types
    text
    transformers
  ];
  testHaskellDepends = [
    base
    hspec
    HUnit
    text
    these
  ];
  mainProgram = "neorg-pandoc";

  description = "Neorg Haskell Parser aims to be a complete implementation of the Neorg markup specification";
  homepage = "https://github.com/Simre1/neorg-haskell-parser";
  license = lib.licenses.mit;
  maintainers = with maintainers; [ GaetanLepage ];
}
