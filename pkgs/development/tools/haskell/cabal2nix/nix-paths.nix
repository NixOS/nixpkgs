{ mkDerivation, base, fetchFromGitHub, nix, stdenv }:

mkDerivation rec {
  pname = "nix-paths";
  version = "1";
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "cabal2nix";
    rev = "c475c17fa5f8dfc16c694fb0264486f94cbf2c5e";
    sha256 = "0skqdka1ibgwf33b23ibz93g5h6mbv31p1rbqz66j8qgxsvcgrkg";
  };
  postUnpack = "sourceRoot+=/${pname}";
  libraryHaskellDepends = [ base ];
  libraryToolDepends = [ nix ];
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Knowledge of Nix's installation directories";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ simons ];
}
