{ stdenv, lib, fetchFromGitHub, rustPlatform, nix }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "v${version}";
    sha256 = "sha256-WXpj2fgduYlF4t0QEvdfV1Eft8/nFXWF2zyEBKMUEIk=";
  };

  cargoSha256 = "sha256-LfbmOhZJVthsLm8lnzHvEt7Vy27y4w4wpPfrf/s3s84=";

  checkInputs = lib.optional (!stdenv.isDarwin) nix;

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
