{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.26";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ojfDujEnwMwzgGklrR5iYJzRzOwn08vmAC1/v6N93kg=";
  };

  cargoSha256 = "sha256-aYZsMyMz5IpkOontFQ2g09F+UjTmluOAlrbD+4etxKw=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    DiskArbitration
    Foundation
    IOKit
  ]);

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
