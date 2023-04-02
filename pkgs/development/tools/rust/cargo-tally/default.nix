{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.24";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-oMqmivRKnrhkvGnkj9fmFUhqkh846lABfAWg/6+a/yM=";
  };

  cargoSha256 = "sha256-mZ7EV3ZnmfhGOmmUUEHX71ssHNBT6u1l4U7H/b727hE=";

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
