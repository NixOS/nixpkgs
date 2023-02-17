{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z6qmtZfnpEZ1/XkmAijDo4nRfZOPW9hEIFTycdOYILk=";
  };

  cargoSha256 = "sha256-EDdOnkOk5VIrzjJSTojdjmGAEDPMqW4PPE0JP+GUYnE=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
