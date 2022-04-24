{ stdenv, lib, fetchFromGitHub, rustPlatform, nix }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "v${version}";
    sha256 = "sha256-MfD07ugYYbcRaNoLxOcH9+SPbRewNxbHJA5blCSb4EM=";
  };

  cargoSha256 = "sha256-23TJrJyfCuoOOOjZeWQnF/Ac0Xv2k6tZduuzapKvsgg=";

  checkInputs = lib.optional (!stdenv.isDarwin) nix;

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
