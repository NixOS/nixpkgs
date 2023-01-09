{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N5PRwUSUAFwvbyq5Uo6nEr05QqmeA1yI9ru0VRnrXa8=";
  };

  cargoSha256 = "sha256-vzru7+EA41kQGciA4q03bvcIYOMGYLAiws35ZMh413g=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
