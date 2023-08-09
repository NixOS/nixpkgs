{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.28";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-vPOQC/bpjmjQzHZZHVMTil2XqIbKhxb7461dWCgySQk=";
  };

  cargoSha256 = "sha256-SL9fIZpMG+XfNHV0xEQyrm13MphIWv6I/cFUOVrA6bA=";

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
