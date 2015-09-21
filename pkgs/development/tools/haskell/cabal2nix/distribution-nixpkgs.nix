{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, deepseq-generics, directory, doctest, fetchFromGitHub, filepath
, hackage-db, hspec, language-nix, lens, pretty, process, SHA
, split, stdenv, transformers, utf8-string
}:

mkDerivation rec {
  pname = "distribution-nixpkgs";
  version = "20150903";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1cniaymgwz96bjchan49jv627wjbymc3vs48w1p19qj2k9rly6q7";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec language-nix lens
    pretty process SHA split transformers utf8-string
  ];
  testHaskellDepends = [
    aeson base bytestring Cabal containers deepseq deepseq-generics
    directory doctest filepath hackage-db hspec language-nix lens
    pretty process SHA split transformers utf8-string
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
