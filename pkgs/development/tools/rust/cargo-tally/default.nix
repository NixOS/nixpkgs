{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.31";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-2V2JXSlFzYoSidByWGFTGwNHM9c5Go1cdHLp0b7N+hI=";
  };

  cargoHash = "sha256-mcYAqzfZO0M/UQTeYp4eCD7VVIWhtHi7VxBZtrr/aCk=";

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
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
