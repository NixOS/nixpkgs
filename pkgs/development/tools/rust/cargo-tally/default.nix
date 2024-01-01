{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.33";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8tOADZV1Kz9o+1fEMOH8/ZX7Fj4uxTdHV5xoa6DXzwM=";
  };

  cargoHash = "sha256-hvVDnBD4MI+yzG/vCGhMlOHZRLYiAsCKZDD5tPaaPhg=";

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
