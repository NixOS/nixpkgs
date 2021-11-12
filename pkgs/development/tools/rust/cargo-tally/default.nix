{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "16r60ddrqsss5nagfb5g49md8wwm4zbp9sffbm23bhlqhxh35y0i";
  };

  cargoSha256 = "0ffq67vy0pa7va8j93g03bralz7lck6ds1hidbpzzkp13pdcgf97";

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
