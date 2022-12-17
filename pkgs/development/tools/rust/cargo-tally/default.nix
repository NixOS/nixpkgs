{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.19";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-TlHb974Dtmz5qW+4L3BE6GQ3SbkwtIrZxE6FpJrgNdY=";
  };

  cargoSha256 = "sha256-np1rln9tD+J4s410/Pv4/eKAxyzK8qtLoON86JR1T94=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    DiskArbitration
    Foundation
    IOKit
  ]);

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
