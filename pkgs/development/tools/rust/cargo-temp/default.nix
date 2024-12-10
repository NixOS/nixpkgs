{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-8VkhEpggSoE0DIdZk8Y1fCYAwN6CZd2nK6auWRIbS6w=";
  };

  cargoHash = "sha256-fYpG/Bl3hsbkWWTkbX59UqD/HuL9OpmcZc6hPAmnNtM=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
