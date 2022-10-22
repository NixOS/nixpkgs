{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.16";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-AOvZEfDjsDAj4ZlrTB5a7dregPffhE4/xpdy1ZtvZCI=";
  };

  cargoSha256 = "sha256-94f76eHYaMoDEWATtvap4wPbpJkLq49Fsp579eoxlBs=";

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
