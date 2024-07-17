{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-qFx87AVGi42OCFCvksgiLh+NkXNgzfPxjcP0zDeC1is=";
  };

  cargoHash = "sha256-IsUlTSv2QcO67FpN0eAK1gKLJelr9sfX8DefcmzHbcc=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
