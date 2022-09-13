{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-v9nAiV3t/l6B+a7hzq4IYOetrNM5f22+nEIQncLs5tU=";
  };

  cargoSha256 = "sha256-/PypVUT6n2pdsWIN+5EGHmj/UlfguvlbufBlHvuROg8=";

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
