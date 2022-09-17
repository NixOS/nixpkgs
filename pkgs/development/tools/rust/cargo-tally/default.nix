{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.13";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-9w3/zQqcHtZ91WDolAru9aNG9pV8HuXvujvp3NlOcgU=";
  };

  cargoSha256 = "sha256-CGP3KMJFDIl+MLzI9aQ2OM4tUuOQEtG4nET14zt7PD0=";

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
