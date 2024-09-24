{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.48";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BrWJKM7Vkvjlkn3PCBe45epQc2SkjKVlttQF0/AHSls=";
  };

  cargoHash = "sha256-Dkz3QJchUAn4/kQsmQcSfxVrRdiCA2qJSOTszfvE4No=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    DiskArbitration
    Foundation
    IOKit
  ]);

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
