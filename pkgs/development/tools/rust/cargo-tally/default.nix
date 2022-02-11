{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-m5NLI0C7ett5Fmvs9t1vl2W6h7mjCtEFBc1AzYg9JfY=";
  };

  cargoSha256 = "sha256-AxjQUyxX5lLFPdEdETvZLHbgMYg/xOo7bcqn1TiDKsE=";

  buildInputs = lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    IOKit
  ];

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
