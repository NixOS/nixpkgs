{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, deepseq-generics, directory, doctest, filepath, hackage-db
, hashable, hspec, language-nix, lens, pretty, process, QuickCheck
, SHA, split, stdenv, text, transformers, unordered-containers
, utf8-string, yaml, fetchFromGitHub
}:

mkDerivation rec {
  pname = "distribution-nixpkgs";
  version = "1";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v20160613";
    sha256 = "0cnc037qsmwwddws138z7w1aww0l9z5bg89dgh4vfxck29z84is9";
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
  maintainers = with stdenv.lib.maintainers; [ peti ];
}
