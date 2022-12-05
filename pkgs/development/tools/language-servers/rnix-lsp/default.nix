{ stdenv, lib, fetchFromGitHub, rustPlatform, nix }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "unstable-2022-11-27";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "95d40673fe43642e2e1144341e86d0036abd95d9";
    sha256 = "sha256-F0s0m62S5bHNVWNHLZD6SeHiLrsDx98VQbRjDyIu+qQ=";
  };

  cargoSha256 = "sha256-RKHBp+/bEH9FEPLcf1MKmTugk1A8rQU447mNm9Le3DE=";

  checkInputs = lib.optional (!stdenv.isDarwin) nix;

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
