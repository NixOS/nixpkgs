{ mkDerivation, base, data-default-class, deepseq-generics, lens
, lens-construction-helper, pretty, regex-posix, stdenv, fetchFromGitHub
}:

mkDerivation rec {
  pname = "language-nix";
  version = "20150824-66-gd281a60";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1ffizg60ihkipcgqr5km4vxgnqv2pdw4716amqlxgf31wj59nyas";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [
    base data-default-class deepseq-generics lens
    lens-construction-helper pretty regex-posix
  ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Data types and useful functions to represent and manipulate the Nix language";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
