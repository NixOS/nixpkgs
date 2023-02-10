{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.22";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-h3w9xxzExDojJw2OIPMT9lQ/lzYQNf9WJVHBP+tOnPw=";
  };

  cargoSha256 = "sha256-EPYfmRms00AE4NkmOJBnIKYOCFbjd2qwRi6/i09hQ6U=";

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
