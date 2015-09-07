{ mkDerivation, base, deepseq, doctest, fetchFromGitHub, lens
, pretty, QuickCheck, regex-posix, stdenv
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
    base deepseq doctest lens pretty QuickCheck regex-posix
  ];
  testHaskellDepends = [
    base deepseq doctest lens pretty QuickCheck regex-posix
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Data types and useful functions to represent and manipulate the Nix language";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
