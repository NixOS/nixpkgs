{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-criterion";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bheisler";
    repo = pname;
    rev = version;
    sha256 = "sha256-RPix9DM6E32PhObvV3xPGrnXrrVHn3auxLUhysP8GM0=";
  };

  cargoSha256 = "sha256-L/ILHKWlcYTkbEi2qDu7tf/3NHfTl6GhW0s+fUlsW08=";

  meta = with lib; {
    description = "Cargo extension for running Criterion.rs benchmarks";
    mainProgram = "cargo-criterion";
    homepage = "https://github.com/bheisler/cargo-criterion";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ humancalico matthiasbeyer ];
  };
}
