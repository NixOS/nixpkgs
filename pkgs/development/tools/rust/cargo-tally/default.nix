{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.45";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-d0v34CUm3r9QScxrc5aKSLpNLPTK+OHAZ7JdS9A4lAw=";
  };

  cargoHash = "sha256-QNVySY5IEGXdRBwJDG2eLZ+u28X/qYcdCkFiBCpgNhE=";

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
