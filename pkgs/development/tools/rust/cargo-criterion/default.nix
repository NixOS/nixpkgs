{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-criterion";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bheisler";
    repo = pname;
    rev = version;
    sha256 = "0czagclrn4yhlvlh06wsyiybz69r7mmk3182fywzn9vd0xlclxpi";
  };

  cargoSha256 = "sha256-XZuZ81hB/GQDopJyfSkxQiehSwJz7VWoJR6/m3WLil8=";

  meta = with lib; {
    description = "Cargo extension for running Criterion.rs benchmarks";
    homepage = "https://github.com/bheisler/cargo-criterion";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ humancalico ];
  };
}
