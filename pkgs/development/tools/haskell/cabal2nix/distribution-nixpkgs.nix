{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, deepseq-generics, directory, doctest, filepath, hackage-db, hspec
, language-nix, lens, lens-construction-helper, pretty, process
, SHA, split, stdenv, transformers, utf8-string, fetchFromGitHub
}:

mkDerivation rec {
  pname = "distribution-nixpkgs";
  version = "20150824-66-gd281a60";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1ffizg60ihkipcgqr5km4vxgnqv2pdw4716amqlxgf31wj59nyas";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec language-nix lens
    lens-construction-helper pretty process SHA split transformers
    utf8-string
  ];
  testHaskellDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec language-nix lens
    lens-construction-helper pretty process SHA split transformers
    utf8-string
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
