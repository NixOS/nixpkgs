{ callPackage, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "unstable-2021-07-18";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "1fdd7cf9bf56b8ad2dddcfd27354dae8aef2b453";

    sha256 = "sha256-w0hpyFXxltmOpbBKNQ2tfKRWELQzStc/ho1EcNyYaWc=";
  };

  cargoSha256 = "sha256-X6eCwi2zxEUZA54SIHiqjLOXGIfxwoAVe7VdCnBe7TE=";

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
