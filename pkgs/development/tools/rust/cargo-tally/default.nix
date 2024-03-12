{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.40";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X+Tbse4svpGCQuspmfMv3iMJRCbX4LVB+rfYrFlOy98=";
  };

  cargoHash = "sha256-+/6Cwonu/W17ZhAqp902hUeonPZ4DOuC+Z4Ix16pNkY=";

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
