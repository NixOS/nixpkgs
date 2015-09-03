{ mkDerivation, base, data-default-class, fetchFromGitHub, lens, stdenv }:

mkDerivation rec {
  pname = "lens-construction-helper";
  version = "20150824-66-gd281a60";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "v${version}";
    sha256 = "1ffizg60ihkipcgqr5km4vxgnqv2pdw4716amqlxgf31wj59nyas";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [ base data-default-class lens ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Use data-default to create default instances of various types";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
