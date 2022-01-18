{ lib, fetchFromGitHub, rustPlatform, nix }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "v${version}";
    sha256 = "sha256-D2ItR8z4LqEH1IL53vq/wPh9Pfe3eB0KsA79aLM/BWM=";
  };

  cargoSha256 = "sha256-71vH8oc8DmwbwM2PgxjGmWAbyC4AByx7waHxLsr2koI=";

  checkInputs = [ nix ];

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
