{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.15";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-vrDPFJB0/kRSZot8LdYO6lPI8oR5G4CZv6Z31gF7XII=";
  };

  cargoSha256 = "sha256-dkCfOTZCu9MgqvKJRWwyVfCu1Ul0wDCJznM+N2hPpwo=";

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
