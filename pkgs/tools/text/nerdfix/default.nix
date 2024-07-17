{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-5pUFj3K4yH/M8F+ZpCHFO3gEfxQ4pwxRa6uJbejrQxQ=";
  };

  cargoHash = "sha256-6S6NyX2hmkekgpuLaBjBxoybnqJpJXtqelJ+6YzxA0I=";

  meta = with lib; {
    description = "Nerdfix helps you to find/fix obsolete nerd font icons in your project";
    mainProgram = "nerdfix";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
