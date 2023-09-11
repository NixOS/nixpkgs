{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-JUpXLdFaG653u9a4Nq7TC1ZNEcZ0QzgYMjGS8Kam0ec=";
  };

  cargoHash = "sha256-7yPvHCmdokb/oJqR3h+RJOQbE/pcrIDBltnG5zfoqMk=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
