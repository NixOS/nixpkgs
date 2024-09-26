{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-gsrmHCj9DC6OkGS0CD/NE2UMc/9TdjA2In6f3iKXMOg=";
  };

  cargoHash = "sha256-ryvv4SuhxIXPJKa3WLdjNQZAP+JLAjWtrCfWXUm+WVg=";

  meta = with lib; {
    description = "CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
