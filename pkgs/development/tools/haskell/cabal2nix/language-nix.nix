{ mkDerivation, base, deepseq, doctest, lens, pretty, regex-posix
, stdenv, fetchFromGitHub, QuickCheck
}:

mkDerivation rec {
  pname = "language-nix";
  version = "20180903";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1qb7h4bgd1gv025hdbrpwaajpfkyz95id7br3k3danrj1havr9ja";
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
