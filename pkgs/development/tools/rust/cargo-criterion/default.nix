{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-criterion";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bheisler";
    repo = pname;
    rev = version;
    sha256 = "sha256-NiuK+PexfF2wmA8drqqkv/RQlVwYLT3q2QWvV0ghJwg=";
  };

  cargoSha256 = "sha256-A6Kkm/4MSAEJfehA6zSQJU+JwVIhKPcfMZCO9S6Zyx4=";

  meta = with lib; {
    description = "Cargo extension for running Criterion.rs benchmarks";
    homepage = "https://github.com/bheisler/cargo-criterion";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ humancalico ];
  };
}
