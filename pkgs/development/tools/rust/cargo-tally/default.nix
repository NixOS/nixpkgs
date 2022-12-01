{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.17";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-vtVE7BITzYP9vhSj7HfDm0Mar2bRPmeW1/mE977vvrA=";
  };

  cargoSha256 = "sha256-VHlnRk5EXZjf+EW/clDOFA+ohh9SqJiRvq1xQcP0Wrk=";

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
