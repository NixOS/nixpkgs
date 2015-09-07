{ mkDerivation, base, deepseq, doctest, lens, pretty, regex-posix
, stdenv, fetchFromGitHub, QuickCheck
}:

mkDerivation rec {
  pname = "language-nix";
  version = "20150903";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1cniaymgwz96bjchan49jv627wjbymc3vs48w1p19qj2k9rly6q7";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [
    base deepseq lens pretty regex-posix
  ];
  testHaskellDepends = [
    base deepseq doctest lens pretty regex-posix QuickCheck
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Data types and useful functions to represent and manipulate the Nix language";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
