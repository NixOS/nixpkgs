{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-supply-chain";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kpm842p7l0vwbfa99zq3w3nsasy5sp1b99si7brjjvq99bad9gr";
  };

  cargoSha256 = "sha256-Mn5s6pfTHoFXtHqn6ii8PtAIBz/RJaR0zO5U5jS3UDU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/master/CHANGELOG.md";
    license = with licenses; [ asl20 mit zlib ]; # any of three
    maintainers = with maintainers; [ figsoda ];
  };
}
