{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, deepseq-generics, directory, doctest, filepath, hackage-db
, hashable, hspec, language-nix, lens, pretty, process, QuickCheck
, SHA, split, stdenv, text, transformers, unordered-containers
, utf8-string, yaml, fetchFromGitHub
}:

mkDerivation rec {
  pname = "distribution-nixpkgs";
  version = "20150922";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "17s800yd8mm48yjjqiayvycaf8z0y1giwp8jp271875wdrx3p75a";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [
    aeson base bytestring Cabal containers deepseq-generics directory
    filepath hackage-db hashable language-nix lens pretty process SHA
    split text transformers unordered-containers utf8-string yaml
  ];
  testHaskellDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hashable hspec language-nix
    lens pretty process QuickCheck SHA split text transformers
    unordered-containers utf8-string yaml
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Data types and functions to manipulate the Nixpkgs distribution";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
