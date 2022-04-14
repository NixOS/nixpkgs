{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-GUH/qWAC1vBLVV3K/qjkABH1agkyJEuhZGds+8UP1kQ=";
  };

  cargoSha256 = "sha256-qvWJvkNG7rPHvv2hqJrOyZOqqAhRvgWdrkgr/Tefnps=";

  buildInputs = lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    IOKit
  ];

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
