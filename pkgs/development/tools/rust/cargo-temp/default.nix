{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g9ddzvgrb45ddflbcwpq320zwj4qrxfs07dydy6r86whdn1mlc0";
  };

  cargoSha256 = "sha256-5E1Fkipqb2nONQNAuj9xKn8k2PhH9IZ48UosNlPpP6c=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
