{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.38";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OPl0/HhVMFp4EDEjBDjqVF5LGbz1T+0j/OiF8emHLxc=";
  };

  cargoHash = "sha256-Agdzm2uNJH59S+ok0AG3sYTs6tSEDoBgYEBXvgkNj0U=";

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
